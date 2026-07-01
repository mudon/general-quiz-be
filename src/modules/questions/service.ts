import { pool } from '../../db/pool';
import { AppError } from '../auth/service';

// ---- types ----

export interface QuestionRow {
  question_id: string;
  category_id: string;
  question_text: string;
  question_type: 'single_choice' | 'multiple_choice' | 'fill_in_blank';
  explanation: string | null;
  category_path: string;
  category_name: string;
  single_choice_answer: string | null;
  multiple_choice_answer: string[] | null;
  fill_in_answer: string | null;
  fill_in_alternatives: string[] | null;
  options: OptionItem[] | null;
}

export interface OptionItem {
  id: string;
  text: string;
  sort_order: number;
}

export interface QuestionSummary {
  id: string;
  categoryId: string;
  categoryName: string;
  categoryPath: string;
  questionText: string;
  questionType: 'single_choice' | 'multiple_choice' | 'fill_in_blank';
  explanation: string | null;
  options: OptionItem[] | null;
  createdAt: string;
}

export interface QuestionDetail extends QuestionSummary {
  answer: QuestionAnswer;
}

export type QuestionAnswer =
  | { type: 'single_choice'; correctOptionId: string }
  | { type: 'multiple_choice'; correctOptionIds: string[] }
  | { type: 'fill_in_blank'; answer: string; alternatives: string[] | null };

export interface CreateQuestionInput {
  categoryId: string;
  questionText: string;
  questionType: 'single_choice' | 'multiple_choice' | 'fill_in_blank';
  explanation?: string | null;
  options?: { text: string; sortOrder?: number }[];
  answer: QuestionAnswerInput;
}

export type QuestionAnswerInput =
  | { optionIndex: number }
  | { optionIndices: number[] }
  | { text: string; alternatives?: string[] };

export interface QuestionListFilters {
  categoryId?: string;
  type?: string;
  search?: string;
  cursor?: string;
  limit?: number;
}

// ---- mappers ----

function mapOptions(options: OptionItem[] | null): OptionItem[] | null {
  if (!options) return null;
  return options.map(o => ({ id: o.id, text: o.text, sort_order: o.sort_order }));
}

function mapQuestionSummary(row: QuestionRow): QuestionSummary {
  return {
    id: row.question_id,
    categoryId: row.category_id,
    categoryName: row.category_name,
    categoryPath: row.category_path,
    questionText: row.question_text,
    questionType: row.question_type,
    explanation: row.explanation,
    options: mapOptions(row.options),
    createdAt: row.created_at,
  };
}

function mapAnswer(row: QuestionRow): QuestionAnswer {
  switch (row.question_type) {
    case 'single_choice':
      return { type: 'single_choice', correctOptionId: row.single_choice_answer! };
    case 'multiple_choice':
      return { type: 'multiple_choice', correctOptionIds: row.multiple_choice_answer ?? [] };
    case 'fill_in_blank':
      return {
        type: 'fill_in_blank',
        answer: row.fill_in_answer!,
        alternatives: row.fill_in_alternatives,
      };
  }
}

// ---- queries ----

const QUESTION_FULL_BASE = `
  SELECT qf.*, row_to_json(qf) -> 'options' AS options_json
  FROM question_full qf
`;

export async function getList(filters: QuestionListFilters) {
  const conditions: string[] = [];
  const params: unknown[] = [];
  let paramIdx = 1;

  if (filters.categoryId) {
    // filter by category AND all subcategories using ltree
    conditions.push(`qf.category_path <@ (SELECT path FROM categories WHERE id = $${paramIdx++})`);
    params.push(filters.categoryId);
  }

  if (filters.type) {
    conditions.push(`qf.question_type = $${paramIdx++}::question_type`);
    params.push(filters.type);
  }

  if (filters.search) {
    conditions.push(`to_tsvector('english', qf.question_text) @@ plainto_tsquery('english', $${paramIdx++})`);
    params.push(filters.search);
  }

  const where = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';
  const limit = Math.min(filters.limit ?? 20, 100);
  const take = limit + 1;

  // cursor pagination: WHERE id > cursor ORDER BY id
  let cursorClause = '';
  if (filters.cursor) {
    cursorClause = conditions.length > 0
      ? `AND qf.question_id > $${paramIdx++}`
      : `WHERE qf.question_id > $${paramIdx++}`;
    params.push(filters.cursor);
  }

  const result = await pool.query<QuestionRow>(
    `SELECT qf.* FROM question_full qf ${where} ${cursorClause} ORDER BY qf.question_id LIMIT $${paramIdx++}`,
    [...params, take]
  );

  const rows = result.rows;
  const hasMore = rows.length > limit;
  const items = hasMore ? rows.slice(0, limit) : rows;

  return {
    items: items.map(mapQuestionSummary),
    nextCursor: items.length > 0 ? items[items.length - 1]!.id : null,
    hasMore,
  };
}

export async function getById(id: string): Promise<QuestionSummary> {
  const result = await pool.query<QuestionRow>(
    `SELECT qf.* FROM question_full qf WHERE qf.question_id = $1`,
    [id]
  );

  if (!result.rowCount || result.rowCount === 0) {
    throw new AppError(404, 'Question not found');
  }

  return mapQuestionSummary(result.rows[0]!);
}

export async function getByIdAdmin(id: string): Promise<QuestionDetail> {
  const result = await pool.query<QuestionRow>(
    `SELECT qf.* FROM question_full qf WHERE qf.question_id = $1`,
    [id]
  );

  if (!result.rowCount || result.rowCount === 0) {
    throw new AppError(404, 'Question not found');
  }

  const row = result.rows[0]!;
  return { ...mapQuestionSummary(row), answer: mapAnswer(row) };
}

export async function create(input: CreateQuestionInput): Promise<QuestionDetail> {
  // validate category exists
  const cat = await pool.query('SELECT id FROM categories WHERE id = $1', [input.categoryId]);
  if (!cat.rowCount || cat.rowCount === 0) {
    throw new AppError(404, 'Category not found');
  }

  const client = await pool.connect();
  try {
    await client.query('BEGIN');

    // 1. insert question
    const qResult = await client.query<{ id: string }>(
      `INSERT INTO questions (category_id, question_text, question_type, explanation)
       VALUES ($1, $2, $3, $4) RETURNING id`,
      [input.categoryId, input.questionText, input.questionType, input.explanation ?? null]
    );
    const questionId = qResult.rows[0]!.id;

    // 2. insert options (single_choice / multiple_choice)
    if (input.questionType !== 'fill_in_blank' && input.options) {
      for (let i = 0; i < input.options.length; i++) {
        const opt = input.options[i]!;
        await client.query(
          `INSERT INTO question_options (question_id, option_text, sort_order)
           VALUES ($1, $2, $3)`,
          [questionId, opt.text, opt.sortOrder ?? i]
        );
      }
    }

    // 3. insert answer (triggers sync question_type automatically)
    if (input.questionType === 'single_choice') {
      const a = input.answer as { optionIndex: number };
      const opts = await client.query<{ id: string }>(
        'SELECT id FROM question_options WHERE question_id = $1 ORDER BY sort_order',
        [questionId]
      );
      const correctOptId = opts.rows[a.optionIndex]?.id;
      if (!correctOptId) {
        throw new AppError(400, `Invalid optionIndex: ${a.optionIndex} (found ${opts.rows.length} options)`);
      }

      await client.query(
        `INSERT INTO answers (question_id, single_choice_answer) VALUES ($1, $2)`,
        [questionId, correctOptId]
      );

    } else if (input.questionType === 'multiple_choice') {
      const a = input.answer as { optionIndices: number[] };
      if (!a.optionIndices || a.optionIndices.length === 0) {
        throw new AppError(400, 'Multiple choice requires at least one correct option');
      }

      const opts = await client.query<{ id: string }>(
        'SELECT id FROM question_options WHERE question_id = $1 ORDER BY sort_order',
        [questionId]
      );

      const ansResult = await client.query<{ id: string }>(
        `INSERT INTO answers (question_id) VALUES ($1) RETURNING id`,
        [questionId]
      );
      const answerId = ansResult.rows[0]!.id;

      for (const idx of a.optionIndices) {
        const optId = opts.rows[idx]?.id;
        if (!optId) {
          throw new AppError(400, `Invalid optionIndices: index ${idx} out of range`);
        }
        await client.query(
          `INSERT INTO multiple_choice_answer_options (answer_id, option_id) VALUES ($1, $2)`,
          [answerId, optId]
        );
      }

    } else if (input.questionType === 'fill_in_blank') {
      const a = input.answer as { text: string; alternatives?: string[] };
      if (!a.text) {
        throw new AppError(400, 'Fill-in-the-blank requires an answer text');
      }

      await client.query(
        `INSERT INTO answers (question_id, fill_in_answer, fill_in_alternatives) VALUES ($1, $2, $3)`,
        [questionId, a.text, a.alternatives ?? null]
      );
    }

    await client.query('COMMIT');

    return await getByIdAdmin(questionId);
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
}

export async function update(
  id: string,
  data: { categoryId?: string; questionText?: string; explanation?: string | null }
): Promise<QuestionSummary> {
  const sets: string[] = [];
  const params: unknown[] = [];
  let paramIdx = 1;

  if (data.categoryId !== undefined) {
    sets.push(`category_id = $${paramIdx++}`);
    params.push(data.categoryId);
  }
  if (data.questionText !== undefined) {
    sets.push(`question_text = $${paramIdx++}`);
    params.push(data.questionText);
  }
  if (data.explanation !== undefined) {
    sets.push(`explanation = $${paramIdx++}`);
    params.push(data.explanation);
  }

  if (sets.length === 0) return await getById(id);

  params.push(id);
  await pool.query(
    `UPDATE questions SET ${sets.join(', ')} WHERE id = $${paramIdx}`,
    params
  );

  return await getById(id);
}

export async function remove(id: string): Promise<void> {
  const result = await pool.query('DELETE FROM questions WHERE id = $1', [id]);
  if (!result.rowCount || result.rowCount === 0) {
    throw new AppError(404, 'Question not found');
  }
}

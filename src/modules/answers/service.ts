import { pool } from '../../db/pool';
import { AppError } from '../auth/service';
import { upsertStats } from '../stats/service';
import { checkAndAwardBadges } from '../badges/award';

// ---- types ----

export interface SubmitAnswerInput {
  submittedSingleChoice?: string;
  submittedMultipleChoice?: string[];
  submittedFillIn?: string;
}

export interface AnswerResult {
  id: string;
  isCorrect: boolean;
  newBadges: string[];
  questionText: string;
  questionType: string;
  explanation: string | null;
  correctAnswer: {
    singleChoiceAnswer?: string | null;
    multipleChoiceAnswer?: string[] | null;
    fillInAnswer?: string | null;
    fillInAlternatives?: string[] | null;
  };
  options: {
    id: string;
    text: string;
    sortOrder: number;
  }[] | null;
}

export interface DueReviewItem {
  questionId: string;
  questionText: string;
  questionType: string;
  categoryId: string;
  dueAt: string;
  intervalDays: number;
  repetitions: number;
  lapses: number;
  options: {
    id: string;
    text: string;
    sortOrder: number;
  }[] | null;
}

export interface HistoryItem {
  id: string;
  questionId: string;
  questionText: string;
  questionType: string;
  categoryId: string;
  categoryName: string;
  submittedSingleChoice: string | null;
  submittedMultipleChoice: string[] | null;
  submittedFillIn: string | null;
  isCorrect: boolean;
  answeredAt: string;
}

export interface PaginatedResult<T> {
  items: T[];
  nextCursor: string | null;
  hasMore: boolean;
}

// ---- submit answer ----

export async function submitAnswer(userId: string, questionId: string, input: SubmitAnswerInput): Promise<AnswerResult> {
  // get question type
  const question = await pool.query<{ question_type: string; question_text: string; explanation: string | null; category_id: string }>(
    `SELECT question_type, question_text, explanation, category_id FROM questions WHERE id = $1`,
    [questionId]
  );
  if (!question.rowCount || question.rowCount === 0) {
    throw new AppError(404, 'Question not found');
  }

  const qtype = question.rows[0]!.question_type;

  // validate submission matches question type
  if (qtype === 'single_choice' && !input.submittedSingleChoice) {
    throw new AppError(400, 'single_choice questions require submittedSingleChoice');
  }
  if (qtype === 'multiple_choice' && (!input.submittedMultipleChoice || input.submittedMultipleChoice.length === 0)) {
    throw new AppError(400, 'multiple_choice questions require submittedMultipleChoice (non-empty array)');
  }
  if (qtype === 'fill_in_blank' && !input.submittedFillIn) {
    throw new AppError(400, 'fill_in_blank questions require submittedFillIn');
  }

  // insert answer — triggers handle sync, grade, review_schedule
  const result = await pool.query<{ id: string; is_correct: boolean }>(
    `INSERT INTO user_answers (user_id, question_id, submitted_single_choice, submitted_multiple_choice, submitted_fill_in)
     VALUES ($1, $2, $3, $4, $5)
     RETURNING id, is_correct`,
    [
      userId,
      questionId,
      qtype === 'single_choice' ? input.submittedSingleChoice ?? null : null,
      qtype === 'multiple_choice' ? input.submittedMultipleChoice ?? null : null,
      qtype === 'fill_in_blank' ? input.submittedFillIn ?? null : null,
    ]
  );

  const submitted = result.rows[0]!;

  // update stats — only on the FIRST answer for this question
  const prior = await pool.query(
    `SELECT 1 FROM user_answers WHERE user_id = $1 AND question_id = $2 AND id != $3`,
    [userId, questionId, submitted.id]
  );
  if (!prior.rowCount || prior.rowCount === 0) {
    upsertStats(userId, question.rows[0]!.category_id, submitted.is_correct);
  }

  // increment active quiz sessions that include this question's category
  await pool.query(
    `UPDATE quiz_sessions qs
     SET answered_count = answered_count + 1,
         correct_count = correct_count + CASE WHEN $1 THEN 1 ELSE 0 END
     WHERE qs.user_id = $2
       AND qs.completed_at IS NULL
       AND EXISTS (
         SELECT 1 FROM questions q
         JOIN categories c ON c.id = q.category_id
         WHERE q.id = $3
           AND c.path <@ (SELECT path FROM categories WHERE id = qs.category_id)
       )`,
    [submitted.is_correct, userId, questionId]
  );

  // check & auto-award badges
  const newBadges = await checkAndAwardBadges(userId);

  // fetch correct answer + options for response
  const full = await pool.query<{
    single_choice_answer: string | null;
    multiple_choice_answer: string[] | null;
    fill_in_answer: string | null;
    fill_in_alternatives: string[] | null;
    options: { id: string; text: string; sort_order: number }[] | null;
  }>(
    `SELECT single_choice_answer, multiple_choice_answer, fill_in_answer, fill_in_alternatives, options
     FROM question_full WHERE question_id = $1`,
    [questionId]
  );

  const correct = full.rows[0]!;

  return {
    id: submitted.id,
    isCorrect: submitted.is_correct,
    newBadges,
    questionText: question.rows[0]!.question_text,
    questionType: qtype,
    explanation: question.rows[0]!.explanation,
    correctAnswer: {
      singleChoiceAnswer: correct.single_choice_answer,
      multipleChoiceAnswer: correct.multiple_choice_answer,
      fillInAnswer: correct.fill_in_answer,
      fillInAlternatives: correct.fill_in_alternatives,
    },
    options: correct.options?.map(o => ({
      id: o.id,
      text: o.text,
      sortOrder: o.sort_order,
    })) ?? null,
  };
}

// ---- due for review ----

export async function getDueForReview(userId: string, cursor?: string, limit = 20): Promise<PaginatedResult<DueReviewItem>> {
  const take = Math.min(limit, 100) + 1;
  const params: unknown[] = [userId];
  let paramIdx = 2;

  let cursorClause = '';
  if (cursor) {
    cursorClause = `AND dfr.question_id > $${paramIdx++}`;
    params.push(cursor);
  }

  const result = await pool.query<{
    question_id: string;
    question_text: string;
    question_type: string;
    category_id: string;
    due_at: string;
    interval_days: number;
    repetitions: number;
    lapses: number;
  }>(
    `SELECT dfr.* FROM due_for_review dfr
     WHERE dfr.user_id = $1 ${cursorClause}
     ORDER BY dfr.question_id
     LIMIT $${paramIdx}`,
    [...params, take]
  );

  const rows = result.rows;
  const hasMore = rows.length > limit;
  const items = hasMore ? rows.slice(0, limit) : rows;

  // fetch options for each question
  const questionIds = items.map(i => i.question_id);
  let optionsMap = new Map<string, { id: string; text: string; sort_order: number }[]>();

  if (questionIds.length > 0) {
    const optResult = await pool.query<{
      question_id: string; id: string; option_text: string; sort_order: number;
    }>(
      `SELECT question_id, id, option_text, sort_order
       FROM question_options WHERE question_id = ANY($1)
       ORDER BY sort_order`,
      [questionIds]
    );
    for (const o of optResult.rows) {
      const arr = optionsMap.get(o.question_id) ?? [];
      arr.push({ id: o.id, text: o.option_text, sort_order: o.sort_order });
      optionsMap.set(o.question_id, arr);
    }
  }

  return {
    items: items.map(i => ({
      questionId: i.question_id,
      questionText: i.question_text,
      questionType: i.question_type,
      categoryId: i.category_id,
      dueAt: i.due_at,
      intervalDays: i.interval_days,
      repetitions: i.repetitions,
      lapses: i.lapses,
      options: (optionsMap.get(i.question_id) ?? null)?.map(o => ({
        id: o.id,
        text: o.text,
        sortOrder: o.sort_order,
      })) ?? null,
    })),
    nextCursor: items.length > 0 ? items[items.length - 1]!.question_id : null,
    hasMore,
  };
}

// ---- answer history ----

export async function getHistory(userId: string, cursor?: string, limit = 20): Promise<PaginatedResult<HistoryItem>> {
  const take = Math.min(limit, 100) + 1;
  const params: unknown[] = [userId];
  let paramIdx = 2;

  let cursorClause = '';
  if (cursor) {
    cursorClause = `AND ua.id < $${paramIdx++}`;
    params.push(cursor);
  }

  const result = await pool.query<{
    id: string;
    question_id: string;
    question_text: string;
    question_type: string;
    category_id: string;
    category_name: string;
    submitted_single_choice: string | null;
    submitted_multiple_choice: string[] | null;
    submitted_fill_in: string | null;
    is_correct: boolean;
    answered_at: string;
  }>(
    `SELECT ua.id, ua.question_id, q.question_text, q.question_type,
            q.category_id, c.name AS category_name,
            ua.submitted_single_choice, ua.submitted_multiple_choice,
            ua.submitted_fill_in, ua.is_correct, ua.answered_at
     FROM user_answers ua
     JOIN questions q ON q.id = ua.question_id
     JOIN categories c ON c.id = q.category_id
     WHERE ua.user_id = $1 ${cursorClause}
     ORDER BY ua.id DESC
     LIMIT $${paramIdx}`,
    [...params, take]
  );

  const rows = result.rows;
  const hasMore = rows.length > limit;
  const items = hasMore ? rows.slice(0, limit) : rows;

  return {
    items: items.map(i => ({
      id: i.id,
      questionId: i.question_id,
      questionText: i.question_text,
      questionType: i.question_type,
      categoryId: i.category_id,
      categoryName: i.category_name,
      submittedSingleChoice: i.submitted_single_choice,
      submittedMultipleChoice: i.submitted_multiple_choice,
      submittedFillIn: i.submitted_fill_in,
      isCorrect: i.is_correct,
      answeredAt: i.answered_at,
    })),
    nextCursor: items.length > 0 ? items[items.length - 1]!.id : null,
    hasMore,
  };
}

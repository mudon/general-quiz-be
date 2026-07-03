import { pool } from '../../db/pool';
import { AppError } from '../auth/service';
import type { OptionItem } from '../questions/service';

export interface SessionInfo {
  sessionId: string;
  categoryId: string;
  categoryName: string;
  totalQuestions: number;
  answeredCount: number;
  correctCount: number;
  createdAt: string;
  completedAt: string | null;
}

export interface NextQuestion {
  questionId: string;
  questionText: string;
  questionType: string;
  categoryId: string;
  categoryName: string;
  options: OptionItem[] | null;
  session: {
    totalQuestions: number;
    answeredCount: number;
    remainingCount: number;
  };
}

export async function createSession(userId: string, categoryId: string) {
  const cat = await pool.query<{ name: string; tier: number }>(
    'SELECT name, tier FROM categories WHERE id = $1', [categoryId]
  );
  if (!cat.rowCount || cat.rowCount === 0) throw new AppError(404, 'Category not found');

  const user = await pool.query<{ tier: number }>(
    'SELECT tier FROM users WHERE id = $1', [userId]
  );
  const userTier = user.rows[0]?.tier ?? 0;

  if (userTier < cat.rows[0]!.tier) {
    throw new AppError(403, 'Your subscription tier does not include this category. Upgrade to access.');
  }

  const count = await pool.query<{ c: string }>(
    `SELECT COUNT(*)::text AS c FROM questions q
     JOIN categories c2 ON c2.id = q.category_id
     WHERE c2.path <@ (SELECT path FROM categories WHERE id = $1)`,
    [categoryId]
  );

  const total = parseInt(count.rows[0]!.c, 10);

  const result = await pool.query<{
    id: string; created_at: string;
  }>(
    `INSERT INTO quiz_sessions (user_id, category_id, total_questions)
     VALUES ($1, $2, $3)
     RETURNING id, created_at`,
    [userId, categoryId, total]
  );

  const row = result.rows[0]!;

  return {
    sessionId: row.id,
    categoryId,
    categoryName: cat.rows[0]!.name,
    totalQuestions: total,
    answeredCount: 0,
    correctCount: 0,
    createdAt: row.created_at,
    completedAt: null,
  };
}

export async function resetSession(sessionId: string) {
  const ses = await pool.query<{ category_id: string }>(
    'SELECT category_id FROM quiz_sessions WHERE id = $1 AND completed_at IS NULL',
    [sessionId]
  );
  if (!ses.rowCount || ses.rowCount === 0) throw new AppError(404, 'Active session not found');

  const count = await pool.query<{ c: string }>(
    `SELECT COUNT(*)::text AS c FROM questions q
     JOIN categories c2 ON c2.id = q.category_id
     WHERE c2.path <@ (SELECT path FROM categories WHERE id = $1)`,
    [ses.rows[0]!.category_id]
  );

  const total = parseInt(count.rows[0]!.c, 10);

  await pool.query(
    `UPDATE quiz_sessions
     SET answered_count = 0, correct_count = 0, total_questions = $2, created_at = now()
     WHERE id = $1`,
    [sessionId, total]
  );

  return { message: 'Session reset', sessionId, totalQuestions: total };
}

export async function getActiveSessions(userId: string) {
  const result = await pool.query<{
    id: string; category_id: string; total_questions: number;
    created_at: string; completed_at: string | null;
    category_name: string;
    live_answered: string; live_correct: string;
  }>(
    `SELECT qs.id, qs.category_id, qs.total_questions,
            qs.created_at, qs.completed_at,
            c.name AS category_name,
            (SELECT COUNT(*)::text FROM user_answers ua
             WHERE ua.user_id = qs.user_id
               AND ua.answered_at > qs.created_at
               AND ua.question_id IN (
                 SELECT uq.id FROM questions uq
                 JOIN categories cs ON cs.id = uq.category_id
                 WHERE cs.path <@ (SELECT path FROM categories WHERE id = qs.category_id)
               )) AS live_answered,
            (SELECT COUNT(*)::text FROM user_answers ua
             WHERE ua.user_id = qs.user_id
               AND ua.answered_at > qs.created_at
               AND ua.is_correct = TRUE
               AND ua.question_id IN (
                 SELECT uq.id FROM questions uq
                 JOIN categories cs ON cs.id = uq.category_id
                 WHERE cs.path <@ (SELECT path FROM categories WHERE id = qs.category_id)
               )) AS live_correct
     FROM quiz_sessions qs
     JOIN categories c ON c.id = qs.category_id
     WHERE qs.user_id = $1 AND qs.completed_at IS NULL
     ORDER BY qs.created_at DESC`,
    [userId]
  );

  return result.rows.map(r => ({
    sessionId: r.id,
    categoryId: r.category_id,
    categoryName: r.category_name,
    totalQuestions: r.total_questions,
    answeredCount: parseInt(r.live_answered, 10),
    correctCount: parseInt(r.live_correct, 10),
    createdAt: r.created_at,
    completedAt: r.completed_at,
  }));
}

export async function getNextQuestion(sessionId: string) {
  const ses = await pool.query<{
    user_id: string; category_id: string; total_questions: number;
    answered_count: number; created_at: string; completed_at: string | null;
  }>(
    'SELECT * FROM quiz_sessions WHERE id = $1',
    [sessionId]
  );

  if (!ses.rowCount || ses.rowCount === 0) throw new AppError(404, 'Session not found');
  const session = ses.rows[0]!;

  if (session.completed_at) {
    throw new AppError(400, 'This quiz session is already completed');
  }

  // count answered during this session via user_answers timestamp
  const answeredResult = await pool.query<{ c: string }>(
    `SELECT COUNT(*)::text AS c FROM user_answers
     WHERE user_id = $1 AND answered_at > $2
       AND question_id IN (
         SELECT q.id FROM questions q
         JOIN categories c2 ON c2.id = q.category_id
         WHERE c2.path <@ (SELECT path FROM categories WHERE id = $3)
       )`,
    [session.user_id, session.created_at, session.category_id]
  );

  const answeredSoFar = parseInt(answeredResult.rows[0]!.c, 10);
  const remaining = session.total_questions - answeredSoFar;

  if (remaining <= 0) {
    // all done — complete the session
    await pool.query(
      'UPDATE quiz_sessions SET completed_at = now() WHERE id = $1',
      [sessionId]
    );
    return {
      completed: true,
      totalQuestions: session.total_questions,
      answeredCount: answeredSoFar,
    };
  }

  // pick a random unanswered question from the category tree
  const next = await pool.query<{
    question_id: string; question_text: string; question_type: string;
    category_id: string; category_name: string; options: OptionItem[] | null;
  }>(
    `SELECT qf.question_id, qf.question_text, qf.question_type,
            qf.category_id, qf.category_name,
            qf.options
     FROM question_full qf
     WHERE qf.question_id IN (
       SELECT q.id FROM questions q
       JOIN categories c2 ON c2.id = q.category_id
       WHERE c2.path <@ (SELECT path FROM categories WHERE id = $1)
     )
     AND qf.question_id NOT IN (
       SELECT ua.question_id FROM user_answers ua
       WHERE ua.user_id = $2 AND ua.answered_at > $3
     )
     ORDER BY random()
     LIMIT 1`,
    [session.category_id, session.user_id, session.created_at]
  );

  if (!next.rowCount || next.rowCount === 0) {
    // edge case: total_questions might have been stale
    await pool.query(
      'UPDATE quiz_sessions SET completed_at = now() WHERE id = $1',
      [sessionId]
    );
    return {
      completed: true,
      totalQuestions: session.total_questions,
      answeredCount: answeredSoFar,
    };
  }

  const q = next.rows[0]!;

  return {
    completed: false,
    questionId: q.question_id,
    questionText: q.question_text,
    questionType: q.question_type,
    categoryId: q.category_id,
    categoryName: q.category_name,
    options: q.options,
    session: {
      totalQuestions: session.total_questions,
      answeredCount: answeredSoFar,
      remainingCount: remaining - 1,
    },
  };
}

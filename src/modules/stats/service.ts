import { pool } from '../../db/pool';
import { AppError } from '../auth/service';

export interface UserStats {
  totalQuestionsAnswered: number;
  totalCorrectStreak: number;
  currentLoginStreak: number;
  longestLoginStreak: number;
  lastActivityDate: string | null;
}

export interface CategoryStat {
  categoryId: string;
  categoryName: string;
  categoryPath: string;
  questionsAnswered: number;
  correctAnswers: number;
  accuracy: number;
  completedSessions: number;
  lastAnsweredAt: string | null;
}

export async function getStats(userId: string): Promise<UserStats> {
  const result = await pool.query<{
    total_questions_answered: number;
    total_correct_streak: number;
    current_login_streak: number;
    longest_login_streak: number;
    last_activity_date: string | null;
  }>(
    `SELECT * FROM user_stats WHERE user_id = $1`,
    [userId]
  );

  const row = result.rows[0] ?? {
    total_questions_answered: 0,
    total_correct_streak: 0,
    current_login_streak: 0,
    longest_login_streak: 0,
    last_activity_date: null,
  };

  return {
    totalQuestionsAnswered: row.total_questions_answered,
    totalCorrectStreak: row.total_correct_streak,
    currentLoginStreak: row.current_login_streak,
    longestLoginStreak: row.longest_login_streak,
    lastActivityDate: row.last_activity_date,
  };
}

export async function getCategoryStats(userId: string): Promise<CategoryStat[]> {
  const result = await pool.query<{
    category_id: string;
    category_name: string;
    category_path: string;
    questions_answered: number;
    correct_answers: number;
    completed_sessions: number;
    last_answered_at: string | null;
  }>(
    `SELECT ucs.category_id, c.name AS category_name, c.path::text AS category_path,
            ucs.questions_answered, ucs.correct_answers, ucs.last_answered_at,
            COALESCE(qs.completed, 0) AS completed_sessions
     FROM user_category_stats ucs
     JOIN categories c ON c.id = ucs.category_id
     LEFT JOIN LATERAL (
       SELECT COUNT(*)::int AS completed
       FROM quiz_sessions
       WHERE user_id = $1
         AND category_id = ucs.category_id
         AND completed_at IS NOT NULL
     ) qs ON true
     WHERE ucs.user_id = $1
     ORDER BY ucs.questions_answered DESC`,
    [userId]
  );

  return result.rows.map(r => ({
    categoryId: r.category_id,
    categoryName: r.category_name,
    categoryPath: r.category_path,
    questionsAnswered: r.questions_answered,
    correctAnswers: r.correct_answers,
    accuracy: r.questions_answered > 0
      ? Math.round((r.correct_answers / r.questions_answered) * 1000) / 10
      : 0,
    completedSessions: r.completed_sessions,
    lastAnsweredAt: r.last_answered_at,
  }));
}

export async function upsertStats(userId: string, categoryId: string, isCorrect: boolean): Promise<void> {
  // user_stats: upsert + update streaks
  await pool.query(`
    INSERT INTO user_stats (user_id, total_questions_answered, total_correct_streak, last_activity_date)
    VALUES ($1, 1, CASE WHEN $2 THEN 1 ELSE 0 END, CURRENT_DATE)
    ON CONFLICT (user_id) DO UPDATE SET
      total_questions_answered = user_stats.total_questions_answered + 1,
      total_correct_streak = CASE WHEN $2
        THEN user_stats.total_correct_streak + 1
        ELSE 0 END,
      last_activity_date = CURRENT_DATE,
      updated_at = now()
  `, [userId, isCorrect]);

  // user_category_stats: upsert
  await pool.query(`
    INSERT INTO user_category_stats (user_id, category_id, questions_answered, correct_answers, last_answered_at)
    VALUES ($1, $2, 1, CASE WHEN $3 THEN 1 ELSE 0 END, now())
    ON CONFLICT (user_id, category_id) DO UPDATE SET
      questions_answered = user_category_stats.questions_answered + 1,
      correct_answers = user_category_stats.correct_answers + CASE WHEN $3 THEN 1 ELSE 0 END,
      last_answered_at = now()
  `, [userId, categoryId, isCorrect]);
}

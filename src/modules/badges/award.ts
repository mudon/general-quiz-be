import { pool } from '../../db/pool';

interface BadgeRule {
  slug: string;
  check: (stats: UserStatsSnapshot) => boolean;
}

interface UserStatsSnapshot {
  totalQuestionsAnswered: number;
  totalCorrectStreak: number;
  categoryId: string;
  categoryAnswered: number;
  categoryCorrect: number;
}

const streakDaysMap: Record<string, number> = {
  '7-streak': 7,
  '30-streak': 30,
  '100-streak': 100,
};

const answerCountMap: Record<string, number> = {
  'first-answer': 1,
  '10-answers': 10,
  '50-answers': 50,
  '100-answers': 100,
  '500-answers': 500,
  '1000-answers': 1000,
};

export async function checkAndAwardBadges(userId: string): Promise<string[]> {
  // fetch current stats
  const statsResult = await pool.query<{
    total_questions_answered: number;
    total_correct_streak: number;
  }>(
    'SELECT total_questions_answered, total_correct_streak FROM user_stats WHERE user_id = $1',
    [userId]
  );

  if (!statsResult.rowCount || statsResult.rowCount === 0) return [];

  const stats = statsResult.rows[0]!;

  // fetch all badged slugs the user currently has
  const earnedResult = await pool.query<{ slug: string }>(
    `SELECT b.slug FROM user_badges ub JOIN badges b ON b.id = ub.badge_id WHERE ub.user_id = $1`,
    [userId]
  );
  const earned = new Set(earnedResult.rows.map(r => r.slug));

  // fetch all badge rules
  const badgeResult = await pool.query<{ id: string; slug: string }>(
    'SELECT id, slug FROM badges'
  );
  const badgeMap = new Map(badgeResult.rows.map(r => [r.slug, r.id]));

  const newlyAwarded: string[] = [];

  // check answer-count badges
  for (const [slug, threshold] of Object.entries(answerCountMap)) {
    if (!earned.has(slug) && stats.total_questions_answered >= threshold) {
      const badgeId = badgeMap.get(slug);
      if (badgeId) {
        await pool.query(
          'INSERT INTO user_badges (user_id, badge_id) VALUES ($1, $2) ON CONFLICT DO NOTHING',
          [userId, badgeId]
        );
        newlyAwarded.push(slug);
      }
    }
  }

  // check streak badges
  for (const [slug, threshold] of Object.entries(streakDaysMap)) {
    if (!earned.has(slug) && stats.total_correct_streak >= threshold) {
      const badgeId = badgeMap.get(slug);
      if (badgeId) {
        await pool.query(
          'INSERT INTO user_badges (user_id, badge_id) VALUES ($1, $2) ON CONFLICT DO NOTHING',
          [userId, badgeId]
        );
        newlyAwarded.push(slug);
      }
    }
  }

  return newlyAwarded;
}

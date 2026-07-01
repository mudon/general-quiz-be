import { pool } from '../../db/pool';
import { AppError } from '../auth/service';

export interface Badge {
  id: number;
  slug: string;
  name: string;
  description: string | null;
  iconUrl: string | null;
  color: string | null;
  createdAt: string;
  earned?: boolean;
  earnedAt?: string | null;
}

export interface EarnedBadge extends Badge {
  earned: true;
  earnedAt: string;
}

// ---- admin CRUD ----

export async function getAllBadges(): Promise<Badge[]> {
  const result = await pool.query<Badge>(
    `SELECT id, slug, name, description, icon_url, color, created_at
     FROM badges ORDER BY id`
  );
  return result.rows;
}

export async function createBadge(input: {
  slug: string;
  name: string;
  description?: string | null;
  iconUrl?: string | null;
  color?: string | null;
}): Promise<Badge> {
  const result = await pool.query<Badge>(
    `INSERT INTO badges (slug, name, description, icon_url, color)
     VALUES ($1, $2, $3, $4, $5) RETURNING *`,
    [input.slug, input.name, input.description ?? null, input.iconUrl ?? null, input.color ?? null]
  );
  return result.rows[0]!;
}

export async function updateBadge(id: number, input: {
  slug?: string;
  name?: string;
  description?: string | null;
  iconUrl?: string | null;
  color?: string | null;
}): Promise<Badge> {
  const sets: string[] = [];
  const params: unknown[] = [];
  let i = 1;

  if (input.slug !== undefined) { sets.push(`slug = $${i++}`); params.push(input.slug); }
  if (input.name !== undefined) { sets.push(`name = $${i++}`); params.push(input.name); }
  if (input.description !== undefined) { sets.push(`description = $${i++}`); params.push(input.description); }
  if (input.iconUrl !== undefined) { sets.push(`icon_url = $${i++}`); params.push(input.iconUrl); }
  if (input.color !== undefined) { sets.push(`color = $${i++}`); params.push(input.color); }

  if (sets.length === 0) return await getBadgeById(id);

  params.push(id);
  const result = await pool.query<Badge>(
    `UPDATE badges SET ${sets.join(', ')} WHERE id = $${i} RETURNING *`,
    params
  );

  if (!result.rowCount || result.rowCount === 0) throw new AppError(404, 'Badge not found');
  return result.rows[0]!;
}

export async function deleteBadge(id: number): Promise<void> {
  const result = await pool.query('DELETE FROM badges WHERE id = $1', [id]);
  if (!result.rowCount || result.rowCount === 0) throw new AppError(404, 'Badge not found');
}

async function getBadgeById(id: number): Promise<Badge> {
  const result = await pool.query<Badge>('SELECT * FROM badges WHERE id = $1', [id]);
  if (!result.rowCount || result.rowCount === 0) throw new AppError(404, 'Badge not found');
  return result.rows[0]!;
}

// ---- awarding ----

export async function awardBadge(userId: string, badgeId: number): Promise<{ awardedAt: string }> {
  const badge = await pool.query('SELECT id FROM badges WHERE id = $1', [badgeId]);
  if (!badge.rowCount || badge.rowCount === 0) throw new AppError(404, 'Badge not found');

  const user = await pool.query('SELECT id FROM users WHERE id = $1', [userId]);
  if (!user.rowCount || user.rowCount === 0) throw new AppError(404, 'User not found');

  const result = await pool.query<{ awarded_at: string }>(
    `INSERT INTO user_badges (user_id, badge_id)
     VALUES ($1, $2)
     ON CONFLICT (user_id, badge_id) DO NOTHING
     RETURNING awarded_at`,
    [userId, badgeId]
  );

  if (!result.rowCount || result.rowCount === 0) {
    throw new AppError(409, 'User already has this badge');
  }

  return { awardedAt: result.rows[0]!.awarded_at };
}

export async function revokeBadge(userId: string, badgeId: number): Promise<void> {
  const result = await pool.query(
    'DELETE FROM user_badges WHERE user_id = $1 AND badge_id = $2',
    [userId, badgeId]
  );
  if (!result.rowCount || result.rowCount === 0) throw new AppError(404, 'User does not have this badge');
}

// ---- user-facing ----

export async function getAllWithEarnedStatus(userId: string): Promise<(Badge & { earned: boolean; earnedAt: string | null })[]> {
  const result = await pool.query<Badge & { awarded_at: string | null }>(
    `SELECT b.*, ub.awarded_at
     FROM badges b
     LEFT JOIN user_badges ub ON ub.badge_id = b.id AND ub.user_id = $1
     ORDER BY b.id`,
    [userId]
  );

  return result.rows.map(r => ({
    ...r,
    earned: r.awarded_at !== null,
    earnedAt: r.awarded_at,
  }));
}

export async function getEarnedBadges(userId: string): Promise<EarnedBadge[]> {
  const result = await pool.query<Badge & { awarded_at: string }>(
    `SELECT b.*, ub.awarded_at
     FROM badges b
     JOIN user_badges ub ON ub.badge_id = b.id
     WHERE ub.user_id = $1
     ORDER BY ub.awarded_at DESC`,
    [userId]
  );

  return result.rows.map(r => ({
    ...r,
    earned: true as const,
    earnedAt: r.awarded_at,
  }));
}

export async function selectBadge(userId: string, slug: string): Promise<{ selectedBadgeSlug: string }> {
  const result = await pool.query<{ selected_badge_slug: string }>(
    `UPDATE users SET selected_badge_slug = $2 WHERE id = $1
     RETURNING selected_badge_slug`,
    [userId, slug]
  );

  if (!result.rowCount || result.rowCount === 0) throw new AppError(404, 'User not found');
  return { selectedBadgeSlug: result.rows[0]!.selected_badge_slug! };
}

import { pool } from '../../db/pool';
import { AppError } from '../auth/service';

export interface UserListItem {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  role: string;
  authProvider: string;
  emailVerified: boolean;
  createdAt: string;
}

export async function listUsers(cursor?: string, limit = 20) {
  const take = Math.min(limit, 100) + 1;
  const params: unknown[] = [];
  let paramIdx = 1;

  let where = '';
  if (cursor) {
    where = `WHERE id > $${paramIdx++}`;
    params.push(cursor);
  }

  const result = await pool.query<{
    id: string; first_name: string; last_name: string; email: string;
    role: string; auth_provider: string; email_verified: boolean; created_at: string;
  }>(
    `SELECT id, first_name, last_name, email, role, auth_provider, email_verified, created_at
     FROM users ${where} ORDER BY created_at DESC LIMIT $${paramIdx}`,
    [...params, take]
  );

  const rows = result.rows;
  const hasMore = rows.length > limit;
  const items = hasMore ? rows.slice(0, limit) : rows;

  return {
    items: items.map(r => ({
      id: r.id,
      firstName: r.first_name,
      lastName: r.last_name,
      email: r.email,
      role: r.role,
      authProvider: r.auth_provider,
      emailVerified: r.email_verified,
      createdAt: r.created_at,
    })),
    nextCursor: items.length > 0 ? items[items.length - 1]!.id : null,
    hasMore,
  };
}

export async function getUserById(userId: string) {
  const result = await pool.query<{
    id: string; first_name: string; last_name: string; email: string;
    role: string; auth_provider: string; email_verified: boolean;
    avatar_type: string | null; avatar_value: string | null;
    selected_badge_slug: string | null; created_at: string; updated_at: string;
  }>(
    `SELECT id, first_name, last_name, email, role, auth_provider, email_verified,
            avatar_type, avatar_value, selected_badge_slug, created_at, updated_at
     FROM users WHERE id = $1`,
    [userId]
  );

  if (!result.rowCount || result.rowCount === 0) throw new AppError(404, 'User not found');

  const r = result.rows[0]!;

  const badgesResult = await pool.query<{
    slug: string; name: string; description: string | null;
    icon_url: string | null; color: string | null; awarded_at: string;
  }>(
    `SELECT b.slug, b.name, b.description, b.icon_url, b.color, ub.awarded_at
     FROM user_badges ub JOIN badges b ON b.id = ub.badge_id
     WHERE ub.user_id = $1 ORDER BY ub.awarded_at DESC`,
    [userId]
  );

  return {
    id: r.id,
    firstName: r.first_name,
    lastName: r.last_name,
    email: r.email,
    role: r.role,
    authProvider: r.auth_provider,
    emailVerified: r.email_verified,
    avatarType: r.avatar_type,
    avatarValue: r.avatar_value,
    selectedBadgeSlug: r.selected_badge_slug,
    createdAt: r.created_at,
    updatedAt: r.updated_at,
    badges: badgesResult.rows.map(b => ({
      slug: b.slug,
      name: b.name,
      description: b.description,
      iconUrl: b.icon_url,
      color: b.color,
      awardedAt: b.awarded_at,
    })),
  };
}

export async function changeUserRole(userId: string, role: 'user' | 'admin') {
  const result = await pool.query(
    `UPDATE users SET role = $2::role WHERE id = $1 RETURNING id, role`,
    [userId, role]
  );
  if (!result.rowCount || result.rowCount === 0) throw new AppError(404, 'User not found');
  return { message: `User role changed to ${role}` };
}

export async function deleteUser(userId: string) {
  const result = await pool.query('DELETE FROM users WHERE id = $1', [userId]);
  if (!result.rowCount || result.rowCount === 0) throw new AppError(404, 'User not found');
  return { message: 'User deleted' };
}

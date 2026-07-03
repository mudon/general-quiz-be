import { pool } from '../../db/pool';
import { config } from '../../lib/config';
import { sendEmail } from '../../lib/mail';
import {
  createAccessToken,
  createResetToken,
  createEmailChangeToken,
  verifyToken,
  generateRefreshTokenValue,
  hashToken,
  type TokenPayload,
  type ResetPayload,
  type EmailChangePayload,
} from '../../lib/jwt';

export async function register(firstName: string, lastName: string, email: string, password: string) {
  email = email.toLowerCase().trim();

  const existing = await pool.query('SELECT id FROM users WHERE email = $1', [email]);
  if (existing.rowCount && existing.rowCount > 0) {
    throw new AppError(409, 'A user with this email already exists');
  }

  const passwordHash = await Bun.password.hash(password, { algorithm: 'bcrypt', cost: 10 });

  const result = await pool.query(
    `INSERT INTO users (first_name, last_name, email, password_hash, auth_provider, email_verified)
     VALUES ($1, $2, $3, $4, 'email', FALSE)
     RETURNING id, first_name, last_name, email, role, tier, created_at`,
    [firstName, lastName, email, passwordHash]
  );

  const user = result.rows[0]!;

  // init login streak on registration
  await pool.query(`
    INSERT INTO user_stats (user_id, current_login_streak, longest_login_streak, last_activity_date)
    VALUES ($1, 1, 1, CURRENT_DATE)
    ON CONFLICT (user_id) DO NOTHING
  `, [user.id]);

  const tokens = await generateTokenPair({
    sub: user.id,
    email: user.email,
    role: user.role,
  });

  return {
    user: {
      id: user.id,
      firstName: user.first_name,
      lastName: user.last_name,
      email: user.email,
      role: user.role,
      tier: user.tier,
      createdAt: user.created_at,
    },
    ...tokens,
  };
}

export async function login(email: string, password: string) {
  email = email.toLowerCase().trim();

  const result = await pool.query<{
    id: string;
    first_name: string;
    last_name: string;
    email: string;
    role: string;
    tier: number;
    password_hash: string | null;
    email_verified: boolean;
  }>(
    `SELECT id, first_name, last_name, email, role, tier, password_hash, email_verified
     FROM users
     WHERE email = $1 AND auth_provider = 'email'`,
    [email]
  );

  if (!result.rowCount || result.rowCount === 0) {
    throw new AppError(401, 'Invalid email or password');
  }

  const user = result.rows[0]!;

  if (!user.password_hash) {
    throw new AppError(401, 'This account uses Google sign-in');
  }

  const valid = await Bun.password.verify(password, user.password_hash);
  if (!valid) {
    throw new AppError(401, 'Invalid email or password');
  }

  if (!user.email_verified) {
    throw new AppError(403, 'Email not verified. Please check your inbox or request a new code.');
  }

  // update login streak
  await updateLoginStreak(user.id);

  const tokens = await generateTokenPair({
    sub: user.id,
    email: user.email,
    role: user.role,
  });

  return {
    user: {
      id: user.id,
      firstName: user.first_name,
      lastName: user.last_name,
      email: user.email,
      role: user.role,
      tier: user.tier,
    },
    ...tokens,
  };
}

export async function refreshAccessToken(tokens: { accessToken: string; refreshToken: string }) {
  const tokenHash = hashToken(tokens.refreshToken);

  const result = await pool.query(
    `DELETE FROM refresh_tokens
     WHERE token_hash = $1 AND expires_at > now()
     RETURNING user_id`,
    [tokenHash]
  );

  if (!result.rowCount || result.rowCount === 0) {
    throw new AppError(401, 'Invalid or expired refresh token');
  }

  const userId = result.rows[0]!.user_id;

  // fetch user for payload
  const userResult = await pool.query(
    `SELECT id, email, role FROM users WHERE id = $1`,
    [userId]
  );

  if (!userResult.rowCount || userResult.rowCount === 0) {
    throw new AppError(404, 'User not found');
  }

  const user = userResult.rows[0]!;

  return generateTokenPair({
    sub: user.id,
    email: user.email,
    role: user.role,
  });
}

export async function forgotPassword(email: string) {
  email = email.toLowerCase().trim();

  const result = await pool.query(
    `SELECT id FROM users WHERE email = $1 AND auth_provider = 'email'`,
    [email]
  );

  if (!result.rowCount || result.rowCount === 0) {
    return { message: 'If that email exists, a reset link has been sent' };
  }

  const user = result.rows[0]!;
  const resetToken = await createResetToken(user.id);

  await sendEmail(email, 'Reset your QuizMaster password',
    `Use this token to reset your password:\n\n${resetToken}\n\nThis token expires in 15 minutes.`);

  return {
    message: 'If that email exists, a reset link has been sent',
    debugToken: process.env.NODE_ENV !== 'production' ? resetToken : undefined,
  };
}

export async function resetPassword(token: string, newPassword: string) {
  let payload: ResetPayload & { sub: string; exp?: number };
  try {
    payload = await verifyToken<ResetPayload>(token);
  } catch {
    throw new AppError(400, 'Invalid or expired reset token');
  }

  if (payload.purpose !== 'reset') {
    throw new AppError(400, 'Invalid reset token');
  }

  const passwordHash = await Bun.password.hash(newPassword, { algorithm: 'bcrypt', cost: 10 });

  await pool.query(
    'UPDATE users SET password_hash = $2, email_verified = TRUE WHERE id = $1',
    [payload.sub, passwordHash]
  );

  // invalidate all existing refresh tokens for this user
  await pool.query('DELETE FROM refresh_tokens WHERE user_id = $1', [payload.sub]);

  return { message: 'Password has been reset successfully. All sessions signed out.' };
}

export async function logout(refreshToken: string) {
  const tokenHash = hashToken(refreshToken);
  await pool.query('DELETE FROM refresh_tokens WHERE token_hash = $1', [tokenHash]);
  return { message: 'Logged out successfully' };
}

export async function getMe(userId: string) {
  const result = await pool.query(
    `SELECT id, first_name, last_name, email, role, tier, avatar_type, avatar_value,
            selected_badge_slug, email_verified, created_at
     FROM users WHERE id = $1`,
    [userId]
  );

  if (!result.rowCount || result.rowCount === 0) {
    throw new AppError(404, 'User not found');
  }

  const user = result.rows[0]!;

  // fetch earned badges
  const badgesResult = await pool.query<{
    slug: string; name: string; description: string | null;
    icon_url: string | null; color: string | null; awarded_at: string;
  }>(
    `SELECT b.slug, b.name, b.description, b.icon_url, b.color, ub.awarded_at
     FROM user_badges ub
     JOIN badges b ON b.id = ub.badge_id
     WHERE ub.user_id = $1
     ORDER BY ub.awarded_at DESC`,
    [userId]
  );

  return {
    id: user.id,
    firstName: user.first_name,
    lastName: user.last_name,
    email: user.email,
    role: user.role,
    tier: user.tier,
    avatarType: user.avatar_type,
    avatarValue: user.avatar_value,
    selectedBadgeSlug: user.selected_badge_slug,
    emailVerified: user.email_verified,
    createdAt: user.created_at,
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

export async function changePassword(userId: string, currentPassword: string, newPassword: string) {
  const result = await pool.query(
    `SELECT password_hash FROM users WHERE id = $1 AND auth_provider = 'email'`,
    [userId]
  );

  if (!result.rowCount || result.rowCount === 0) {
    throw new AppError(404, 'User not found');
  }

  const hash = result.rows[0]!.password_hash;
  if (!hash) {
    throw new AppError(400, 'Cannot change password for Google-authenticated accounts');
  }

  const valid = await Bun.password.verify(currentPassword, hash);
  if (!valid) {
    throw new AppError(401, 'Current password is incorrect');
  }

  const newHash = await Bun.password.hash(newPassword, { algorithm: 'bcrypt', cost: 10 });

  await pool.query('UPDATE users SET password_hash = $2 WHERE id = $1', [userId, newHash]);

  // invalidate all refresh tokens (force re-login)
  await pool.query('DELETE FROM refresh_tokens WHERE user_id = $1', [userId]);

  return { message: 'Password changed. All sessions signed out.' };
}

export async function requestEmailChange(userId: string, currentPassword: string, newEmail: string) {
  const result = await pool.query(
    `SELECT password_hash, email FROM users WHERE id = $1 AND auth_provider = 'email'`,
    [userId]
  );

  if (!result.rowCount || result.rowCount === 0) {
    throw new AppError(404, 'User not found');
  }

  const hash = result.rows[0]!.password_hash;
  if (!hash) {
    throw new AppError(400, 'Cannot change email for Google-authenticated accounts');
  }

  const valid = await Bun.password.verify(currentPassword, hash);
  if (!valid) {
    throw new AppError(401, 'Current password is incorrect');
  }

  newEmail = newEmail.toLowerCase().trim();

  // check new email not already taken
  const existing = await pool.query('SELECT id FROM users WHERE email = $1', [newEmail]);
  if (existing.rowCount && existing.rowCount > 0) {
    throw new AppError(409, 'A user with this email already exists');
  }

  const token = await createEmailChangeToken(userId, newEmail);

  await sendEmail(newEmail, 'Verify your new QuizMaster email',
    `Use this token to confirm your email change:\n\n${token}\n\nThis token expires in 15 minutes.`);

  return {
    message: `Verification sent to ${newEmail}. Use the token to confirm.`,
    debugToken: process.env.NODE_ENV !== 'production' ? token : undefined,
  };
}

export async function verifyNewEmail(token: string) {
  let payload: EmailChangePayload & { sub: string; exp?: number };
  try {
    payload = await verifyToken<EmailChangePayload>(token);
  } catch {
    throw new AppError(400, 'Invalid or expired verification token');
  }

  if (payload.purpose !== 'change-email') {
    throw new AppError(400, 'Invalid verification token');
  }

  const email = payload.newEmail.toLowerCase().trim();

  // check email still not taken (race condition guard)
  const existing = await pool.query('SELECT id FROM users WHERE email = $1', [email]);
  if (existing.rowCount && existing.rowCount > 0) {
    throw new AppError(409, 'This email has been taken since the request was made');
  }

  await pool.query('UPDATE users SET email = $2 WHERE id = $1', [payload.sub, email]);

  // invalidate all refresh tokens (force re-login with new email)
  await pool.query('DELETE FROM refresh_tokens WHERE user_id = $1', [payload.sub]);

  return { message: 'Email changed successfully. Please log in with your new email.' };
}

export async function updateProfile(
  userId: string,
  data: { firstName?: string; lastName?: string; avatarType?: string | null; avatarValue?: string | null }
) {
  const sets: string[] = [];
  const params: unknown[] = [];
  let i = 1;

  if (data.firstName !== undefined) { sets.push(`first_name = $${i++}`); params.push(data.firstName); }
  if (data.lastName !== undefined) { sets.push(`last_name = $${i++}`); params.push(data.lastName); }
  if (data.avatarType !== undefined) { sets.push(`avatar_type = $${i++}`); params.push(data.avatarType ?? null); }
  if (data.avatarValue !== undefined) { sets.push(`avatar_value = $${i++}`); params.push(data.avatarValue ?? null); }

  if (sets.length === 0) return await getMe(userId);

  params.push(userId);
  await pool.query(`UPDATE users SET ${sets.join(', ')} WHERE id = $${i}`, params);

  return await getMe(userId);
}

export async function resendVerification(email: string) {
  email = email.toLowerCase().trim();

  const user = await pool.query<{ id: string; email_verified: boolean }>(
    'SELECT id, email_verified FROM users WHERE email = $1 AND auth_provider = \'email\'',
    [email]
  );

  if (!user.rowCount || user.rowCount === 0) {
    return { message: 'If that email is registered and unverified, a new code has been sent.' };
  }

  const u = user.rows[0]!;
  if (u.email_verified) {
    return { message: 'Email is already verified. You can log in.' };
  }

  const token = await createResetToken(u.id);

  await sendEmail(email, 'Verify your QuizMaster email',
    `Use this token to verify your email:\n\n${token}\n\nThis token expires in 15 minutes.`);

  return {
    message: 'If that email is registered and unverified, a new code has been sent.',
    debugToken: process.env.NODE_ENV !== 'production' ? token : undefined,
  };
}

export async function sendVerificationEmail(userId: string) {
  const user = await pool.query<{ email: string; email_verified: boolean }>(
    'SELECT email, email_verified FROM users WHERE id = $1',
    [userId]
  );

  if (!user.rowCount || user.rowCount === 0) throw new AppError(404, 'User not found');
  if (user.rows[0]!.email_verified) return { message: 'Email already verified' };

  const token = await createResetToken(userId);
  const userEmail = user.rows[0]!.email;

  await sendEmail(userEmail, 'Verify your QuizMaster email',
    `Use this token to verify your email:\n\n${token}\n\nThis token expires in 15 minutes.`);

  return {
    message: 'Verification email sent',
    debugToken: process.env.NODE_ENV !== 'production' ? token : undefined,
  };
}

export async function verifyEmail(token: string) {
  let payload: { sub: string; purpose: string };
  try {
    payload = await verifyToken(token);
  } catch {
    throw new AppError(400, 'Invalid or expired verification token');
  }

  if (payload.purpose !== 'reset') {
    throw new AppError(400, 'Invalid verification token');
  }

  await pool.query('UPDATE users SET email_verified = TRUE WHERE id = $1', [payload.sub]);

  return { message: 'Email verified successfully' };
}

async function generateTokenPair(payload: TokenPayload) {
  const accessToken = await createAccessToken(payload);
  const refreshToken = generateRefreshTokenValue();
  const tokenHash = hashToken(refreshToken);

  await pool.query(
    `INSERT INTO refresh_tokens (user_id, token_hash, expires_at)
     VALUES ($1, $2, now() + interval '${config.tokens.refreshExpiresDays} days')`,
    [payload.sub, tokenHash]
  );

  return { accessToken, refreshToken };
}

async function updateLoginStreak(userId: string) {
  // fetch current stats
  const stats = await pool.query<{
    current_login_streak: number;
    longest_login_streak: number;
    last_activity_date: string | null;
  }>(
    'SELECT current_login_streak, longest_login_streak, last_activity_date FROM user_stats WHERE user_id = $1',
    [userId]
  );

  const today = new Date().toISOString().slice(0, 10);

  if (!stats.rowCount || stats.rowCount === 0 || !stats.rows[0]!.last_activity_date) {
    // first login (no stats row yet)
    await pool.query(`
      INSERT INTO user_stats (user_id, current_login_streak, longest_login_streak, last_activity_date)
      VALUES ($1, 1, 1, CURRENT_DATE)
      ON CONFLICT (user_id) DO UPDATE SET
        current_login_streak = 1,
        longest_login_streak = 1,
        last_activity_date = CURRENT_DATE
    `, [userId]);
    return;
  }

  const s = stats.rows[0]!;
  const d = new Date(s.last_activity_date!);
  const lastDate = d.toISOString().slice(0, 10);

  if (lastDate === today) return; // already counted today

  const last = new Date(lastDate);
  const now = new Date(today);
  const diffDays = Math.round((now.getTime() - last.getTime()) / (1000 * 60 * 60 * 24));

  let newStreak: number;
  if (diffDays === 1) {
    newStreak = s.current_login_streak + 1;
  } else {
    newStreak = 1;
  }

  const newLongest = Math.max(newStreak, s.longest_login_streak);

  await pool.query(
    `UPDATE user_stats SET
       current_login_streak = $2,
       longest_login_streak = $3,
       last_activity_date = CURRENT_DATE,
       updated_at = now()
     WHERE user_id = $1`,
    [userId, newStreak, newLongest]
  );
}

export class AppError extends Error {
  constructor(
    public statusCode: number,
    message: string
  ) {
    super(message);
    this.name = 'AppError';
  }
}

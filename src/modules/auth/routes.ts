import { Elysia, t } from 'elysia';
import { jwt } from '@elysiajs/jwt';
import { config } from '../../lib/config';
import * as authService from './service';
import { verifyToken } from '../../lib/jwt';
import { rateLimiters, type LimiterFn } from '../../lib/rateLimit';

const requireAuth = (user: unknown) => {
  if (!user || typeof user !== 'object' || !('sub' in (user as Record<string, unknown>))) {
    throw new authService.AppError(401, 'Authentication required');
  }
};

function getIp(request: Request): string {
  const forwarded = request.headers.get('x-forwarded-for');
  return forwarded?.split(',')[0]?.trim() || '127.0.0.1';
}

function checkRate(limiter: LimiterFn, request: Request) {
  const ip = getIp(request);
  const result = limiter(ip);
  if (!result.ok) {
    throw Object.assign(new authService.AppError(429, 'Too many requests. Try again later.'), {
      retryAfter: result.retryAfter,
    });
  }
}

function extractToken(request: Request): string | null {
  const authHeader = request.headers.get('authorization');
  if (authHeader?.startsWith('Bearer ')) {
    return authHeader.slice(7);
  }
  return null;
}

export const authRoutes = new Elysia({ prefix: '/api/auth' })
  .use(
    jwt({
      name: 'jwt',
      secret: config.jwt.secret,
    })
  )
  .derive(async ({ request }) => {
    const token = extractToken(request);
    if (!token) return { user: null };

    try {
      const payload = await verifyToken(token);
      return { user: payload };
    } catch {
      return { user: null };
    }
  })

  // POST /api/auth/register
  .post(
    '/register',
    async ({ body }) => {
      return await authService.register(
        body.firstName,
        body.lastName,
        body.email,
        body.password
      );
    },
    {
      beforeHandle({ request }) { checkRate(rateLimiters.register, request); },
      body: t.Object({
        firstName: t.String({ minLength: 1, maxLength: 255 }),
        lastName: t.String({ minLength: 1, maxLength: 255 }),
        email: t.String({ format: 'email' }),
        password: t.String({ minLength: 8, maxLength: 128 }),
      }),
      detail: { tags: ['Auth'], summary: 'Register a new account' },
    }
  )

  // POST /api/auth/login
  .post(
    '/login',
    async ({ body }) => {
      return await authService.login(body.email, body.password);
    },
    {
      beforeHandle({ request }) { checkRate(rateLimiters.login, request); },
      body: t.Object({
        email: t.String({ format: 'email' }),
        password: t.String({ minLength: 1 }),
      }),
      detail: { tags: ['Auth'], summary: 'Login with email and password' },
    }
  )

  // POST /api/auth/resend-verification  (public — unverified users can't login)
  .post('/resend-verification', async ({ body }) => {
    return await authService.resendVerification(body.email);
  }, {
    body: t.Object({
      email: t.String({ format: 'email' }),
    }),
    detail: { tags: ['Auth'], summary: 'Resend verification email (no auth required)' },
  })

  // POST /api/auth/refresh
  .post(
    '/refresh',
    async ({ body }) => {
      return await authService.refreshAccessToken({
        accessToken: body.accessToken,
        refreshToken: body.refreshToken,
      });
    },
    {
      beforeHandle({ request }) { checkRate(rateLimiters.refresh, request); },
      body: t.Object({
        accessToken: t.String(),
        refreshToken: t.String(),
      }),
      detail: { tags: ['Auth'], summary: 'Refresh access token' },
    }
  )

  // POST /api/auth/forgot-password
  .post(
    '/forgot-password',
    async ({ body }) => {
      return await authService.forgotPassword(body.email);
    },
    {
      beforeHandle({ request }) { checkRate(rateLimiters.forgotPassword, request); },
      body: t.Object({
        email: t.String({ format: 'email' }),
      }),
      detail: { tags: ['Auth'], summary: 'Request password reset' },
    }
  )

  // POST /api/auth/reset-password
  .post(
    '/reset-password',
    async ({ body }) => {
      return await authService.resetPassword(body.token, body.password);
    },
    {
      beforeHandle({ request }) { checkRate(rateLimiters.verifyEmail, request); },
      body: t.Object({
        token: t.String(),
        password: t.String({ minLength: 8, maxLength: 128 }),
      }),
      detail: { tags: ['Auth'], summary: 'Reset password with token' },
    }
  )

  // POST /api/auth/logout
  .post(
    '/logout',
    async ({ body, user }) => {
      requireAuth(user);
      return await authService.logout(body.refreshToken);
    },
    {
      body: t.Object({
        refreshToken: t.String(),
      }),
      detail: { tags: ['Auth'], summary: 'Logout and invalidate refresh token' },
    }
  )

  // GET /api/auth/me
  .get('/me', async ({ user }) => {
    requireAuth(user);
    return await authService.getMe((user as { sub: string }).sub);
  }, {
    detail: { tags: ['Auth'], summary: 'Get current user profile' },
  })

  // PUT /api/auth/password
  .put('/password', async ({ body, user }) => {
    requireAuth(user);
    return await authService.changePassword(
      (user as { sub: string }).sub,
      body.currentPassword,
      body.newPassword
    );
  }, {
    body: t.Object({
      currentPassword: t.String({ minLength: 1 }),
      newPassword: t.String({ minLength: 8, maxLength: 128 }),
    }),
    detail: { tags: ['Auth'], summary: 'Change password (requires current password)' },
  })

  // POST /api/auth/change-email
  .post('/change-email', async ({ body, user }) => {
    requireAuth(user);
    return await authService.requestEmailChange(
      (user as { sub: string }).sub,
      body.currentPassword,
      body.newEmail,
    );
  }, {
    body: t.Object({
      currentPassword: t.String({ minLength: 1 }),
      newEmail: t.String({ minLength: 1 }),
    }),
    detail: { tags: ['Auth'], summary: 'Request email change (sends verification to new email)' },
  })

  // POST /api/auth/verify-new-email
  .post('/verify-new-email', async ({ body }) => {
    return await authService.verifyNewEmail(body.token);
  }, {
    body: t.Object({
      token: t.String(),
    }),
    detail: { tags: ['Auth'], summary: 'Verify new email and complete the change' },
  })

  // PUT /api/auth/profile
  .put('/profile', async ({ body, user }) => {
    requireAuth(user);
    return await authService.updateProfile((user as { sub: string }).sub, {
      firstName: body.firstName,
      lastName: body.lastName,
      avatarType: body.avatarType,
      avatarValue: body.avatarValue,
    });
  }, {
    body: t.Object({
      firstName: t.Optional(t.String({ minLength: 1, maxLength: 255 })),
      lastName: t.Optional(t.String({ minLength: 1, maxLength: 255 })),
      avatarType: t.Optional(t.Nullable(t.Union([t.Literal('icon'), t.Literal('upload')]))),
      avatarValue: t.Optional(t.Nullable(t.String({ maxLength: 255 }))),
    }),
    detail: { tags: ['Auth'], summary: 'Update profile (name, avatar)' },
  })

  // POST /api/auth/send-verification
  .post('/send-verification', async ({ user, request }) => {
    checkRate(rateLimiters.resendVerify, request);
    requireAuth(user);
    return await authService.sendVerificationEmail((user as { sub: string }).sub);
  }, {
    detail: { tags: ['Auth'], summary: 'Send email verification token' },
  })

  // POST /api/auth/verify-email
  .post('/verify-email', async ({ body, request }) => {
    checkRate(rateLimiters.verifyEmail, request);
    return await authService.verifyEmail(body.token);
  }, {
    body: t.Object({
      token: t.String(),
    }),
    detail: { tags: ['Auth'], summary: 'Verify email with token' },
  });

export type AuthRoutes = typeof authRoutes;

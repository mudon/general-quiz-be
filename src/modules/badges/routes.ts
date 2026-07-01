import { Elysia, t } from 'elysia';
import * as badgesService from './service';
import { AppError } from '../auth/service';
import { verifyToken } from '../../lib/jwt';

function requireAuth(user: unknown) {
  if (!user || typeof user !== 'object' || !('sub' in (user as Record<string, unknown>))) {
    throw new AppError(401, 'Authentication required');
  }
}

function requireAdmin(user: unknown) {
  requireAuth(user);
  if ((user as { role: string }).role !== 'admin') {
    throw new AppError(403, 'Admin access required');
  }
}

export const badgeRoutes = new Elysia()
  .derive(async ({ request }) => {
    const authHeader = request.headers.get('authorization');
    if (!authHeader?.startsWith('Bearer ')) return { user: null };
    try {
      return { user: await verifyToken(authHeader.slice(7)) };
    } catch {
      return { user: null };
    }
  })

  // ── user routes ──

  .get('/api/badges', async ({ user }) => {
    const userId = (user as { sub: string } | null)?.sub ?? null;
    return await badgesService.getAllWithEarnedStatus(userId!);
  }, {
    detail: { tags: ['Badges'], summary: 'List all badges with earned status' },
  })

  .get('/api/badges/earned', async ({ user }) => {
    requireAuth(user);
    return await badgesService.getEarnedBadges((user as { sub: string }).sub);
  }, {
    detail: { tags: ['Badges'], summary: 'List badges earned by current user' },
  })

  .put('/api/users/me/badge', async ({ body, user }) => {
    requireAuth(user);
    return await badgesService.selectBadge((user as { sub: string }).sub, body.slug);
  }, {
    body: t.Object({ slug: t.String() }),
    detail: { tags: ['Badges'], summary: 'Select display badge (must be earned)' },
  })

  // ── admin routes ──

  .get('/api/admin/badges', async ({ user }) => {
    requireAdmin(user);
    return await badgesService.getAllBadges();
  }, {
    detail: { tags: ['Admin / Badges'], summary: 'List all badges' },
  })

  .post('/api/admin/badges', async ({ body, user }) => {
    requireAdmin(user);
    return await badgesService.createBadge({
      slug: body.slug,
      name: body.name,
      description: body.description ?? null,
      iconUrl: body.iconUrl ?? null,
      color: body.color ?? null,
    });
  }, {
    body: t.Object({
      slug: t.String({ minLength: 1, maxLength: 100 }),
      name: t.String({ minLength: 1, maxLength: 255 }),
      description: t.Optional(t.Nullable(t.String())),
      iconUrl: t.Optional(t.Nullable(t.String())),
      color: t.Optional(t.Nullable(t.String())),
    }),
    detail: { tags: ['Admin / Badges'], summary: 'Create a badge' },
  })

  .put('/api/admin/badges/:id', async ({ params, body, user }) => {
    requireAdmin(user);
    return await badgesService.updateBadge(parseInt(params.id), {
      slug: body.slug ?? undefined,
      name: body.name ?? undefined,
      description: body.description,
      iconUrl: body.iconUrl,
      color: body.color,
    });
  }, {
    params: t.Object({ id: t.String() }),
    body: t.Object({
      slug: t.Optional(t.String({ minLength: 1, maxLength: 100 })),
      name: t.Optional(t.String({ minLength: 1, maxLength: 255 })),
      description: t.Optional(t.Nullable(t.String())),
      iconUrl: t.Optional(t.Nullable(t.String())),
      color: t.Optional(t.Nullable(t.String())),
    }),
    detail: { tags: ['Admin / Badges'], summary: 'Update a badge' },
  })

  .delete('/api/admin/badges/:id', async ({ params, user }) => {
    requireAdmin(user);
    await badgesService.deleteBadge(parseInt(params.id));
    return { message: 'Badge deleted' };
  }, {
    params: t.Object({ id: t.String() }),
    detail: { tags: ['Admin / Badges'], summary: 'Delete a badge' },
  });

export type BadgeRoutes = typeof badgeRoutes;

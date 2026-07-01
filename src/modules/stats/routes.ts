import { Elysia } from 'elysia';
import * as statsService from './service';
import { AppError } from '../auth/service';
import { verifyToken } from '../../lib/jwt';

function requireAuth(user: unknown) {
  if (!user || typeof user !== 'object' || !('sub' in (user as Record<string, unknown>))) {
    throw new AppError(401, 'Authentication required');
  }
}

export const statsRoutes = new Elysia()
  .derive(async ({ request }) => {
    const authHeader = request.headers.get('authorization');
    if (!authHeader?.startsWith('Bearer ')) return { user: null };
    try {
      return { user: await verifyToken(authHeader.slice(7)) };
    } catch {
      return { user: null };
    }
  })

  .get('/api/stats', async ({ user }) => {
    requireAuth(user);
    return await statsService.getStats((user as { sub: string }).sub);
  }, {
    detail: { tags: ['Stats'], summary: 'Get overall user stats' },
  })

  .get('/api/stats/categories', async ({ user }) => {
    requireAuth(user);
    return await statsService.getCategoryStats((user as { sub: string }).sub);
  }, {
    detail: { tags: ['Stats'], summary: 'Get per-category stats' },
  });

export type StatsRoutes = typeof statsRoutes;

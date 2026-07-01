import { Elysia, t } from 'elysia';
import * as adminService from './service';
import { AppError } from '../auth/service';
import { verifyToken } from '../../lib/jwt';

function requireAdmin(user: unknown) {
  if (!user || typeof user !== 'object' || !('sub' in (user as Record<string, unknown>))) {
    throw new AppError(401, 'Authentication required');
  }
  if ((user as { role: string }).role !== 'admin') {
    throw new AppError(403, 'Admin access required');
  }
}

export const adminRoutes = new Elysia()
  .derive(async ({ request }) => {
    const authHeader = request.headers.get('authorization');
    if (!authHeader?.startsWith('Bearer ')) return { user: null };
    try {
      return { user: await verifyToken(authHeader.slice(7)) };
    } catch {
      return { user: null };
    }
  })

  .get('/api/admin/users', async ({ query, user }) => {
    requireAdmin(user);
    return await adminService.listUsers(
      query.cursor,
      query.limit ? parseInt(query.limit) : undefined,
    );
  }, {
    query: t.Object({
      cursor: t.Optional(t.String()),
      limit: t.Optional(t.String()),
    }),
    detail: { tags: ['Admin / Users'], summary: 'List users (cursor pagination)' },
  })

  .get('/api/admin/users/:id', async ({ params, user }) => {
    requireAdmin(user);
    return await adminService.getUserById(params.id);
  }, {
    params: t.Object({ id: t.String() }),
    detail: { tags: ['Admin / Users'], summary: 'Get user by id' },
  })

  .put('/api/admin/users/:id/role', async ({ params, body, user }) => {
    requireAdmin(user);
    return await adminService.changeUserRole(params.id, body.role);
  }, {
    params: t.Object({ id: t.String() }),
    body: t.Object({ role: t.Union([t.Literal('user'), t.Literal('admin')]) }),
    detail: { tags: ['Admin / Users'], summary: 'Change user role' },
  })

  .delete('/api/admin/users/:id', async ({ params, user }) => {
    requireAdmin(user);
    return await adminService.deleteUser(params.id);
  }, {
    params: t.Object({ id: t.String() }),
    detail: { tags: ['Admin / Users'], summary: 'Delete a user' },
  });

export type AdminRoutes = typeof adminRoutes;

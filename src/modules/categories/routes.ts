import { Elysia, t } from 'elysia';
import * as categoriesService from './service';
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

export const categoryRoutes = new Elysia()
  .derive(async ({ request }) => {
    const authHeader = request.headers.get('authorization');
    if (!authHeader?.startsWith('Bearer ')) return { user: null };
    try {
      return { user: await verifyToken(authHeader.slice(7)) };
    } catch {
      return { user: null };
    }
  })

  // GET /api/categories?tree=true
  .get('/api/categories', async ({ query }) => {
    const asTree = query.tree === 'true';
    return asTree ? await categoriesService.getTree() : await categoriesService.getAll();
  }, {
    query: t.Object({
      tree: t.Optional(t.String()),
    }),
    detail: { tags: ['Categories'], summary: 'List all categories (flat or tree)' },
  })

  // GET /api/categories/:id
  .get('/api/categories/:id', async ({ params }) => {
    return await categoriesService.getById(params.id);
  }, {
    params: t.Object({ id: t.String() }),
    detail: { tags: ['Categories'], summary: 'Get category by id' },
  })

  // POST /api/admin/categories
  .post('/api/admin/categories', async ({ body, user }) => {
    requireAdmin(user);
    return await categoriesService.create({
      name: body.name,
      parentId: body.parentId ?? null,
      icon: body.icon ?? null,
      sortOrder: body.sortOrder ?? 0,
    });
  }, {
    body: t.Object({
      name: t.String({ minLength: 1, maxLength: 255 }),
      parentId: t.Optional(t.Nullable(t.String())),
      icon: t.Optional(t.Nullable(t.String())),
      sortOrder: t.Optional(t.Number()),
    }),
    detail: { tags: ['Admin / Categories'], summary: 'Create a category' },
  })

  // PUT /api/admin/categories/:id
  .put('/api/admin/categories/:id', async ({ params, body, user }) => {
    requireAdmin(user);
    return await categoriesService.update(params.id, {
      name: body.name,
      icon: body.icon,
      sortOrder: body.sortOrder,
    });
  }, {
    params: t.Object({ id: t.String() }),
    body: t.Object({
      name: t.Optional(t.String({ minLength: 1, maxLength: 255 })),
      icon: t.Optional(t.Nullable(t.String())),
      sortOrder: t.Optional(t.Number()),
    }),
    detail: { tags: ['Admin / Categories'], summary: 'Update a category' },
  })

  // DELETE /api/admin/categories/:id
  .delete('/api/admin/categories/:id', async ({ params, user }) => {
    requireAdmin(user);
    await categoriesService.remove(params.id);
    return { message: 'Category deleted' };
  }, {
    params: t.Object({ id: t.String() }),
    detail: { tags: ['Admin / Categories'], summary: 'Delete a category and its descendants' },
  });

export type CategoryRoutes = typeof categoryRoutes;

import { Elysia, t } from 'elysia';
import * as quizService from './service';
import { AppError } from '../auth/service';
import { verifyToken } from '../../lib/jwt';

function requireAuth(user: unknown) {
  if (!user || typeof user !== 'object' || !('sub' in (user as Record<string, unknown>))) {
    throw new AppError(401, 'Authentication required');
  }
}

export const quizRoutes = new Elysia()
  .derive(async ({ request }) => {
    const authHeader = request.headers.get('authorization');
    if (!authHeader?.startsWith('Bearer ')) return { user: null };
    try {
      return { user: await verifyToken(authHeader.slice(7)) };
    } catch {
      return { user: null };
    }
  })

  // POST /api/quiz/sessions
  .post('/api/quiz/sessions', async ({ body, user }) => {
    requireAuth(user);
    return await quizService.createSession(
      (user as { sub: string }).sub,
      body.categoryId,
    );
  }, {
    body: t.Object({
      categoryId: t.String(),
    }),
    detail: { tags: ['Quiz'], summary: 'Start a new quiz session for a category' },
  })

  // GET /api/quiz/sessions  (active only)
  .get('/api/quiz/sessions', async ({ user }) => {
    requireAuth(user);
    return await quizService.getActiveSessions((user as { sub: string }).sub);
  }, {
    detail: { tags: ['Quiz'], summary: 'List active (uncompleted) quiz sessions' },
  })

  // GET /api/quiz/sessions/:id/next
  .get('/api/quiz/sessions/:id/next', async ({ params }) => {
    return await quizService.getNextQuestion(params.id);
  }, {
    params: t.Object({ id: t.String() }),
    detail: { tags: ['Quiz'], summary: 'Get next unanswered question in session' },
  })

  // PUT /api/quiz/sessions/:id/reset
  .put('/api/quiz/sessions/:id/reset', async ({ params }) => {
    return await quizService.resetSession(params.id);
  }, {
    params: t.Object({ id: t.String() }),
    detail: { tags: ['Quiz'], summary: 'Reset a quiz session (answered/correct count = 0)' },
  });

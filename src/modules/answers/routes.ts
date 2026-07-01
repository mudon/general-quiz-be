import { Elysia, t } from 'elysia';
import * as answersService from './service';
import { AppError } from '../auth/service';
import { verifyToken } from '../../lib/jwt';

function requireAuth(user: unknown) {
  if (!user || typeof user !== 'object' || !('sub' in (user as Record<string, unknown>))) {
    throw new AppError(401, 'Authentication required');
  }
}

export const answerRoutes = new Elysia()
  .derive(async ({ request }) => {
    const authHeader = request.headers.get('authorization');
    if (!authHeader?.startsWith('Bearer ')) return { user: null };
    try {
      return { user: await verifyToken(authHeader.slice(7)) };
    } catch {
      return { user: null };
    }
  })

  // POST /api/questions/:id/answer
  .post('/api/questions/:id/answer', async ({ params, body, user }) => {
    requireAuth(user);
    return await answersService.submitAnswer((user as { sub: string }).sub, params.id, {
      submittedSingleChoice: body.submittedSingleChoice ?? undefined,
      submittedMultipleChoice: body.submittedMultipleChoice ?? undefined,
      submittedFillIn: body.submittedFillIn ?? undefined,
    });
  }, {
    params: t.Object({ id: t.String() }),
    body: t.Object({
      submittedSingleChoice: t.Optional(t.String()),
      submittedMultipleChoice: t.Optional(t.Array(t.String())),
      submittedFillIn: t.Optional(t.String()),
    }),
    detail: { tags: ['Answers'], summary: 'Submit an answer (auto-graded, triggers SM-2)' },
  })

  // GET /api/review/due
  .get('/api/review/due', async ({ query, user }) => {
    requireAuth(user);
    return await answersService.getDueForReview(
      (user as { sub: string }).sub,
      query.cursor,
      query.limit ? parseInt(query.limit) : undefined,
    );
  }, {
    query: t.Object({
      cursor: t.Optional(t.String()),
      limit: t.Optional(t.String()),
    }),
    detail: { tags: ['Answers'], summary: 'Get questions due for spaced-repetition review' },
  })

  // GET /api/answers/history
  .get('/api/answers/history', async ({ query, user }) => {
    requireAuth(user);
    return await answersService.getHistory(
      (user as { sub: string }).sub,
      query.cursor,
      query.limit ? parseInt(query.limit) : undefined,
    );
  }, {
    query: t.Object({
      cursor: t.Optional(t.String()),
      limit: t.Optional(t.String()),
    }),
    detail: { tags: ['Answers'], summary: 'Get answer history (newest first)' },
  });

export type AnswerRoutes = typeof answerRoutes;

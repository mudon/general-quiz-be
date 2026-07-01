import { Elysia, t } from 'elysia';
import * as questionsService from './service';
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

const questionTypeSchema = t.Union([t.Literal('single_choice'), t.Literal('multiple_choice'), t.Literal('fill_in_blank')]);

export const questionRoutes = new Elysia()
  .derive(async ({ request }) => {
    const authHeader = request.headers.get('authorization');
    if (!authHeader?.startsWith('Bearer ')) return { user: null };
    try {
      return { user: await verifyToken(authHeader.slice(7)) };
    } catch {
      return { user: null };
    }
  })

  // GET /api/questions
  .get('/api/questions', async ({ query }) => {
    return await questionsService.getList({
      categoryId: query.categoryId,
      type: query.type,
      search: query.search,
      cursor: query.cursor,
      limit: query.limit ? parseInt(query.limit) : undefined,
    });
  }, {
    query: t.Object({
      categoryId: t.Optional(t.String()),
      type: t.Optional(t.String()),
      search: t.Optional(t.String()),
      cursor: t.Optional(t.String()),
      limit: t.Optional(t.String()),
    }),
    detail: { tags: ['Questions'], summary: 'List questions (cursor pagination, no answers)' },
  })

  // GET /api/questions/:id
  .get('/api/questions/:id', async ({ params }) => {
    return await questionsService.getById(params.id);
  }, {
    params: t.Object({ id: t.String() }),
    detail: { tags: ['Questions'], summary: 'Get question (no answer)' },
  })

  // GET /api/admin/questions/:id
  .get('/api/admin/questions/:id', async ({ params, user }) => {
    requireAdmin(user);
    return await questionsService.getByIdAdmin(params.id);
  }, {
    params: t.Object({ id: t.String() }),
    detail: { tags: ['Admin / Questions'], summary: 'Get question with correct answer' },
  })

  // POST /api/admin/questions
  .post('/api/admin/questions', async ({ body, user }) => {
    requireAdmin(user);
    return await questionsService.create({
      categoryId: body.categoryId,
      questionText: body.questionText,
      questionType: body.questionType,
      explanation: body.explanation ?? null,
      options: body.options ?? undefined,
      answer: body.answer as questionsService.QuestionAnswerInput,
    });
  }, {
    body: t.Object({
      categoryId: t.String(),
      questionText: t.String({ minLength: 1 }),
      questionType: questionTypeSchema,
      explanation: t.Optional(t.Nullable(t.String())),
      options: t.Optional(t.Array(t.Object({
        text: t.String({ minLength: 1 }),
        sortOrder: t.Optional(t.Number()),
      }))),
      answer: t.Union([
        t.Object({ optionIndex: t.Number() }),
        t.Object({ optionIndices: t.Array(t.Number()) }),
        t.Object({ text: t.String(), alternatives: t.Optional(t.Array(t.String())) }),
      ]),
    }),
    detail: { tags: ['Admin / Questions'], summary: 'Create a question with options and answer' },
  })

  // PUT /api/admin/questions/:id
  .put('/api/admin/questions/:id', async ({ params, body, user }) => {
    requireAdmin(user);
    return await questionsService.update(params.id, {
      categoryId: body.categoryId,
      questionText: body.questionText,
      explanation: body.explanation,
    });
  }, {
    params: t.Object({ id: t.String() }),
    body: t.Object({
      categoryId: t.Optional(t.String()),
      questionText: t.Optional(t.String({ minLength: 1 })),
      explanation: t.Optional(t.Nullable(t.String())),
    }),
    detail: { tags: ['Admin / Questions'], summary: 'Update question text/category/explanation' },
  })

  // DELETE /api/admin/questions/:id
  .delete('/api/admin/questions/:id', async ({ params, user }) => {
    requireAdmin(user);
    await questionsService.remove(params.id);
    return { message: 'Question deleted' };
  }, {
    params: t.Object({ id: t.String() }),
    detail: { tags: ['Admin / Questions'], summary: 'Delete a question' },
  });

export type QuestionRoutes = typeof questionRoutes;

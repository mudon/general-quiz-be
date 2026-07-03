import { Elysia } from 'elysia';
import { cors } from '@elysiajs/cors';
import { config } from './lib/config';
import { authRoutes } from './modules/auth/routes';
import { categoryRoutes } from './modules/categories/routes';
import { questionRoutes } from './modules/questions/routes';
import { answerRoutes } from './modules/answers/routes';
import { statsRoutes } from './modules/stats/routes';
import { badgeRoutes } from './modules/badges/routes';
import { seedBadges } from './modules/badges/seed';
import { adminRoutes } from './modules/admin/routes';
import { quizRoutes } from './modules/quiz/routes';
import { subscriptionRoutes } from './modules/subscriptions/routes';
import { initDatabase } from './db/init';
import { AppError } from './modules/auth/service';

const app = new Elysia()
  .use(cors())
  .onError(({ code, error, set }) => {
    if (error instanceof AppError) {
      set.status = error.statusCode;
      return { error: error.message };
    }
    if (code === 'VALIDATION') {
      set.status = 400;
      return { error: error.message };
    }
    if (code === 'NOT_FOUND') {
      set.status = 404;
      return { error: 'Route not found' };
    }
    console.error('Unhandled error:', error);
    set.status = 500;
    return { error: 'Internal server error' };
  })
  .use(authRoutes)
  .use(categoryRoutes)
  .use(answerRoutes)
  .use(questionRoutes)
  .use(statsRoutes)
  .use(badgeRoutes)
  .use(quizRoutes)
  .use(subscriptionRoutes)
  .use(adminRoutes)
  .get('/health', () => ({ status: 'ok', timestamp: new Date().toISOString() }));

const port = config.server.port;

try {
  await initDatabase();
  console.log('PostgreSQL connected, schema verified');
  await seedBadges();
} catch (err) {
  console.error('Failed to initialize database:', err);
  console.log('Continuing without DB init — ensure schema exists manually');
}

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
  console.log('Routes:');
  console.log(`  POST /api/auth/register`);
  console.log(`  POST /api/auth/login`);
  console.log(`  POST /api/auth/refresh`);
  console.log(`  POST /api/auth/forgot-password`);
  console.log(`  POST /api/auth/reset-password`);
  console.log(`  POST /api/auth/logout`);
  console.log(`  GET  /api/auth/me`);
  console.log(`  GET  /api/categories?tree=true`);
  console.log(`  GET  /api/categories/:id`);
  console.log(`  POST /api/admin/categories`);
  console.log(`  PUT  /api/admin/categories/:id`);
  console.log(`  DELETE /api/admin/categories/:id`);
  console.log(`  GET  /api/questions`);
  console.log(`  GET  /api/questions/:id`);
  console.log(`  GET  /api/admin/questions/:id`);
  console.log(`  POST /api/admin/questions`);
  console.log(`  PUT  /api/admin/questions/:id`);
  console.log(`  DELETE /api/admin/questions/:id`);
  console.log(`  POST /api/questions/:id/answer`);
  console.log(`  GET  /api/review/due`);
  console.log(`  GET  /api/answers/history`);
  console.log(`  GET  /api/stats`);
  console.log(`  GET  /api/stats/categories`);
  console.log(`  GET  /api/badges`);
  console.log(`  GET  /api/badges/earned`);
  console.log(`  PUT  /api/users/me/badge`);
  console.log(`  GET  /api/admin/badges`);
  console.log(`  POST /api/admin/badges`);
  console.log(`  PUT  /api/admin/badges/:id`);
  console.log(`  DELETE /api/admin/badges/:id`);
  console.log(`  PUT  /api/auth/password`);
  console.log(`  PUT  /api/auth/profile`);
  console.log(`  POST /api/auth/change-email`);
  console.log(`  POST /api/auth/verify-new-email`);
  console.log(`  POST /api/auth/send-verification`);
  console.log(`  POST /api/auth/verify-email`);
  console.log(`  GET  /api/admin/users`);
  console.log(`  GET  /api/admin/users/:id`);
  console.log(`  PUT  /api/admin/users/:id/role`);
  console.log(`  DELETE /api/admin/users/:id`);
  console.log(`  GET  /health`);
});

export { app };

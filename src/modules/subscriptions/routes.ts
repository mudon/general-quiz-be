import { Elysia, t } from 'elysia';
import * as subService from './service';
import { AppError } from '../auth/service';
import { verifyToken } from '../../lib/jwt';
import { config } from '../../lib/config';

const successPage = (title: string, emoji: string, msg: string, success: boolean) => `<!DOCTYPE html>
<html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<style>*{margin:0;padding:0;box-sizing:border-box}body{font-family:system-ui,sans-serif;background:#f5f5f5;display:flex;align-items:center;justify-content:center;min-height:100vh}.card{background:white;border-radius:24px;padding:40px;text-align:center;box-shadow:0 4px 24px rgba(0,0,0,0.1);border:3px solid #e5e5e5;max-width:400px;margin:16px}.emoji{font-size:64px;margin-bottom:16px}.title{font-size:24px;font-weight:900;color:#1a1a2e;margin-bottom:8px;letter-spacing:1px}.sub{font-size:14px;color:#666;margin-bottom:24px}.btn{display:inline-block;padding:14px 32px;background:${success?'#22c55e':'#ef4444'};color:white;border:0;border-radius:14px;text-decoration:none;font-weight:800;letter-spacing:1px;font-size:15px;cursor:pointer}.hint{font-size:12px;color:#999;margin-top:16px}</style></head>
<body><div class="card"><div class="emoji">${emoji}</div><div class="title">${title}</div><div class="sub">${msg}</div><button class="btn" onclick="window.close()">CLOSE</button><div class="hint">Press close and go back to the app</div></div>
</body></html>`;

function requireAuth(user: unknown) {
  if (!user || typeof user !== 'object' || !('sub' in (user as Record<string, unknown>))) {
    throw new AppError(401, 'Authentication required');
  }
}

export const subscriptionRoutes = new Elysia()
  .derive(async ({ request }) => {
    const authHeader = request.headers.get('authorization');
    if (!authHeader?.startsWith('Bearer ')) return { user: null };
    try {
      return { user: await verifyToken(authHeader.slice(7)) };
    } catch {
      return { user: null };
    }
  })

  // GET /subscription/success
  .get('/subscription/success', ({ set }) => {
    set.headers['content-type'] = 'text/html';
    return successPage('Payment Successful!', '✅', 'Redirecting you back to the app...', true);
  })

  // GET /subscription/cancel
  .get('/subscription/cancel', ({ set }) => {
    set.headers['content-type'] = 'text/html';
    return successPage('Payment Cancelled', '❌', 'No charges were made.', false);
  })

  // GET /api/subscriptions/plans
  .get('/api/subscriptions/plans', () => {
    return subService.getPlans();
  }, {
    detail: { tags: ['Subscription'], summary: 'List available subscription plans' },
  })

  // POST /api/subscriptions/checkout
  .post('/api/subscriptions/checkout', async ({ body, user }) => {
    requireAuth(user);
    return await subService.checkout(
      (user as { sub: string }).sub,
      body.plan,
      body.currency,
    );
  }, {
    body: t.Object({
      plan: t.String(),
      currency: t.Optional(t.Union([t.Literal('myr'), t.Literal('usd')])),
    }),
    detail: { tags: ['Subscription'], summary: 'Create a Stripe checkout session for a plan' },
  })

  // POST /api/subscriptions/webhook  (public — Stripe calls this)
  .post('/api/subscriptions/webhook', async ({ request }) => {
    const signature = request.headers.get('stripe-signature');
    if (!signature) throw new AppError(400, 'Missing stripe-signature header');
    const body = await request.text();
    return await subService.handleWebhook(body, signature);
  }, {
    detail: { tags: ['Subscription'], summary: 'Stripe webhook endpoint (called by Stripe)' },
  });

import { pool } from '../../db/pool';
import { config } from '../../lib/config';
import { getStripe } from '../../lib/stripe';
import { AppError } from '../auth/service';

const planKeys = Object.keys(config.plans) as (keyof typeof config.plans)[];

const PAYMENT_METHODS: Record<string, import('stripe').Stripe.Checkout.SessionCreateParams.PaymentMethodType[]> = {
  myr: ['card', 'fpx'],
  usd: ['card'],
};

export interface PlanInfo {
  plan: string;
  name: string;
  tier: number;
  priceMYR: number;
  priceUSD: number;
  categoryLimit: number | null;
}

export function getPlans(): PlanInfo[] {
  return planKeys.map(k => ({
    plan: k,
    name: config.plans[k].name,
    tier: config.plans[k].tier,
    priceMYR: config.plans[k].priceMYR,
    priceUSD: config.plans[k].priceUSD,
    categoryLimit: config.plans[k].categoryLimit,
  }));
}

export async function checkout(userId: string, planKey: string, currency: 'myr' | 'usd' = 'myr') {
  const plan = config.plans[planKey as keyof typeof config.plans];
  if (!plan || plan.tier === 0) throw new AppError(400, 'Invalid plan');

  const stripe = getStripe();
  if (!stripe) throw new AppError(500, 'Stripe not configured');

  const user = await pool.query<{ tier: number; email: string }>(
    'SELECT tier, email FROM users WHERE id = $1', [userId]
  );
  if (!user.rowCount || user.rowCount === 0) throw new AppError(404, 'User not found');

  const currentTier = user.rows[0]!.tier;
  if (currentTier >= plan.tier) {
    throw new AppError(400, `You already have tier ${currentTier} or higher`);
  }

  const amount = currency === 'myr' ? plan.priceMYR : plan.priceUSD;
  const amountCents = Math.round(amount * 100);

  const session = await stripe.checkout.sessions.create({
    payment_method_types: PAYMENT_METHODS[currency],
    mode: 'payment',
    customer_email: user.rows[0]!.email,
    line_items: [{
      price_data: {
        currency: currency,
        product_data: {
          name: `QuizMaster — ${plan.name}`,
          description: `${plan.name} access`,
        },
        unit_amount: amountCents,
      },
      quantity: 1,
    }],
    success_url: `${config.server.appUrl}/subscription/success?session_id={CHECKOUT_SESSION_ID}`,
    cancel_url: `${config.server.appUrl}/subscription/cancel`,
    metadata: {
      userId,
      toTier: String(plan.tier),
    },
  });

  await pool.query(
    `INSERT INTO subscription_transactions (user_id, from_tier, to_tier, amount, stripe_session_id)
     VALUES ($1, $2, $3, $4, $5)`,
     [userId, currentTier, plan.tier, amount, session.id]
  );

  return { paymentUrl: session.url, sessionId: session.id };
}

export async function handleWebhook(rawBody: string, signature: string) {
  const stripe = getStripe();
  if (!stripe) throw new AppError(500, 'Stripe not configured');

  let event;
  try {
    event = await stripe.webhooks.constructEventAsync(rawBody, signature, config.stripe.webhookSecret);
  } catch (e) {
    console.error('[WEBHOOK] constructEvent failed:', e);
    throw new AppError(400, 'Invalid webhook signature');
  }

  if (event.type === 'checkout.session.completed') {
    const session = event.data.object as import('stripe').Stripe.Checkout.Session;
    const userId = session.metadata?.userId;
    const toTier = parseInt(session.metadata?.toTier ?? '0', 10);

    if (!userId || toTier <= 0) return { received: true };

    const client = await pool.connect();
    try {
      await client.query('BEGIN');

      const tx = await client.query<{ id: string; user_id: string }>(
        `UPDATE subscription_transactions
         SET status = 'paid', completed_at = now()
         WHERE stripe_session_id = $1 AND status = 'pending'
         RETURNING id`,
        [session.id]
      );

      if (tx.rowCount && tx.rowCount > 0) {
        await client.query(
          'UPDATE users SET tier = $2 WHERE id = $1',
          [userId, toTier]
        );
      }

      await client.query('COMMIT');
      console.log(`[STRIPE] User ${userId} upgraded to tier ${toTier}`);
    } catch (err) {
      await client.query('ROLLBACK');
      console.error('[STRIPE] Webhook failed:', err);
      throw err;
    } finally {
      client.release();
    }
  }

  return { received: true };
}

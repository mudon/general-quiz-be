import { config } from './config';

interface Bucket {
  count: number;
  resetAt: number;
}

const store = new Map<string, Bucket>();

const cleanupInterval = setInterval(() => {
  const now = Date.now();
  for (const [key, bucket] of store) {
    if (now >= bucket.resetAt) store.delete(key);
  }
}, 60_000);

export interface RateLimitConfig {
  max: number;
  windowSec: number;
}

export function createRateLimiter({ max, windowSec }: RateLimitConfig) {
  return (ip: string): { ok: boolean; remaining?: number; retryAfter?: number } => {
    const key = `${ip}`;
    const now = Date.now();

    let bucket = store.get(key);
    if (!bucket || now >= bucket.resetAt) {
      bucket = { count: 1, resetAt: now + windowSec * 1000 };
      store.set(key, bucket);
      return { ok: true, remaining: max - 1 };
    }

    bucket.count++;
    if (bucket.count > max) {
      const retryAfter = Math.ceil((bucket.resetAt - now) / 1000);
      return { ok: false, retryAfter };
    }

    return { ok: true, remaining: max - bucket.count };
  };
}

export type LimiterFn = ReturnType<typeof createRateLimiter>;

export const rateLimiters = {
  login:            createRateLimiter(config.rateLimit.login),
  register:         createRateLimiter(config.rateLimit.register),
  forgotPassword:   createRateLimiter(config.rateLimit.forgotPassword),
  refresh:          createRateLimiter(config.rateLimit.refresh),
  verifyEmail:      createRateLimiter(config.rateLimit.verifyEmail),
  resendVerify:     createRateLimiter(config.rateLimit.resendVerify),
};

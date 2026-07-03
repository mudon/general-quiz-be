export const config = {
  database: {
    url: process.env.DATABASE_URL || 'postgresql://postgres:password@localhost:5432/quiz',
  },
  jwt: {
    secret: process.env.JWT_SECRET || 'dev-secret-change-me-in-production-min-32-chars',
  },
  server: {
    port: parseInt(process.env.PORT || '3000', 10),
    appUrl: process.env.APP_URL || 'http://localhost:3000',
    flutterAppUrl: process.env.FLUTTER_APP_URL || 'http://localhost:8080',
  },
  mail: {
    host: process.env.SMTP_HOST || 'live.smtp.mailtrap.io',
    port: parseInt(process.env.SMTP_PORT || '587', 10),
    user: process.env.SMTP_USER || '',
    pass: process.env.SMTP_PASS || '',
    fromEmail: process.env.SMTP_FROM_EMAIL || 'noreply@quizmaster.local',
    fromName: process.env.SMTP_FROM_NAME || 'QuizMaster',
  },
  stripe: {
    secretKey: process.env.STRIPE_SECRET_KEY || '',
    webhookSecret: process.env.STRIPE_WEBHOOK_SECRET || '',
  },
  plans: {
    free:       { tier: 0, name: 'Free',        priceMYR: 0,   priceUSD: 0,     categoryLimit: null },
    premium_10: { tier: 1, name: 'Premium',     priceMYR: 49.90, priceUSD: 10.99, categoryLimit: 10 },
    premium_all:{ tier: 2, name: 'All Access',  priceMYR: 229.90, priceUSD: 50.99, categoryLimit: null },
  },
  tokens: {
    accessExpiresIn: '15min',
    accessExpiresSeconds: 15 * 60,
    refreshExpiresDays: 7,
    refreshExpiresSeconds: 7 * 24 * 60 * 60,
    resetExpiresIn: '3min',
    resetExpiresSeconds: 3 * 60,
  },
  rateLimit: {
    login:            { max:  5, windowSec: 15 * 60 },
    register:         { max:  3, windowSec: 15 * 60 },
    forgotPassword:   { max:  3, windowSec: 15 * 60 },
    refresh:          { max: 10, windowSec: 60 },
    verifyEmail:      { max:  5, windowSec: 15 * 60 },
    resendVerify:     { max:  3, windowSec: 15 * 60 },
  },
} as const;

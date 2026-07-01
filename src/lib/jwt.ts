import { SignJWT, jwtVerify } from 'jose';
import { v7 as uuidv7 } from 'uuid';
import { createHash, randomBytes } from 'node:crypto';
import { config } from './config';

const secret = new TextEncoder().encode(config.jwt.secret);

export interface TokenPayload {
  sub: string;
  email: string;
  role: string;
}

export interface ResetPayload {
  sub: string;
  purpose: 'reset';
}

export interface EmailChangePayload {
  sub: string;
  purpose: 'change-email';
  newEmail: string;
}

export async function createAccessToken(payload: TokenPayload): Promise<string> {
  return new SignJWT({ ...payload })
    .setProtectedHeader({ alg: 'HS256' })
    .setIssuedAt()
    .setExpirationTime(config.tokens.accessExpiresIn)
    .setJti(uuidv7())
    .sign(secret);
}

export async function createResetToken(sub: string): Promise<string> {
  return new SignJWT({ sub, purpose: 'reset' } satisfies ResetPayload)
    .setProtectedHeader({ alg: 'HS256' })
    .setIssuedAt()
    .setExpirationTime(config.tokens.resetExpiresIn)
    .setJti(uuidv7())
    .sign(secret);
}

export async function createEmailChangeToken(sub: string, newEmail: string): Promise<string> {
  return new SignJWT({ sub, purpose: 'change-email', newEmail } satisfies EmailChangePayload)
    .setProtectedHeader({ alg: 'HS256' })
    .setIssuedAt()
    .setExpirationTime(config.tokens.resetExpiresIn)
    .setJti(uuidv7())
    .sign(secret);
}

export async function verifyToken<T = TokenPayload>(token: string): Promise<T & { sub: string; jti?: string }> {
  const { payload } = await jwtVerify(token, secret);
  return payload as unknown as T & { sub: string; jti?: string };
}

export function generateRefreshTokenValue(): string {
  return randomBytes(32).toString('hex');
}

export function hashToken(token: string): string {
  return createHash('sha256').update(token).digest('hex');
}

import Stripe from 'stripe';
import { config } from './config';

let stripeClient: Stripe | null = null;

export function getStripe(): Stripe | null {
  if (!config.stripe.secretKey) return null;
  if (stripeClient) return stripeClient;
  stripeClient = new Stripe(config.stripe.secretKey);
  return stripeClient;
}

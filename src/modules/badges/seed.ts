import { pool } from '../../db/pool';

interface BadgeDef {
  slug: string;
  name: string;
  description: string;
  color: string;
}

const badges: BadgeDef[] = [
  { slug: 'first-answer',  name: 'First Answer',   description: 'Answered your first question',              color: '#22c55e' },
  { slug: '10-answers',    name: '10 Questions',    description: 'Answered 10 questions',                     color: '#3b82f6' },
  { slug: '50-answers',    name: '50 Questions',    description: 'Answered 50 questions',                      color: '#8b5cf6' },
  { slug: '100-answers',   name: '100 Questions',   description: 'Answered 100 questions',                     color: '#f59e0b' },
  { slug: '500-answers',   name: '500 Questions',   description: 'Answered 500 questions',                     color: '#ef4444' },
  { slug: '1000-answers',  name: '1000 Questions',  description: 'Answered 1000 questions',                    color: '#ec4899' },
  { slug: '7-streak',      name: '7-Day Streak',    description: '7 consecutive correct answers (no misses)',  color: '#06b6d4' },
  { slug: '30-streak',     name: '30-Day Streak',   description: '30 consecutive correct answers (no misses)', color: '#f97316' },
  { slug: '100-streak',    name: '100 Correct',     description: '100 correct answers in a row',               color: '#a855f7' },
];

export async function seedBadges(): Promise<void> {
  for (const b of badges) {
    await pool.query(
      `INSERT INTO badges (slug, name, description, color)
       VALUES ($1, $2, $3, $4)
       ON CONFLICT (slug) DO NOTHING`,
      [b.slug, b.name, b.description, b.color]
    );
  }
  console.log('Badges seeded');
}

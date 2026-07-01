import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { pool } from './pool';

const schemaPath = join(import.meta.dir, '../../docs/general-knowledge-quiz-database.sql');

export async function initDatabase(): Promise<void> {
  const exists = await pool.query(
    `SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'users') AS exists`
  );
  if (exists.rows[0]!.exists) {
    console.log('Database schema already initialized, skipping');
    return;
  }

  const schema = readFileSync(schemaPath, 'utf-8');
  await pool.query(schema);
  console.log('Database schema initialized');
}

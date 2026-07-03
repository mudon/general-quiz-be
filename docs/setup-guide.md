# Fresh Database Setup Guide

## Prerequisites

- **PostgreSQL 18+** (uses `uuidv7()`, `GENERATED ... STORED`, `ltree`, `citext`)
- **Bun** (runtime — `bun run index.ts`)

---

## Step 1 — Create UTF8 Database

Run this **once** as the PostgreSQL superuser (`postgres`):

```sql
CREATE DATABASE general_knowledge_quiz
  WITH OWNER admin_quiz
  ENCODING 'UTF8'
  LC_COLLATE 'en_US.UTF-8'
  LC_CTYPE 'en_US.UTF-8'
  TEMPLATE template0;
```

Verify encoding:

```sql
SELECT pg_encoding_to_char(encoding) FROM pg_database WHERE datname = 'general_knowledge_quiz';
-- Must return: UTF8
```

> **Why template0?** Using `template0` forces clean UTF8 encoding without inheriting locale/collation settings from the default template1 database. Avoids WIN1252 mismatches that break emoji characters.

---

## Step 2 — Start Backend (schema + badges auto-init)

```bash
cd BE
bun run index.ts
```

On first start, this automatically:

| Action | What runs |
|--------|-----------|
| Creates all tables, enums, indexes, triggers, views | `src/db/init.ts` → reads `docs/general-knowledge-quiz-database.sql` |
| Seeds 9 default badges | `src/modules/badges/seed.ts` |

If the `users` table already exists, schema init is skipped (safe to restart).

**Auto-initialized tables:** `categories`, `badges`, `users`, `user_badges`, `user_stats`, `refresh_tokens`, `questions`, `question_options`, `answers`, `multiple_choice_answer_options`, `user_answers`, `review_schedule`, `user_category_stats`, `quiz_sessions`, `subscription_transactions` — plus all triggers, views, indexes, and enums.

---

## Step 3 — Seed Categories (40 topics)

```bash
bun run src/db/seed.ts
```

Seeds 40 hierarchical categories across Science, History, Geography, Entertainment, Technology, Sports, Food.

---

## Step 4 — Seed Questions (37 sample questions)

```bash
bun run src/db/seedQuestions.ts
```

Seeds 37 questions with options and correct answers across multiple categories. Skips if questions already exist.

---

## Full fresh-install (all commands)

```bash
# 1. Create DB via psql (as postgres superuser):
#    CREATE DATABASE general_knowledge_quiz WITH OWNER admin_quiz ENCODING 'UTF8' LC_COLLATE 'en_US.UTF-8' LC_CTYPE 'en_US.UTF-8' TEMPLATE template0;

# 2 - 4:
cd BE
bun run index.ts          # schema + badges
bun run src/db/seed.ts    # categories
bun run src/db/seedQuestions.ts  # questions
```

---

## Encoding note

The backend's `pool.ts` runs `SET client_encoding = 'UTF8'` on every new DB connection as a safety net. If the database was created with WIN1252 encoding (Windows default), this prevents `22P05` errors on emoji/UTF-8 characters — but the database itself should still be UTF8 for full multi-byte character support.

To check current encoding:

```bash
psql -U admin_quiz -d general_knowledge_quiz -c "SHOW server_encoding;"
```

| Return value | Emoji support | Action needed |
|---|---|---|
| `UTF8` | Full | None |
| `WIN1252` or `SQL_ASCII` | Broken | Recreate with Step 1 |

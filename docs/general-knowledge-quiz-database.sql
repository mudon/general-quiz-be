-- ============================================================================
-- TRIVIA / QUIZ QUESTION DATABASE — SCHEMA
-- PostgreSQL 18+ (uses GENERATED columns, uuidv7(); ltree + citext extensions)
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS ltree;
CREATE EXTENSION IF NOT EXISTS citext;

-- ----------------------------------------------------------------------------
-- ENUMS
-- ----------------------------------------------------------------------------
-- "1 choice"        -> single_choice    -> exactly one correct option
-- "multiple choice" -> multiple_choice  -> one or more correct options
-- "filled in"       -> fill_in_blank    -> free-text answer, no options
CREATE TYPE question_type AS ENUM ('single_choice', 'multiple_choice', 'fill_in_blank');

CREATE TYPE role AS ENUM (
    'user',
    'admin'
);

CREATE TYPE auth_provider AS ENUM (
    'email',
    'google'
);

CREATE TYPE avatar_type AS ENUM (
    'icon',
    'upload'
);

-- ----------------------------------------------------------------------------
-- SHARED TRIGGER FUNCTION — maintains updated_at on any table that has one
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION set_updated_at() RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ----------------------------------------------------------------------------
-- CATEGORIES  (hierarchical topic tree, stored with ltree)
-- ----------------------------------------------------------------------------
CREATE TABLE categories (
    id          BIGSERIAL PRIMARY KEY,
    path        LTREE NOT NULL,
    name        TEXT NOT NULL,
    icon        TEXT,                          -- optional emoji/icon for the topic
    sort_order  INTEGER NOT NULL DEFAULT 0,    -- display order among siblings
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT categories_path_unique UNIQUE (path)
);

-- GiST index is what makes ancestor/descendant lookups (<@, @>, ~, ?) fast
CREATE INDEX categories_path_gist_idx ON categories USING GIST (path);
-- btree index speeds up exact-path and prefix(text) lookups / sorting
CREATE INDEX categories_path_btree_idx ON categories USING BTREE (path);
CREATE INDEX categories_name_idx ON categories (lower(name));

-- convenience view: depth + parent path, computed on the fly from ltree
CREATE OR REPLACE VIEW categories_with_depth AS
SELECT
    c.*,
    nlevel(c.path) AS depth,
    CASE WHEN nlevel(c.path) > 1
         THEN subpath(c.path, 0, nlevel(c.path) - 1)
         ELSE NULL
    END AS parent_path
FROM categories c;

-- a category's row id for its parent (NULL for top-level categories)
CREATE OR REPLACE VIEW categories_with_parent AS
SELECT
    cd.*,
    p.id AS parent_id
FROM categories_with_depth cd
LEFT JOIN categories p ON p.path = cd.parent_path;

-- ----------------------------------------------------------------------------
-- BADGES  (created before users, since users.selected_badge_slug references it)
-- ----------------------------------------------------------------------------
CREATE TABLE badges (
    id          SERIAL PRIMARY KEY,
    slug        VARCHAR(100) UNIQUE NOT NULL,
    name        VARCHAR(255) NOT NULL,
    description TEXT,
    icon_url    TEXT,
    color       TEXT,
    created_at  TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- USERS
-- ----------------------------------------------------------------------------
CREATE TABLE users (
    id                  UUID PRIMARY KEY DEFAULT uuidv7(),
    first_name          VARCHAR(255) NOT NULL,
    last_name           VARCHAR(255) NOT NULL,
    email               CITEXT UNIQUE NOT NULL,
    role                role NOT NULL DEFAULT 'user',
    auth_provider       auth_provider NOT NULL DEFAULT 'email',
    google_id           VARCHAR(500) UNIQUE,
    password_hash       TEXT,
    email_verified      BOOLEAN NOT NULL DEFAULT FALSE,
    avatar_type         avatar_type,
    avatar_value        VARCHAR(255),
    selected_badge_slug VARCHAR(100) REFERENCES badges(slug),
    created_at          TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    -- enum decides which column, same convention used by answers/user_answers
    CONSTRAINT users_auth_credential_matches_provider CHECK (
        (auth_provider = 'email'  AND password_hash IS NOT NULL AND google_id IS NULL)
        OR
        (auth_provider = 'google' AND google_id IS NOT NULL AND password_hash IS NULL)
    )
);

CREATE TRIGGER trg_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- selected_badge_slug must be a badge this user has actually earned
CREATE OR REPLACE FUNCTION check_selected_badge_owned() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.selected_badge_slug IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM user_badges ub
        JOIN badges b ON b.id = ub.badge_id
        WHERE ub.user_id = NEW.id AND b.slug = NEW.selected_badge_slug
    ) THEN
        RAISE EXCEPTION 'user % has not earned badge %', NEW.id, NEW.selected_badge_slug;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- (trigger created further down, after user_badges exists)

-- ----------------------------------------------------------------------------
-- USER_BADGES
-- ----------------------------------------------------------------------------
CREATE TABLE user_badges (
    user_id    UUID    NOT NULL REFERENCES users(id)   ON DELETE CASCADE,
    badge_id   INTEGER NOT NULL REFERENCES badges(id)  ON DELETE CASCADE,
    awarded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, badge_id)
);

-- now that user_badges exists, attach the ownership-check trigger from above
CREATE TRIGGER trg_check_selected_badge
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION check_selected_badge_owned();

-- ----------------------------------------------------------------------------
-- USER_STATS
-- ----------------------------------------------------------------------------
CREATE TABLE user_stats (
    user_id                   UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    total_questions_answered INTEGER NOT NULL DEFAULT 0,
    total_correct_streak     INTEGER NOT NULL DEFAULT 0,
    current_login_streak     INTEGER NOT NULL DEFAULT 0,
    longest_login_streak     INTEGER NOT NULL DEFAULT 0,
    last_activity_date       DATE,
    updated_at                TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE refresh_tokens (
    id         UUID PRIMARY KEY DEFAULT uuidv7(),
    user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash TEXT NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_refresh_tokens_hash    ON refresh_tokens(token_hash);
CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);

-- ----------------------------------------------------------------------------
-- QUESTIONS
-- ----------------------------------------------------------------------------
CREATE TABLE questions (
    id             BIGSERIAL PRIMARY KEY,
    category_id    BIGINT NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    question_text  TEXT NOT NULL,
    question_type  question_type NOT NULL,
    explanation    TEXT,                       -- optional "why" shown after answering
    search_vector  tsvector GENERATED ALWAYS AS (to_tsvector('english', question_text)) STORED,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX questions_category_idx ON questions (category_id);
CREATE INDEX questions_type_idx ON questions (question_type);
CREATE INDEX questions_search_idx ON questions USING GIN (search_vector);

CREATE TRIGGER trg_questions_updated_at
BEFORE UPDATE ON questions
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- once a question has a recorded answer, its type is locked: changing
-- single_choice <-> multiple_choice <-> fill_in_blank on the fly would
-- silently orphan whichever answer column was already populated.
CREATE OR REPLACE FUNCTION lock_question_type_if_answered() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.question_type IS DISTINCT FROM OLD.question_type
       AND EXISTS (SELECT 1 FROM answers WHERE question_id = OLD.id) THEN
        RAISE EXCEPTION
            'cannot change question_type for question % once an answer exists; delete the answer row first',
            OLD.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- (trigger created further down, after the answers table exists)

-- ----------------------------------------------------------------------------
-- QUESTION OPTIONS  (only for single_choice / multiple_choice questions)
-- ----------------------------------------------------------------------------
CREATE TABLE question_options (
    id           BIGSERIAL PRIMARY KEY,
    question_id  BIGINT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    option_text  TEXT NOT NULL,
    sort_order   SMALLINT NOT NULL DEFAULT 0,
    UNIQUE (question_id, sort_order)
);

CREATE INDEX question_options_question_idx ON question_options (question_id);

CREATE OR REPLACE FUNCTION check_option_question_type() RETURNS TRIGGER AS $$
DECLARE
    qtype question_type;
BEGIN
    SELECT question_type INTO qtype FROM questions WHERE id = NEW.question_id;
    IF qtype IS NULL THEN
        RAISE EXCEPTION 'question % does not exist', NEW.question_id;
    END IF;
    IF qtype = 'fill_in_blank' THEN
        RAISE EXCEPTION 'question % is fill_in_blank and cannot have options', NEW.question_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_option_question_type
BEFORE INSERT OR UPDATE ON question_options
FOR EACH ROW EXECUTE FUNCTION check_option_question_type();

-- ----------------------------------------------------------------------------
-- ANSWERS
-- Exactly one row per question. question_type is mirrored automatically from
-- the parent question (you never set it by hand) and a CHECK constraint then
-- enforces that ONLY the column matching that type is filled in — the other
-- answer column(s) MUST be NULL. This is the "enum decides which column" rule.
-- multiple_choice correctness lives in multiple_choice_answer_options (a real
-- join table, defined right below) rather than a column here — an array
-- can't carry a native foreign key, a join table can.
-- ----------------------------------------------------------------------------
CREATE TABLE answers (
    id                      BIGSERIAL PRIMARY KEY,
    question_id             BIGINT NOT NULL UNIQUE REFERENCES questions(id) ON DELETE CASCADE,
    question_type           question_type NOT NULL,
    single_choice_answer    BIGINT REFERENCES question_options(id) ON DELETE RESTRICT,
    fill_in_answer          TEXT,
    fill_in_alternatives    TEXT[],              -- optional accepted alternate spellings
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT answers_column_matches_type CHECK (
        (question_type = 'single_choice'
            AND single_choice_answer   IS NOT NULL
            AND fill_in_answer         IS NULL
            AND fill_in_alternatives   IS NULL)
        OR
        (question_type = 'multiple_choice'
            AND single_choice_answer   IS NULL
            AND fill_in_answer         IS NULL
            AND fill_in_alternatives   IS NULL)
        OR
        (question_type = 'fill_in_blank'
            AND fill_in_answer         IS NOT NULL
            AND single_choice_answer   IS NULL)
    )
);

CREATE INDEX answers_question_idx ON answers (question_id);

-- ----------------------------------------------------------------------------
-- MULTIPLE_CHOICE_ANSWER_OPTIONS
-- One row per correct option for a multiple_choice answer. The name says
-- explicitly what it's for, and trg_check_multiple_choice_answer_option_belongs
-- enforces it. option_id uses ON DELETE RESTRICT, matching single_choice_
-- answer's behavior: you cannot delete an option that's part of a correct
-- answer set — Postgres blocks it natively via this foreign key, no custom
-- trigger required.
-- ----------------------------------------------------------------------------
CREATE TABLE multiple_choice_answer_options (
    answer_id BIGINT NOT NULL REFERENCES answers(id) ON DELETE CASCADE,
    option_id BIGINT NOT NULL REFERENCES question_options(id) ON DELETE RESTRICT,
    PRIMARY KEY (answer_id, option_id)
);

-- supports efficient RESTRICT checks when deleting a question_option, and
-- "which answers include this option" lookups (the PK above only serves
-- queries led by answer_id)
CREATE INDEX multiple_choice_answer_options_option_idx
    ON multiple_choice_answer_options (option_id);

-- every row must point at an answer that is actually multiple_choice, and at
-- an option that belongs to that same answer's question
CREATE OR REPLACE FUNCTION check_multiple_choice_answer_option_belongs() RETURNS TRIGGER AS $$
DECLARE
    ans_qid  BIGINT;
    ans_type question_type;
    opt_qid  BIGINT;
BEGIN
    SELECT question_id, question_type INTO ans_qid, ans_type
      FROM answers WHERE id = NEW.answer_id;

    IF ans_type IS DISTINCT FROM 'multiple_choice' THEN
        RAISE EXCEPTION
            'answer % is type %, not multiple_choice; multiple_choice_answer_options only applies to multiple_choice answers',
            NEW.answer_id, ans_type;
    END IF;

    SELECT question_id INTO opt_qid FROM question_options WHERE id = NEW.option_id;
    IF opt_qid IS DISTINCT FROM ans_qid THEN
        RAISE EXCEPTION 'option % does not belong to the same question as answer %',
            NEW.option_id, NEW.answer_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_multiple_choice_answer_option_belongs
BEFORE INSERT OR UPDATE ON multiple_choice_answer_options
FOR EACH ROW EXECUTE FUNCTION check_multiple_choice_answer_option_belongs();

-- a multiple_choice answer must have at least one correct option. A plain
-- CHECK can't span two tables, so this is a deferred constraint trigger
-- instead — deferred so one transaction can insert the answers row and its
-- option rows as separate statements and only be validated at commit.
CREATE OR REPLACE FUNCTION check_multiple_choice_has_options() RETURNS TRIGGER AS $$
DECLARE
    aid      BIGINT;
    ans_type question_type;
BEGIN
    IF TG_TABLE_NAME = 'multiple_choice_answer_options' THEN
        aid := COALESCE(NEW.answer_id, OLD.answer_id);
    ELSE
        aid := NEW.id;
    END IF;

    SELECT question_type INTO ans_type FROM answers WHERE id = aid;

    -- answer no longer exists (e.g. cascaded away with its question), or
    -- isn't multiple_choice: nothing to enforce
    IF ans_type IS DISTINCT FROM 'multiple_choice' THEN
        RETURN NULL;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM multiple_choice_answer_options WHERE answer_id = aid) THEN
        RAISE EXCEPTION
            'multiple_choice answer % must have at least one row in multiple_choice_answer_options',
            aid;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER trg_multiple_choice_answer_options_nonempty
AFTER INSERT OR UPDATE OR DELETE ON multiple_choice_answer_options
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION check_multiple_choice_has_options();

CREATE CONSTRAINT TRIGGER trg_answers_multiple_choice_nonempty
AFTER INSERT OR UPDATE ON answers
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION check_multiple_choice_has_options();

-- now that `answers` exists, attach the type-lock trigger from above
CREATE TRIGGER trg_lock_question_type
BEFORE UPDATE ON questions
FOR EACH ROW EXECUTE FUNCTION lock_question_type_if_answered();

-- always copy question_type from the parent question — never trust client input
CREATE OR REPLACE FUNCTION sync_answer_question_type() RETURNS TRIGGER AS $$
DECLARE
    qtype question_type;
BEGIN
    SELECT question_type INTO qtype FROM questions WHERE id = NEW.question_id;
    IF qtype IS NULL THEN
        RAISE EXCEPTION 'question % does not exist', NEW.question_id;
    END IF;
    NEW.question_type := qtype;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_sync_answer_question_type
BEFORE INSERT OR UPDATE ON answers
FOR EACH ROW EXECUTE FUNCTION sync_answer_question_type();

-- make sure single_choice_answer, if set, really belongs to this question.
-- (multiple_choice is validated separately, per-row, by
-- trg_check_multiple_choice_answer_option_belongs on multiple_choice_answer_options)
CREATE OR REPLACE FUNCTION validate_answer_options() RETURNS TRIGGER AS $$
BEGIN
    -- NULL is deliberately left for the answers_column_matches_type CHECK
    -- constraint to reject, with its clearer "wrong column for this
    -- question_type" message. This only validates a column that is actually
    -- populated.
    IF NEW.question_type = 'single_choice' AND NEW.single_choice_answer IS NOT NULL THEN
        PERFORM 1 FROM question_options
         WHERE id = NEW.single_choice_answer AND question_id = NEW.question_id;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'single_choice_answer % is not an option of question %',
                NEW.single_choice_answer, NEW.question_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_answer_options
BEFORE INSERT OR UPDATE ON answers
FOR EACH ROW EXECUTE FUNCTION validate_answer_options();

-- ----------------------------------------------------------------------------
-- CONVENIENCE VIEW — one row per question, options folded into JSON,
-- whichever answer column applies surfaced alongside it
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW question_full AS
SELECT
    q.id               AS question_id,
    q.question_text,
    q.question_type,
    q.explanation,
    c.id               AS category_id,
    c.path             AS category_path,
    c.name             AS category_name,
    a.single_choice_answer,
    (
        SELECT array_agg(mco.option_id ORDER BY mco.option_id)
        FROM multiple_choice_answer_options mco
        WHERE mco.answer_id = a.id
    ) AS multiple_choice_answer,
    a.fill_in_answer,
    a.fill_in_alternatives,
    (
        SELECT jsonb_agg(
                   jsonb_build_object('id', o.id, 'text', o.option_text, 'sort_order', o.sort_order)
                   ORDER BY o.sort_order
               )
        FROM question_options o
        WHERE o.question_id = q.id
    ) AS options
FROM questions q
JOIN categories c ON c.id = q.category_id
LEFT JOIN answers a ON a.question_id = q.id;

-- ============================================================================
-- USER_ANSWERS — what a user submitted, graded automatically as correct/incorrect.
-- Same enum-driven "only the matching column is non-NULL" pattern as `answers`.
--
-- submitted_multiple_choice stays a plain array rather than a join table,
-- unlike answers.multiple_choice_answer above. This row's is_correct is
-- computed synchronously in a BEFORE INSERT trigger, which needs the full
-- submission already present the instant the row is inserted — and
-- update_review_schedule reads that result immediately after, in an AFTER
-- INSERT trigger on the same row. A child table can't be populated until
-- this row's id exists, so its data would always arrive one statement too
-- late for that grading trigger. answers has no such synchronous dependency,
-- which is exactly why only that side was normalized into a join table.
-- ============================================================================
CREATE TABLE user_answers (
    id                         BIGSERIAL PRIMARY KEY,
    user_id                    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    question_id                BIGINT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    question_type              question_type NOT NULL,        -- mirrored automatically, see trigger below
    submitted_single_choice    BIGINT REFERENCES question_options(id) ON DELETE RESTRICT,
    submitted_multiple_choice  BIGINT[],
    submitted_fill_in          TEXT,
    is_correct                 BOOLEAN,                        -- computed automatically, see trigger below
    answered_at                TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT user_answers_column_matches_type CHECK (
        (question_type = 'single_choice'
            AND submitted_single_choice   IS NOT NULL
            AND submitted_multiple_choice IS NULL
            AND submitted_fill_in         IS NULL)
        OR
        (question_type = 'multiple_choice'
            AND submitted_multiple_choice IS NOT NULL
            AND submitted_single_choice   IS NULL
            AND submitted_fill_in         IS NULL)
        OR
        (question_type = 'fill_in_blank'
            AND submitted_fill_in         IS NOT NULL
            AND submitted_single_choice   IS NULL
            AND submitted_multiple_choice IS NULL)
    )
);

CREATE INDEX user_answers_user_idx ON user_answers (user_id);
CREATE INDEX user_answers_question_idx ON user_answers (question_id);
CREATE INDEX user_answers_user_question_idx ON user_answers (user_id, question_id, answered_at);

-- mirror question_type from the parent question, same as `answers`
CREATE OR REPLACE FUNCTION sync_user_answer_type() RETURNS TRIGGER AS $$
DECLARE qtype question_type;
BEGIN
    SELECT question_type INTO qtype FROM questions WHERE id = NEW.question_id;
    IF qtype IS NULL THEN
        RAISE EXCEPTION 'question % does not exist', NEW.question_id;
    END IF;
    NEW.question_type := qtype;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_1_sync_user_answer_type
BEFORE INSERT OR UPDATE ON user_answers
FOR EACH ROW EXECUTE FUNCTION sync_user_answer_type();

-- grade the submission against `answers` for this question
CREATE OR REPLACE FUNCTION grade_user_answer() RETURNS TRIGGER AS $$
DECLARE
    ans_id             BIGINT;
    correct_single     BIGINT;
    correct_multi      BIGINT[];
    correct_fill       TEXT;
    correct_fill_alts  TEXT[];
BEGIN
    SELECT a.id, a.single_choice_answer, a.fill_in_answer, a.fill_in_alternatives
      INTO ans_id, correct_single, correct_fill, correct_fill_alts
    FROM answers a WHERE a.question_id = NEW.question_id;

    IF NEW.question_type = 'single_choice' THEN
        NEW.is_correct := (NEW.submitted_single_choice = correct_single);

    ELSIF NEW.question_type = 'multiple_choice' THEN
        SELECT array_agg(option_id ORDER BY option_id) INTO correct_multi
        FROM multiple_choice_answer_options WHERE answer_id = ans_id;

        NEW.is_correct := (
            NEW.submitted_multiple_choice IS NOT NULL AND correct_multi IS NOT NULL
            AND (SELECT array_agg(x ORDER BY x) FROM unnest(NEW.submitted_multiple_choice) AS x) =
                (SELECT array_agg(x ORDER BY x) FROM unnest(correct_multi) AS x)
        );

    ELSIF NEW.question_type = 'fill_in_blank' THEN
        NEW.is_correct := (
            lower(trim(NEW.submitted_fill_in)) = lower(trim(correct_fill))
            OR lower(trim(NEW.submitted_fill_in)) = ANY (
                 SELECT lower(trim(alt)) FROM unnest(coalesce(correct_fill_alts, ARRAY[]::text[])) AS alt
               )
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_2_grade_user_answer
BEFORE INSERT OR UPDATE ON user_answers
FOR EACH ROW EXECUTE FUNCTION grade_user_answer();

-- ----------------------------------------------------------------------------
-- guard against deleting a question_option that's still referenced by an
-- existing user submission. single_choice_answer, submitted_single_choice,
-- and multiple_choice_answer_options.option_id are all real foreign keys
-- with ON DELETE RESTRICT, so Postgres already blocks deleting an option
-- referenced there — no custom code needed for those three. submitted_
-- multiple_choice is the one remaining plain array (see the note above
-- user_answers for why it stayed that way), so it's the only case that
-- still needs an explicit check here.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION protect_option_in_use() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM user_answers WHERE OLD.id = ANY(submitted_multiple_choice)
    ) THEN
        RAISE EXCEPTION 'option % is referenced by an existing user_answers submission', OLD.id;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_protect_option_in_use
BEFORE DELETE ON question_options
FOR EACH ROW EXECUTE FUNCTION protect_option_in_use();

-- ============================================================================
-- REVIEW_SCHEDULE — spaced repetition, one row per (user, question).
-- Simplified SM-2: correct answers push interval_days out further (scaled by
-- ease_factor); a miss resets repetitions, shrinks ease_factor, and brings
-- the question back tomorrow.
-- ============================================================================
CREATE TABLE review_schedule (
    id                BIGSERIAL PRIMARY KEY,
    user_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    question_id       BIGINT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    ease_factor       NUMERIC(4,2) NOT NULL DEFAULT 2.5,
    interval_days     INTEGER NOT NULL DEFAULT 0,
    repetitions       INTEGER NOT NULL DEFAULT 0,
    lapses            INTEGER NOT NULL DEFAULT 0,
    due_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    last_reviewed_at  TIMESTAMPTZ,
    UNIQUE (user_id, question_id)
);

CREATE INDEX review_schedule_due_idx ON review_schedule (user_id, due_at);

CREATE OR REPLACE FUNCTION update_review_schedule() RETURNS TRIGGER AS $$
DECLARE
    r            review_schedule%ROWTYPE;
    new_ef       NUMERIC(4,2);
    new_interval INTEGER;
    new_reps     INTEGER;
    new_lapses   INTEGER;
BEGIN
    SELECT * INTO r FROM review_schedule
     WHERE user_id = NEW.user_id AND question_id = NEW.question_id;

    IF NOT FOUND THEN
        INSERT INTO review_schedule (user_id, question_id)
        VALUES (NEW.user_id, NEW.question_id)
        RETURNING * INTO r;
    END IF;

    IF NEW.is_correct THEN
        new_reps   := r.repetitions + 1;
        new_lapses := r.lapses;
        new_ef     := LEAST(3.0, GREATEST(1.3, r.ease_factor + 0.1));
        new_interval := CASE
            WHEN new_reps = 1 THEN 1
            WHEN new_reps = 2 THEN 6
            ELSE GREATEST(1, round(r.interval_days * new_ef))
        END;
    ELSE
        new_reps     := 0;
        new_lapses   := r.lapses + 1;
        new_ef       := GREATEST(1.3, r.ease_factor - 0.2);
        new_interval := 1;
    END IF;

    UPDATE review_schedule SET
        ease_factor      = new_ef,
        interval_days    = new_interval,
        repetitions      = new_reps,
        lapses           = new_lapses,
        due_at           = now() + (new_interval || ' days')::interval,
        last_reviewed_at = now()
    WHERE user_id = NEW.user_id AND question_id = NEW.question_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_review_schedule
AFTER INSERT ON user_answers
FOR EACH ROW EXECUTE FUNCTION update_review_schedule();

-- convenience: what's due right now, per user
CREATE OR REPLACE VIEW due_for_review AS
SELECT rs.user_id, rs.question_id, rs.due_at, rs.interval_days, rs.repetitions, rs.lapses,
       q.question_text, q.question_type, q.category_id
FROM review_schedule rs
JOIN questions q ON q.id = rs.question_id
WHERE rs.due_at <= now();

-- ----------------------------------------------------------------------------
-- USER_CATEGORY_STATS
-- ----------------------------------------------------------------------------
CREATE TABLE user_category_stats (
    user_id             UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id         BIGINT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,

    questions_answered  INTEGER NOT NULL DEFAULT 0,
    correct_answers     INTEGER NOT NULL DEFAULT 0,

    last_answered_at    TIMESTAMPTZ,

    PRIMARY KEY (user_id, category_id)
);

-- ----------------------------------------------------------------------------
-- QUIZ_SESSIONS — one row per quiz round a user plays in a category.
-- "next question" excludes any question answered after session.created_at
-- so the user never sees the same question twice in one round.
-- ----------------------------------------------------------------------------
CREATE TABLE quiz_sessions (
    id                BIGSERIAL PRIMARY KEY,
    user_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id       BIGINT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    total_questions   INTEGER NOT NULL DEFAULT 0,
    answered_count    INTEGER NOT NULL DEFAULT 0,
    correct_count     INTEGER NOT NULL DEFAULT 0,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at      TIMESTAMPTZ
);

CREATE INDEX quiz_sessions_user_idx ON quiz_sessions (user_id, category_id);
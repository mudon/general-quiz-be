================================================================================
API ENDPOINTS — General Knowledge Quiz Backend
================================================================================

BASE URL: http://localhost:3000

================================================================================
AUTH /api/auth
================================================================================

POST /api/auth/register
  Auth: none
  Body:
    {
      "firstName": "string (1-255)",
      "lastName":  "string (1-255)",
      "email":     "string (email format)",
      "password":  "string (min 8, max 128)"
    }
  Response 200:
    {
      "user": {
        "id":        "uuid",
        "firstName": "string",
        "lastName":  "string",
        "email":     "string",
        "role":      "user",
        "createdAt": "ISO8601"
      },
      "accessToken":  "jwt",
      "refreshToken": "hex string (64 chars)"
    }
  Errors: 409 (email already exists)

---

POST /api/auth/login
  Auth: none
  Body:
    {
      "email":    "string (email format)",
      "password": "string"
    }
   Response 200: same shape as POST /register
   Errors: 401 (invalid credentials), 403 (email not verified)

---

POST /api/auth/refresh
  Auth: none
  Body:
    {
      "accessToken":  "jwt (current, can be expired)",
      "refreshToken": "hex string"
    }
  Response 200:
    {
      "accessToken":  "jwt (new)",
      "refreshToken": "hex string (new)"
    }
  Errors: 401 (invalid/expired/revoked refresh token)

---

POST /api/auth/forgot-password
  Auth: none
  Body:
    {
      "email": "string (email format)"
    }
  Response 200:
    {
      "message":   "If that email exists, a reset link has been sent",
      "debugToken": "jwt (only in non-production)"
    }
   Notes: reset token is a signed JWT, valid 3 minutes. Token is sent via SMTP (Mailtrap).

---

POST /api/auth/reset-password
  Auth: none
  Body:
    {
      "token":    "jwt (from forgot-password)",
      "password": "string (min 8, max 128)"
    }
  Response 200:
    {
      "message": "Password has been reset successfully. All sessions signed out."
    }
  Errors: 400 (invalid/expired token)
  Notes: invalidates ALL existing refresh tokens for this user

---

POST /api/auth/logout
  Auth: Bearer <accessToken>
  Body:
    {
      "refreshToken": "hex string"
    }
  Response 200:
    {
      "message": "Logged out successfully"
    }
  Errors: 401 (not authenticated)

---

GET /api/auth/me
  Auth: Bearer <accessToken>
  Response 200:
    {
      "id":              "uuid",
      "firstName":       "string",
      "lastName":        "string",
      "email":           "string",
      "role":            "user | admin",
      "avatarType":      "icon | upload | null",
      "avatarValue":     "string | null",
      "selectedBadgeSlug":"string | null",
      "emailVerified":   "boolean",
      "createdAt":       "ISO8601",
      "badges": [
        {
          "slug":        "string",
          "name":        "string",
          "description": "string | null",
          "iconUrl":     "string | null",
          "color":       "string | null",
          "awardedAt":   "ISO8601"
        }
      ]
    }
  Errors: 401 (not authenticated), 404

---

PUT /api/auth/password
  Auth: Bearer <accessToken>
  Body:
    {
      "currentPassword": "string",
      "newPassword":     "string (min 8, max 128)"
     }
  Response 200:
    { "message": "Password changed. All sessions signed out." }
  Errors: 401 (wrong current password), 400 (Google account)

---

PUT /api/auth/profile
  Auth: Bearer <accessToken>
  Body (all optional):
    {
      "firstName":   "string (1-255)",
      "lastName":    "string (1-255)",
      "avatarType":  "icon | upload | null",
      "avatarValue": "string | null (url or icon name)"
    }
  Response 200: updated user profile (same shape as GET /me)

---

POST /api/auth/send-verification
  Auth: Bearer <accessToken>
  Response 200:
    { "message": "Verification email sent", "debugToken": "jwt (non-production only)" }
  Notes: generates a signed JWT verification token, logged to console.

---

POST /api/auth/verify-email
   Auth: none
   Body:
     { "token": "jwt (from send-verification)" }
   Response 200:
     { "message": "Email verified successfully" }
   Errors: 400 (invalid/expired token)

---
   
POST /api/auth/change-email
   Auth: Bearer <accessToken>
   Body:
     {
       "currentPassword": "string",
       "newEmail":        "string (email format)"
     }
   Response 200:
     { 
       "message":   "Verification sent to new@email.com. Use the token to confirm.",
       "debugToken": "jwt (only in non-production)"
     }
   Errors: 401 (wrong password), 409 (email already taken), 400 (Google account)
   Notes: sends verification token to the NEW email. Old email still works until verified.
          Token expires in 3 minutes.

---

POST /api/auth/verify-new-email
   Auth: none
   Body:
     { "token": "jwt (from change-email)" }
   Response 200:
     { "message": "Email changed successfully. Please log in with your new email." }
   Errors: 400 (invalid/expired token), 409 (email taken since request)
   Notes: updates users.email, invalidates all refresh tokens (force re-login).

---
   
POST /api/auth/resend-verification
   Auth: none
   Body:
     { "email": "string (email format)" }
   Response 200:
     { 
       "message":   "If that email is registered and unverified, a new code has been sent.",
       "debugToken": "jwt (only in non-production)"
     }
   Notes: public endpoint (unverified users can't login, so no auth required).
          Token expires in 3 minutes.

================================================================================
CATEGORIES /api/categories  +  /api/admin/categories
================================================================================

GET /api/categories
  Auth: none
  Query:
    tree  boolean (optional, default false)
          true  -> nested tree structure
          false -> flat array
  Response 200 (flat):
    [
      {
        "id":        "string",
        "name":      "string",
        "path":      "string (ltree, e.g. Science.Biology)",
        "icon":      "string | null",
        "sortOrder": "number",
        "depth":     "number",
        "parentId":  "string | null",
        "children":  []
      }
    ]
  Response 200 (tree):
    [                    // top-level categories only
      {
        "id":        "string",
        "name":      "string",
        "path":      "string",
        "icon":      "string | null",
        "sortOrder": "number",
        "depth":     "number",
        "parentId":  "string | null",
        "children": [
          {
            ...       // nested recursively
            "children": []
          }
        ]
      }
    ]

---

GET /api/categories/:id
   Auth: none
   Response 200: single CategoryTree object (with empty children array)
   Errors: 404

---

GET /api/categories/completion-status
   Auth: Bearer <accessToken>
   Response 200:
     [
       {
         "categoryId":       "string",
         "totalQuestions":   "number (count in entire subtree)",
         "answeredQuestions": "number (distinct questions answered at least once)",
         "completed":        "boolean (answeredQuestions >= totalQuestions)"
       }
     ]
   Notes: only returns categories that have at least one question in their subtree.
          Uses ltree <@ to count across the full category tree.
          A parent category shows completed = true only when ALL descendants
          have all questions answered.
          Counts are computed live from user_answers — never stale.
          Ordered by category path.

---

POST /api/admin/categories
  Auth: Bearer <accessToken> (admin role required)
  Body:
    {
      "name":      "string (1-255)",
      "parentId":  "string | null (optional)",
      "icon":      "string | null (optional)",
      "sortOrder": "number (optional, default 0)"
    }
  Response 200: created CategoryTree object
  Errors: 401, 403, 404 (parent not found)
  Notes: path label auto-generated from name (lowercase, spaces->underscores)

---

PUT /api/admin/categories/:id
  Auth: Bearer <accessToken> (admin role required)
  Body:
    {
      "name":      "string (optional, renaming updates entire subtree paths)",
      "icon":      "string | null (optional)",
      "sortOrder": "number (optional)"
    }
  Response 200: updated CategoryTree object
  Errors: 401, 403, 404

---

DELETE /api/admin/categories/:id
  Auth: Bearer <accessToken> (admin role required)
  Response 200:
    { "message": "Category deleted" }
  Errors: 401, 403, 404
  Notes: deletes category + all descendants. Fails if any descendant category
         has questions (ON DELETE RESTRICT).

================================================================================
QUESTIONS /api/questions  +  /api/admin/questions
================================================================================

GET /api/questions
  Auth: none
  Query (all optional):
    categoryId  string   filter by category (includes subcategories via ltree)
    type        string   single_choice | multiple_choice | fill_in_blank
    search      string   full-text search on question text
    cursor      string   question id to start after (cursor pagination)
    limit       number   default 20, max 100
  Response 200:
    {
      "items": [
        {
          "id":           "string",
          "categoryId":   "string",
          "categoryName": "string",
          "categoryPath": "string",
          "questionText": "string",
          "questionType": "single_choice | multiple_choice | fill_in_blank",
          "explanation":  "string | null",
          "options":      [
            { "id": "string", "text": "string", "sort_order": "number" }
          ] | null,
          "createdAt":    "ISO8601"
        }
      ],
      "nextCursor": "string | null (last item id, null when no more items)",
      "hasMore":    "boolean"
    }
  Pagination: cursor-based. Send ?cursor=<lastItemId> to get the next page.
              First request: no cursor. Subsequent: use nextCursor from previous response.
              No total count, no page numbers — use hasMore to know when to stop.
  Notes: options is null for fill_in_blank questions.
         NO correct answer included in public endpoint.

---

GET /api/questions/:id
  Auth: none
  Response 200: single item from the list above (no correct answer)
  Errors: 404

---

GET /api/admin/questions/:id
  Auth: Bearer <accessToken> (admin role required)
  Response 200: same as public + answer field:
    {
      ...all fields from public,
      "answer": <see answer shapes below>
    }
  Answer shapes by question_type:
    single_choice:
      { "type": "single_choice", "correctOptionId": "string" }

    multiple_choice:
      { "type": "multiple_choice", "correctOptionIds": ["string", ...] }

    fill_in_blank:
      {
        "type": "fill_in_blank",
        "answer": "string",
        "alternatives": ["string", ...] | null
      }

---

POST /api/admin/questions
  Auth: Bearer <accessToken> (admin role required)
  Body varies by question_type:

  --- single_choice ---
  {
    "categoryId":   "string",
    "questionText": "string",
    "questionType": "single_choice",
    "explanation":  "string | null (optional)",
    "options": [
      { "text": "string", "sortOrder": "number (optional)" }
    ],
    "answer": { "optionIndex": 0 }
  }

  --- multiple_choice ---
  {
    "categoryId":   "string",
    "questionText": "string",
    "questionType": "multiple_choice",
    "explanation":  "string | null (optional)",
    "options": [
      { "text": "string", "sortOrder": "number (optional)" }
    ],
    "answer": { "optionIndices": [0, 2] }
  }

  --- fill_in_blank ---
  {
    "categoryId":   "string",
    "questionText": "string",
    "questionType": "fill_in_blank",
    "explanation":  "string | null (optional)",
    "answer": {
      "text":         "string (correct answer)",
      "alternatives": ["string"]  (optional, accepted alternate spellings)
    }
  }

  Response 200: created question with answer (same as GET /api/admin/questions/:id)
  Errors: 400 (validation), 401, 403, 404 (category not found)
  Notes: entire creation runs in a single DB transaction.
         For single_choice: optionIndex references the 0-based position
         in the options array (inserted in the order provided).
         fill_in_blank questions cannot have options.

---

PUT /api/admin/questions/:id
  Auth: Bearer <accessToken> (admin role required)
  Body (all fields optional):
    {
      "categoryId":   "string (optional)",
      "questionText": "string (optional)",
      "explanation":  "string | null (optional)"
    }
  Response 200: updated question (public view, no answer)
  Errors: 401, 403, 404
  Notes: cannot change question_type once answer exists (DB trigger).
         options and answer are NOT updatable via this endpoint.

---

DELETE /api/admin/questions/:id
  Auth: Bearer <accessToken> (admin role required)
  Response 200:
    { "message": "Question deleted" }
  Errors: 401, 403, 404
  Notes: cascades to question_options, answers, multiple_choice_answer_options.

=  Notes: cascades to question_options, answers, multiple_choice_answer_options.

================================================================================
ANSWERS / QUIZ LOOP /api/questions/:id/answer  +  /api/review/due  +  /api/answers/history
================================================================================

POST /api/questions/:id/answer
  Auth: Bearer <accessToken>
  Body varies by question_type (send only the field matching the question type):

  --- single_choice ---
  {
    "submittedSingleChoice": "option_id_string"
  }

  --- multiple_choice ---
  {
    "submittedMultipleChoice": ["option_id_1", "option_id_2"]
  }

  --- fill_in_blank ---
  {
    "submittedFillIn": "string"
  }

  Response 200:
    {
      "id":            "string (user_answer id)",
      "isCorrect":     "boolean (computed by DB trigger)",
      "questionText":  "string",
      "questionType":  "single_choice | multiple_choice | fill_in_blank",
      "explanation":   "string | null",
      "correctAnswer": {
        "singleChoiceAnswer":   "string | null",
        "multipleChoiceAnswer": ["string", ...] | null,
        "fillInAnswer":         "string | null",
        "fillInAlternatives":   ["string", ...] | null
      },
      "options": [
        { "id": "string", "text": "string", "sortOrder": "number" }
      ] | null
    }
  Notes: auto-graded by DB trigger (trg_2_grade_user_answer).
         SM-2 review schedule updated automatically (trg_update_review_schedule).
         Returns correct answer so the frontend can show what was right.
         fill_in_blank: case-insensitive, trimmed comparison against answer + alternatives.

---

GET /api/review/due
  Auth: Bearer <accessToken>
  Query:
    cursor  string   question_id to start after (cursor pagination)
    limit   number   default 20, max 100
  Response 200:
    {
      "items": [
        {
          "questionId":   "string",
          "questionText": "string",
          "questionType": "single_choice | multiple_choice | fill_in_blank",
          "categoryId":   "string",
          "dueAt":        "ISO8601",
          "intervalDays": "number (SM-2 current interval)",
          "repetitions":  "number (SM-2 consecutive correct count)",
          "lapses":       "number (SM-2 miss count)",
          "options": [
            { "id": "string", "text": "string", "sortOrder": "number" }
          ] | null
        }
      ],
      "nextCursor": "string | null",
      "hasMore":    "boolean"
    }
  Notes: sourced from the due_for_review view (WHERE due_at <= now()).
         SM-2 algorithm: correct -> interval extends (1, 6, then scaled by ease_factor).
         Miss -> resets interval to 1 day, decreases ease_factor.

---

GET /api/answers/history
  Auth: Bearer <accessToken>
  Query:
    cursor  string   user_answer id to start before (cursor pagination)
    limit   number   default 20, max 100
  Response 200:
    {
      "items": [
        {
          "id":                    "string",
          "questionId":            "string",
          "questionText":          "string",
          "questionType":          "single_choice | multiple_choice | fill_in_blank",
          "categoryId":            "string",
          "categoryName":          "string",
          "submittedSingleChoice":   "string | null",
          "submittedMultipleChoice": ["string", ...] | null,
          "submittedFillIn":         "string | null",
          "isCorrect":             "boolean",
          "answeredAt":            "ISO8601"
        }
      ],
      "nextCursor": "string | null",
      "hasMore":    "boolean"
    }
   Notes: ordered newest-first (DESC by id).
          Pagination: send ?cursor=<lastItemId> to get older answers.

================================================================================
QUIZ SESSIONS /api/quiz/sessions
================================================================================

POST /api/quiz/sessions
   Auth: Bearer <accessToken>
   Body:
     { "categoryId": "string" }
   Response 200:
     {
       "sessionId":      "string",
       "categoryId":     "string",
       "categoryName":   "string",
       "totalQuestions": "number (count in category subtree)",
       "answeredCount":  "number",
       "correctCount":   "number",
       "createdAt":      "ISO8601",
       "completedAt":    "null"
     }
   Notes: counts all questions in the category's entire subtree (via ltree <@).
          If the user already has an active session for this category, a new
          session row is created (multiple sessions per category are possible).

---

GET /api/quiz/sessions
   Auth: Bearer <accessToken>
   Response 200:
     [
       {
         "sessionId":      "string",
         "categoryId":     "string",
         "categoryName":   "string",
         "totalQuestions": "number",
         "answeredCount":  "number (computed live from user_answers)",
         "correctCount":   "number (computed live from user_answers)",
         "createdAt":      "ISO8601",
         "completedAt":    "string | null"
       }
     ]
   Notes: only returns sessions where completed_at IS NULL.
          answeredCount and correctCount are computed live from user_answers
          at query time (not from the column), so they're always accurate
          even if the app was closed mid-session.

---

GET /api/quiz/sessions/:id/next
   Auth: none
   Response 200 (question available):
     {
       "completed":    false,
       "questionId":   "string",
       "questionText": "string",
       "questionType": "single_choice | multiple_choice | fill_in_blank",
       "categoryId":   "string",
       "categoryName": "string",
       "options": [
         { "id": "string", "text": "string", "sort_order": "number" }
       ] | null,
       "session": {
         "totalQuestions":  "number",
         "answeredCount":   "number",
         "remainingCount":  "number"
       }
     }
   Response 200 (all questions answered):
     {
       "completed":       true,
       "totalQuestions":  "number",
       "answeredCount":   "number"
     }
   Notes: picks a random question that the user hasn't answered during
          this session (compared via user_answers.answered_at > session.created_at).
          When no questions remain, auto-completes the session (sets completed_at).
          Session counts are live-computed from user_answers, never stale.

---

PUT /api/quiz/sessions/:id/reset
   Auth: none
   Response 200:
     { "message": "Session reset", "sessionId": "string", "totalQuestions": "number" }
   Errors: 404 (session not found or already completed)
   Notes: resets answered_count = 0, correct_count = 0, recalculates total_questions,
          and resets created_at to now() (so future answers count for the fresh round).

================================================================================
STATS /api/stats  +  /api/stats/categories
================================================================================

GET /api/stats
  Auth: Bearer <accessToken>
  Response 200:
    {
      "totalQuestionsAnswered": "number",
      "totalCorrectStreak":     "number (consecutive correct, resets to 0 on miss)",
      "currentLoginStreak":     "number",
      "longestLoginStreak":     "number",
      "lastActivityDate":       "string (date) | null"
    }
  Notes: stats are updated automatically on every answer submission (POST /api/questions/:id/answer).
         If no answers yet, returns all zeros/null.

---

GET /api/stats/categories
  Auth: Bearer <accessToken>
  Response 200:
    [
      {
        "categoryId":       "string",
        "categoryName":     "string",
        "categoryPath":     "string",
        "questionsAnswered": "number",
        "correctAnswers":   "number",
        "accuracy":         "number (percentage, e.g. 73.3)",
        "lastAnsweredAt":   "string (ISO8601) | null"
      }
    ]
  Notes: ordered by questions_answered DESC.
         Only categories the user has answered appear.

===============================================================================
BADGES /api/badges  +  /api/admin/badges
===============================================================================

AUTO-AWARDING: Badges are earned automatically after each answer submission.
The POST /api/questions/:id/answer response includes a "newBadges" array
with any badges just earned. No manual awarding needed.

Pre-seeded badges:
  first-answer   — 1 question answered
  10-answers     — 10 questions answered
  50-answers     — 50 questions answered
  100-answers    — 100 questions answered
  500-answers    — 500 questions answered
  1000-answers   — 1000 questions answered
  7-streak       — 7 consecutive correct answers
  30-streak      — 30 consecutive correct answers
  100-streak     — 100 consecutive correct answers

GET /api/badges
  Auth: optional (returns earned status if authenticated)
  Response 200:
    [
      {
        "id":          "number",
        "slug":        "string",
        "name":        "string",
        "description": "string | null",
        "iconUrl":     "string | null",
        "color":       "string | null",
        "createdAt":   "ISO8601",
        "earned":      "boolean",
        "earnedAt":    "ISO8601 | null (when earned)"
      }
    ]
  Notes: if no auth header, all earned = false.

---

GET /api/badges/earned
  Auth: Bearer <accessToken>
  Response 200: same shape as above, filtered to earned only, ordered by awarded_at DESC.

---

PUT /api/users/me/badge
  Auth: Bearer <accessToken>
  Body:
    { "slug": "string (badge slug)" }
  Response 200:
    { "selectedBadgeSlug": "string" }
  Errors: 404 (badge not found or slug invalid)
         DB trigger blocks if user hasn't earned this badge.

---

GET /api/admin/badges
  Auth: Bearer <accessToken> (admin role required)
  Response 200: all badges (same shape, no earned status)

---

POST /api/admin/badges
  Auth: Bearer <accessToken> (admin role required)
  Body:
    {
      "slug":        "string (1-100, unique)",
      "name":        "string (1-255)",
      "description": "string | null (optional)",
      "iconUrl":     "string | null (optional)",
      "color":       "string | null (optional)"
    }
  Response 200: created badge object
  Errors: 401, 403, 409 (duplicate slug)

---

PUT /api/admin/badges/:id
  Auth: Bearer <accessToken> (admin role required)
  Body (all optional):
    {
      "slug":        "string (optional)",
      "name":        "string (optional)",
      "description": "string | null (optional)",
      "iconUrl":     "string | null (optional)",
      "color":       "string | null (optional)"
    }
  Response 200: updated badge
  Errors: 401, 403, 404

---

DELETE /api/admin/badges/:id
  Auth: Bearer <accessToken> (admin role required)
  Response: { "message": "Badge deleted" }
  Notes: cascades to user_badges (users lose this badge).

---

POST /api/admin/badges/award
  REMOVED — badges are now auto-awarded based on user milestones.
  No manual awarding needed.

---

DELETE /api/admin/badges/revoke
  REMOVED — same reason as above.

================================================================================
ADMIN / USERS /api/admin/users
================================================================================

GET /api/admin/users
  Auth: Bearer <accessToken> (admin role required)
  Query:
    cursor  string   user id to start after (cursor pagination)
    limit   number   default 20, max 100
  Response 200:
    {
      "items": [
        {
          "id":            "uuid",
          "firstName":     "string",
          "lastName":      "string",
          "email":         "string",
          "role":          "user | admin",
          "authProvider":  "email | google",
          "emailVerified": "boolean",
          "createdAt":     "ISO8601"
        }
      ],
      "nextCursor": "string | null",
      "hasMore":    "boolean"
    }

---

GET /api/admin/users/:id
  Auth: Bearer <accessToken> (admin role required)
  Response 200:
    {
      "id":              "uuid",
      "firstName":       "string",
      "lastName":        "string",
      "email":           "string",
      "role":            "user | admin",
      "authProvider":    "email | google",
      "emailVerified":   "boolean",
      "avatarType":      "icon | upload | null",
      "avatarValue":     "string | null",
      "selectedBadgeSlug":"string | null",
      "createdAt":       "ISO8601",
      "updatedAt":       "ISO8601"
    }
  Errors: 404

---

PUT /api/admin/users/:id/role
  Auth: Bearer <accessToken> (admin role required)
  Body:
    { "role": "user | admin" }
  Response: { "message": "User role changed to admin" }
  Errors: 404

---

DELETE /api/admin/users/:id
  Auth: Bearer <accessToken> (admin role required)
  Response: { "message": "User deleted" }
  Notes: cascades to user_stats, user_answers, review_schedule, refresh_tokens,
         user_badges, user_category_stats.

================================================================================
SUBSCRIPTIONS /api/subscriptions
================================================================================

Tiers:
  0 = Free     (3 categories, $0)
  1 = $10.99   (10 categories)
  2 = $50.99   (all categories)

Tier is stored on both users.tier and categories.tier.
  - Free user sees categories WHERE tier = 0
  - Tier 1 user sees categories WHERE tier <= 1
  - Tier 2 user sees all categories
  - Create session validates user.tier >= category.tier

GET /api/subscriptions/plans
   Auth: none
   Response 200:
     [
       {
         "plan":          "free",
         "name":          "Free",
         "tier":          0,
         "priceUSD":      0,
         "categoryLimit": null
       },
       {
         "plan":          "premium_10",
         "name":          "$10.99",
         "tier":          1,
         "priceUSD":      14.99,
         "categoryLimit": 10
       },
       {
         "plan":          "premium_all",
         "name":          "RM50",
         "tier":          2,
         "priceUSD":      50,
         "categoryLimit": null
       }
     ]

---

POST /api/subscriptions/checkout
   Auth: Bearer <accessToken>
   Body:
     { "plan": "premium_10 | premium_all" }
   Response 200:
     { "paymentUrl": "https://checkout.stripe.com/...", "sessionId": "cs_..." }
   Errors: 400 (invalid plan or already at that tier), 500 (Stripe not configured)
   Notes: creates a subscription_transactions row with status='pending'.
          Stripe Checkout redirects user to payment page.
          After payment, Stripe calls the webhook below.

---

POST /api/subscriptions/webhook
   Auth: none (called by Stripe)
   Header: stripe-signature: <signature>
   Body: raw Stripe event JSON
   On checkout.session.completed:
     → Updates subscription_transactions.status = 'paid'
     → Updates users.tier to the purchased tier
     → Both in a single ACID transaction (COMMIT/ROLLBACK)
   Errors: 400 (invalid signature)

================================================================================
HEALTH
================================================================================

GET /health
  Auth: none
  Response 200:
    { "status": "ok", "timestamp": "ISO8601" }

================================================================================
GENERAL NOTES
================================================================================

- Access tokens expire after 15 minutes.
- Refresh tokens expire after 7 days (stored hashed in refresh_tokens table).
- Verification/reset tokens expire after 3 minutes.
- All authenticated endpoints require: Authorization: Bearer <accessToken>
- Emails (forgot-password, verify-email, change-email) sent via nodemailer + Mailtrap SMTP.
- Admin endpoints additionally require role = "admin".
- Rate limiting applies to: login (5/15min), register (3/15min),
  forgot-password (3/15min), refresh (10/min), verify-email (5/15min),
  send-verification (3/15min). Exceeded → 429 with Retry-After header.
- Login streaks are tracked: consecutive daily logins increment the streak.
  Missing a day resets to 1. Streaks are visible via GET /api/stats.
- Public endpoints never expose correct answers.
- Categories use PostgreSQL ltree for hierarchical paths.
- Question type is locked in DB once an answer exists (enforced by trigger).

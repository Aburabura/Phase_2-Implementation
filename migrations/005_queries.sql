-- 003_queries_examples.sql
-- Purpose: Example queries for your project

-- =========================
-- READ (SELECT) — 3 examples
-- =========================

-- READ #1: List tickets with user, category, and priority
SELECT
  t.ticket_id,
  t.title,
  t.status,
  u.full_name AS submitted_by,
  c.name AS category,
  p.name AS priority,
  t.created_at
FROM ticket t
JOIN app_user u ON u.user_id = t.user_id
JOIN category c ON c.category_id = t.category_id
JOIN priority p ON p.priority_id = t.priority_id
ORDER BY t.created_at DESC;

-- READ #2: Show agent workload (number of currently assigned tickets)
-- "Currently assigned" means latest assignment row with unassigned_at IS NULL (simplified)
SELECT
  a.agent_id,
  a.full_name,
  COUNT(*) AS active_assignments
FROM ticket_assignment_history ah
JOIN agent a ON a.agent_id = ah.agent_id
WHERE ah.unassigned_at IS NULL
GROUP BY a.agent_id, a.full_name
ORDER BY active_assignments DESC;

-- READ #3: Find tickets that are likely SLA risks (older than response target by priority)
SELECT
  t.ticket_id,
  t.title,
  p.name AS priority,
  t.created_at,
  sp.target_response_hrs,
  (NOW() - t.created_at) AS age
FROM ticket t
JOIN priority p ON p.priority_id = t.priority_id
JOIN sla_policy sp ON sp.priority_id = p.priority_id
WHERE t.status IN ('Open', 'In Progress')
  AND NOW() > t.created_at + (sp.target_response_hrs || ' hours')::INTERVAL
ORDER BY t.created_at ASC;


-- =========================
-- UPDATE — 3 examples
-- =========================

-- UPDATE #1: Update a ticket status to "In Progress"
UPDATE ticket
SET status = 'In Progress',
    updated_at = NOW()
WHERE ticket_id = 1;

-- UPDATE #2: Escalate a ticket priority (Medium -> High)
UPDATE ticket
SET priority_id = (SELECT priority_id FROM priority WHERE name = 'High'),
    updated_at = NOW()
WHERE ticket_id = 2;

-- UPDATE #3: Resolve a ticket (must set resolved_at due to CHECK constraint)
UPDATE ticket
SET status = 'Resolved',
    resolved_at = NOW(),
    updated_at = NOW()
WHERE ticket_id = 3;


-- =========================
-- DELETE — 3 examples
-- =========================
-- NOTE: In real systems, deletes are often replaced with "soft delete" (is_deleted flag).
-- For class requirements, here are real DELETE examples wrapped in a transaction and rolled back.

BEGIN;

-- DELETE #1: Delete a single comment (example cleanup)
DELETE FROM ticket_comment
WHERE comment_id = 1;

-- DELETE #2: Delete an assignment history row (example: mistaken assignment entry)
DELETE FROM ticket_assignment_history
WHERE assignment_id = 1;

-- DELETE #3: Delete a ticket (cascades to comments + assignments due to ON DELETE CASCADE)
DELETE FROM ticket
WHERE ticket_id = 1;

-- Roll back so the database isn't permanently changed by demo deletes
ROLLBACK;

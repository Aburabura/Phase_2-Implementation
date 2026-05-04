-- 002_insert_data.sql
-- Purpose: Insert sample data (seed data)

-- Users submitting tickets
INSERT INTO app_user (full_name, email, department) VALUES
('Ava Chen', 'ava.chen@csuf.edu', 'Finance'),
('Miguel Torres', 'miguel.torres@csuf.edu', 'Facilities'),
('Sana Patel', 'sana.patel@csuf.edu', 'Admissions');

-- Support agents
INSERT INTO agent (full_name, email, hired_at) VALUES
('Jordan Lee', 'jordan.lee@helpdesk.com', '2024-08-15'),
('Riley Nguyen', 'riley.nguyen@helpdesk.com', '2023-01-10'),
('Casey Kim', 'casey.kim@helpdesk.com', '2022-05-01');

-- Categories (lookup)
INSERT INTO category (name) VALUES
('Network'),
('Hardware'),
('Software');

-- Priorities (lookup)
INSERT INTO priority (name, rank) VALUES
('Low', 1),
('Medium', 2),
('High', 3);

-- SLA policy per priority
INSERT INTO sla_policy (priority_id, target_response_hrs, target_resolution_hrs)
SELECT priority_id,
       CASE name WHEN 'Low' THEN 24 WHEN 'Medium' THEN 8 ELSE 1 END AS target_response_hrs,
       CASE name WHEN 'Low' THEN 120 WHEN 'Medium' THEN 48 ELSE 12 END AS target_resolution_hrs
FROM priority;

-- Tickets
-- Note: resolved_at must be NULL unless status is Resolved/Closed (enforced by CHECK constraint)
INSERT INTO ticket (user_id, category_id, priority_id, title, description, status)
VALUES
(1, 1, 3, 'Wi-Fi drops every 5 minutes', 'Laptop disconnects from campus Wi-Fi repeatedly.', 'Open'),
(2, 2, 2, 'Printer jam in Building A', 'Office printer jams and shows error code E13.', 'In Progress'),
(3, 3, 1, 'Need software install: Zoom', 'Requesting Zoom installation on staff workstation.', 'Open');

-- Assignment history (3+ rows)
INSERT INTO ticket_assignment_history (ticket_id, agent_id, assigned_at) VALUES
(1, 2, NOW() - INTERVAL '2 hours'),
(2, 1, NOW() - INTERVAL '1 day'),
(3, 3, NOW() - INTERVAL '3 hours');

-- Ticket comments (3+ rows)
INSERT INTO ticket_comment (ticket_id, author_type, author_id, body) VALUES
(1, 'USER', 1, 'It happens most often near the library.'),
(2, 'AGENT', 1, 'I will check the printer rollers and paper tray.'),
(3, 'USER', 3, 'This is needed before tomorrow’s meeting.');

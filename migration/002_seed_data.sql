-- 002_insert_data.sql
-- Purpose: Insert sample data (seed data)

-- Patient information
INSERT INTO "PATIENT" (first_name, last_name, email, phone) VALUES
('Ava', 'Chen', 'ava.chen@csuf.edu', '4113032244'),
('Miguel', 'Torres', 'miguel.torres@csuf.edu', '4130234425'),
('Sana' ,'Patel', 'sana.patel@csuf.edu', '6086558923'),
('Josh' ,'Williams', 'Josh.Williams@csuf.edu', '7234082234'),
('Hero' ,'Brine', 'Hero.Brine@csuf.edu', '6688230238');

-- Staff information
INSERT INTO "STAFF" (first_name, last_name, email, phone, role) VALUES
('Jordan', 'Lee', 'jordan.lee@medical.com', '7423089243', 'Doctor'),
('Riley', 'Nguyen', 'riley.nguyen@medical.com', '4435230062', 'Receptionist'),
('Mike', 'Phelps', 'mike.phelps@admin.com', '4432278693', 'Administrator'),
('Johnny', 'Phage', 'Johnny.Phage@medical.com', '6088829263', 'Doctor'),
('Casey', 'Kim', 'casey.kim@helpdesk.com', '8726730287', 'Doctor');

-- Service
INSERT INTO "SERVICE" (service_name, service_cost) VALUES
('Anesthesia eyelid', 103.00),
('Electrodes 2x2', 272.00),
('Needle Stimiyplex ultra 20x6', 360.00),
('Collar cervical med', 278.00),
('Dressing telfa', 270.00);

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

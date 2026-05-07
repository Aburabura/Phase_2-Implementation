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

-- Appointment
INSERT INTO "APPOINTMENT" (patient_id, staff_id, appointment_date, appointment_time, appointment_status) VALUES
(1, 1, '2024-03-15', '09:00:00', 'Complete'),
(2, 1, '2026-07-15', '10:00:00', 'Pending'),
(3, 2, '2026-09-16', '14:00:00', 'Pending'),
(1, 1, '2024-03-17', '17:00:00', 'Complete'),
(2, 1, '2027-06-19', '15:00:00', 'Pending');

-- Medical Record
INSERT INTO "MEDICAL_RECORD" (patient_id, appointment_id, visit_notes, diagnosis, admission_date, discharge_date) VALUES
(1, 1, 'Patient reports mild eye irritation and sensitivity to light. Administered anesthesia eyelid procedure successfully.', 'Blepharitis', '2024-03-15', '2024-03-15'),
(2, 2, 'Patient experiencing chronic neck pain following a minor vehicular accident. Cervical collar fitted and nerve stimulation therapy initiated.', 'Cervical Radiculopathy', '2026-07-15', '2026-07-15'),
(3, 3, 'Patient presented with minor laceration on forearm. Wound cleaned and dressed with telfa dressing. No signs of infection.', 'Superficial Laceration', '2026-09-16', '2026-09-16'),
(1, 4, 'Follow-up visit for blepharitis. Electrodes applied for therapeutic stimulation. Patient reports improvement in symptoms.', 'Blepharitis - Follow-up', '2024-03-17', '2024-03-17'),
(2, 5, 'Follow-up for cervical radiculopathy. Needle stimulation therapy performed. Patient reports moderate reduction in pain levels.', 'Cervical Radiculopathy - Follow-up', '2027-06-19', '2027-06-19');

-- Appointment Service
INSERT INTO "APPOINTMENT_SERVICE" (appointment_id, service_id) VALUES
(1, 1),
(2, 4),
(3, 5),
(4, 2),
(5, 3);

-- Invoices
INSERT INTO "INVOICE" (appointment_id, total_amount) VALUES
(1, 103.00),
(2, 278.00),
(3, 270.00),
(4, 272.00),
(5, 360.00);

-- Payment information
INSERT INTO "PAYMENT" (invoice_id, payment_amount, payment_date) VALUES
(1, 103.00, '2024-03-15'),
(2, 278.00, '2026-07-15'),
(3, 270.00, '2026-09-16'),
(4, 272.00, '2024-03-17'),
(5, 360.00, '2027-06-19'); 
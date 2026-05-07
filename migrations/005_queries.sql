-- VIEW: Summary of appointments with patient + staff info
CREATE OR REPLACE VIEW "Appointment_Summary" AS
SELECT 
a."appointment_id",
p."first_name" || ' ' || p."last_name" AS patient_name,
s."first_name" || ' ' || s."last_name" AS staff_name,
a."appointment_date",
a."appointment_time",
a."appointment_status"
FROM "APPOINTMENT" a
JOIN "PATIENT" p ON a."patient_id" = p."patient_id"
JOIN "STAFF" s ON a."staff_id" = s."staff_id";

-- TRIGGER FUNCTION: Prevent negative payments
CREATE OR REPLACE FUNCTION prevent_negative_payment()
RETURNS TRIGGER AS $$
BEGIN
IF NEW."payment_amount" < 0 THEN
RAISE EXCEPTION 'Payment amount cannot be negative';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER: Runs before inserting payment
CREATE TRIGGER check_payment_amount
BEFORE INSERT ON "PAYMENT"
FOR EACH ROW
EXECUTE FUNCTION prevent_negative_payment();

-- READ: Show all appointments with patient + staff
SELECT * FROM "Appointment_Summary";

-- READ: Show invoices with patient names
SELECT i."invoice_id", p."first_name", p."last_name", i."total_amount"
FROM "INVOICE" i
JOIN "APPOINTMENT" a ON i."appointment_id" = a."appointment_id"
JOIN "PATIENT" p ON a."patient_id" = p."patient_id";

-- READ: Show services used per appointment
SELECT a."appointment_id", s."service_name"
FROM "APPOINTMENT_SERVICE" aps
JOIN "SERVICE" s ON aps."service_id" = s."service_id"
JOIN "APPOINTMENT" a ON aps."appointment_id" = a."appointment_id";

-- READ: Show payments with invoice totals
SELECT pay."payment_id", pay."payment_amount", i."total_amount"
FROM "PAYMENT" pay
JOIN "INVOICE" i ON pay."invoice_id" = i."invoice_id";

-- READ: Show medical records with patient names
SELECT mr."record_id", p."first_name", p."last_name", mr."diagnosis"
FROM "MEDICAL_RECORD" mr
JOIN "PATIENT" p ON mr."patient_id" = p."patient_id";

-- READ: Show all completed appointments
SELECT *
FROM "APPOINTMENT"
WHERE "appointment_status" = 'Complete';

-- UPDATE: Update patient phone number
UPDATE "PATIENT"
SET "phone" = '1111111111'
WHERE "patient_id" = 1;

-- UPDATE: Change appointment status to Complete
UPDATE "APPOINTMENT"
SET "appointment_status" = 'Complete'
WHERE "appointment_id" = 1;

-- UPDATE: Update staff role
UPDATE "STAFF"
SET "role" = 'Doctor'
WHERE "staff_id" = 2;

-- UPDATE: Update service cost
UPDATE "SERVICE"
SET "service_cost" = 120.00
WHERE "service_id" = 1;

-- UPDATE: Update invoice total
UPDATE "INVOICE"
SET "total_amount" = 500.00
WHERE "invoice_id" = 1;

-- UPDATE: Update medical record diagnosis
UPDATE "MEDICAL_RECORD"
SET "diagnosis" = 'Updated Diagnosis'
WHERE "record_id" = 1;

-- DELETE: Remove a payment
DELETE FROM "PAYMENT"
WHERE "payment_id" = 1;

-- DELETE: Remove a service from appointment
DELETE FROM "APPOINTMENT_SERVICE"
WHERE "appointment_id" = 1 AND "service_id" = 1;

-- DELETE: Remove an invoice
DELETE FROM "INVOICE"
WHERE "invoice_id" = 1;

-- DELETE: Remove a medical record
DELETE FROM "MEDICAL_RECORD"
WHERE "record_id" = 1;

-- DELETE: Remove a patient with no appointments
DELETE FROM "PATIENT"
WHERE email = 'Hero.Brine@csuf.edu'
  AND patient_id NOT IN (
    SELECT DISTINCT patient_id FROM "APPOINTMENT"
);

-- DELETE: Remove all cancelled appointments
DELETE FROM "PAYMENT"
WHERE invoice_id IN (
    SELECT invoice_id FROM "INVOICE"
    WHERE appointment_id IN (
        SELECT appointment_id FROM "APPOINTMENT"
        WHERE appointment_status = 'Cancelled'
    )
);

DELETE FROM "INVOICE"
WHERE appointment_id IN (
    SELECT appointment_id FROM "APPOINTMENT"
    WHERE appointment_status = 'Cancelled'
);

DELETE FROM "APPOINTMENT_SERVICE"
WHERE appointment_id IN (
    SELECT appointment_id FROM "APPOINTMENT"
    WHERE appointment_status = 'Cancelled'
);

DELETE FROM "MEDICAL_RECORD"
WHERE appointment_id IN (
    SELECT appointment_id FROM "APPOINTMENT"
    WHERE appointment_status = 'Cancelled'
);

DELETE FROM "APPOINTMENT"
WHERE appointment_status = 'Cancelled';

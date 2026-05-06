-- ======================================================================================
-- VIEW 1: appointment dashboard - flat view of every pending appointment
-- ======================================================================================

CREATE OR REPLACE VIEW vw_active_appointment_dashboard AS
SELECT
    a.appointment_id,
    a.appointment_date,
    a.appointment_time,
    a.appointment_status,
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    p.email AS patient_email,
    p.phone AS patient_phone,
    s.staff_id,
    s.first_name || ' ' || s.last_name AS staff_name,
    s.role AS staff_role,
    sv.service_name,
    sv.service_cost,

    ROUND(
        EXTRACT(EPOCH FROM (a.appointment_date + a.appointment_time - NOW())) / 3600, 2
    ) AS hours_until_appointment
    FROM "APPOINTMENT" a
    JOIN "PATIENT" p ON p.patient_id = a.patient_id 
    JOIN "STAFF" s ON s.staff_id = a.staff_id
    LEFT JOIN "APPOINTMENT_SERVICE" aps ON aps.appointment_id = a.appointment_id
    LEFT JOIN "SERVICE" sv ON sv.service_id = aps.service_id
    WHERE a.appointment_status = 'Pending'
    ORDER BY a.appointment_date ASC, a.appointment_time ASC;
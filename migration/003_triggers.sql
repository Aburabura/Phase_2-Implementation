-- ===================================================================================
-- TRIGGER 1: Prevent booking an appointment with a staff member who already
--            has an appointment at the same date/time
-- ===================================================================================
-- Ensure no two appointment are schedules for the same staff at the same time

CREATE OR REPLACE FUNCTION fn_block_double_booking()
RETURN TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    v_conflict INT;
BEGIN
    SELECT COUNT(*) INTO v_conflict
    FROM "APPOINTMENT"
    WHERE staff_id = NEW.staff_id
    AND appointment_date = NEW.appointment_date
    AND appointment_time = NEW.appointment_time
    AND appointment_id != COALESCE(NEW.appointment_id, -1);

    IF v_conflict > 0 THEN
        RAISE EXCEPTION
        'Staff member (staff_id = %) already has an appointment on % at %.',
        NEW.staff_id, NEW.appointment_date, NEW.appointment_time;
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER trg_block_double_booking
    BEFORE INSERT OR UPDATE ON "APPOINTMENT"
    FOR EACH ROW
    EXECUTE FUNCTION fn_block_double_booking();
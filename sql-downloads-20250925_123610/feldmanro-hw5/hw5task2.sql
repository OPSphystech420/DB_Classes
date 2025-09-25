CREATE OR REPLACE FUNCTION serial_generator(start_val_inc INTEGER, last_val_ex INTEGER) 
RETURNS TABLE (serial_generator INTEGER) 
AS $$
BEGIN
    FOR i IN start_val_inc..(last_val_ex - 1) LOOP
        serial_generator := i;
        RETURN NEXT;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
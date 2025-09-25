CREATE OR REPLACE FUNCTION count_non_volatile_days(full_nm TEXT) RETURNS INTEGER
AS $$
DECLARE
    non_volatile_count INTEGER;
    crypto_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM coins WHERE coins.full_nm = count_non_volatile_days.full_nm
    ) INTO crypto_exists;

    IF NOT crypto_exists THEN
        RAISE EXCEPTION 'Crypto currency with name "%" is absent in database!', full_nm
            USING ERRCODE = '02000';
    END IF;

    SELECT COUNT(*)
    INTO non_volatile_count
    FROM coins
    WHERE coins.full_nm = count_non_volatile_days.full_nm
    AND open_price = high_price
    AND high_price = low_price
    AND low_price = close_price;

    RETURN non_volatile_count;
END;
$$ LANGUAGE plpgsql;
CREATE SEQUENCE event_id_seq START 1;

CREATE OR REPLACE FUNCTION insert_auction_payload()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    new_event_id INTEGER;
    auctioneer_json JSONB;
    attachment_json JSONB;
    bet_json JSONB;
BEGIN
    new_event_id := nextval('event_id_seq');

    auctioneer_json := (NEW.payload::JSONB)->'auctioneer';
    attachment_json := (NEW.payload::JSONB)->'attachment';
    bet_json := (NEW.payload::JSONB)->'bet';

    INSERT INTO auctioneer (event_id, firstname, lastname, nickname, email)
    VALUES (
        new_event_id,
        auctioneer_json->>'firstname',
        auctioneer_json->>'lastname',
        auctioneer_json->>'nickname',
        auctioneer_json->>'email'
    );

    INSERT INTO attachment (event_id, filename, datacenter, localname)
    VALUES (
        new_event_id,
        attachment_json->>'filename',
        (attachment_json->'location')->>'datacenter',
        (attachment_json->'location')->>'localname'
    );

    INSERT INTO bet (event_id, volume, ts)
    VALUES (
        new_event_id,
        (bet_json->>'volume')::NUMERIC,
        to_timestamp((bet_json->>'ts')::BIGINT)
    );

    RETURN NEW;
END;
$$;

CREATE TRIGGER trigger_insert_auction_payload
INSTEAD OF INSERT ON v_auction_payload
FOR EACH ROW
EXECUTE FUNCTION insert_auction_payload();
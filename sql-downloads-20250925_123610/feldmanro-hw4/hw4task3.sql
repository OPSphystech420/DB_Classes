CREATE OR REPLACE VIEW v_first_level_partition_info AS
SELECT 
    pn.nspname AS parent_schema,
    pc.relname AS parent_table,
    cn.nspname AS child_schema,
    cc.relname AS child_table
FROM pg_inherits i
JOIN pg_class pc ON i.inhparent = pc.oid
JOIN pg_namespace pn ON pc.relnamespace = pn.oid
JOIN pg_class cc ON i.inhrelid = cc.oid
JOIN pg_namespace cn ON cc.relnamespace = cn.oid
WHERE pc.relkind = 'p';
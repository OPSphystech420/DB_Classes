CREATE OR REPLACE VIEW v_rec_level_partition_info AS
WITH RECURSIVE partition_hierarchy AS (
    SELECT 
        pn.nspname AS parent_schema,
        pc.relname AS parent_table,
        cn.nspname AS child_schema,
        cc.relname AS child_table,
        1 AS part_level
    FROM pg_catalog.pg_inherits i
    JOIN pg_catalog.pg_class pc ON i.inhparent = pc.oid
    JOIN pg_catalog.pg_namespace pn ON pc.relnamespace = pn.oid
    JOIN pg_catalog.pg_class cc ON i.inhrelid = cc.oid
    JOIN pg_catalog.pg_namespace cn ON cc.relnamespace = cn.oid
    WHERE pc.relkind = 'p'
    UNION ALL
    SELECT 
        ph.parent_schema,
        ph.parent_table,
        cn.nspname AS child_schema,
        cc.relname AS child_table,
        ph.part_level + 1
    FROM partition_hierarchy ph
    JOIN pg_catalog.pg_inherits i ON i.inhparent = (
        SELECT c.oid 
        FROM pg_catalog.pg_class c 
        JOIN pg_catalog.pg_namespace n ON c.relnamespace = n.oid 
        WHERE n.nspname = ph.child_schema AND c.relname = ph.child_table
    )
    JOIN pg_catalog.pg_class cc ON i.inhrelid = cc.oid
    JOIN pg_catalog.pg_namespace cn ON cc.relnamespace = cn.oid
)
SELECT 
    parent_schema,
    parent_table,
    child_schema,
    child_table,
    part_level
FROM partition_hierarchy;

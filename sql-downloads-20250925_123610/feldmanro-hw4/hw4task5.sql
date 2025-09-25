CREATE OR REPLACE VIEW v_used_size_per_user (
    table_owner,
    schema_name,
    table_name,
    table_size,
    used_per_schema_user_total_size,
    used_user_total_size
) AS
WITH table_sizes AS (
    SELECT
        r.rolname AS table_owner,
        n.nspname AS schema_name,
        c.relname AS table_name,
        pg_relation_size(c.oid) AS table_size_bytes
    FROM pg_catalog.pg_class c
    JOIN pg_catalog.pg_namespace n ON n.oid   = c.relnamespace
    JOIN pg_catalog.pg_roles     r ON r.oid   = c.relowner
    WHERE c.relkind = 'r'
),
schema_user_sizes AS (
    SELECT
        table_owner,
        schema_name,
        SUM(table_size_bytes) AS schema_size_bytes
    FROM table_sizes
    GROUP BY table_owner, schema_name
),
user_total_sizes AS (
    SELECT
        table_owner,
        SUM(table_size_bytes) AS user_size_bytes
    FROM table_sizes
    GROUP BY table_owner
)
SELECT
    ts.table_owner,
    ts.schema_name,
    ts.table_name,
    pg_size_pretty(ts.table_size_bytes) AS table_size,
    pg_size_pretty(sus.schema_size_bytes) AS used_per_schema_user_total_size,
    pg_size_pretty(uts.user_size_bytes) AS used_user_total_size
FROM table_sizes ts
JOIN schema_user_sizes sus
  ON ts.table_owner = sus.table_owner
 AND ts.schema_name = sus.schema_name
JOIN user_total_sizes uts
  ON ts.table_owner = uts.table_owner;
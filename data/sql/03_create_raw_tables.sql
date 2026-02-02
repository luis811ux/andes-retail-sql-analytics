-- =====================================================================
-- File:        03_create_raw_tables.sql
-- Project:     Andes Retail - SQL Analytics
-- Description: Creates RAW tables to store unprocessed sales data
--              from CSV files (January–March 2025).
--              Data is loaded manually using DBeaver import.
-- Schema:      raw
-- Database:    PostgreSQL
-- =====================================================================


/*----------------------------------------------------------------------
 RAW TABLE TEMPLATE
 NOTE:
 - All columns are TEXT to reflect raw, unclean source data
 - No constraints are applied at this stage
----------------------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS raw.ventas_2025_01_raw (
    fecha_venta      TEXT,
    ciudad           TEXT,
    tienda           TEXT,
    vendedor         TEXT,
    cliente          TEXT,
    producto         TEXT,
    categoria        TEXT,
    cantidad         TEXT,
    precio_unitario  TEXT,
    costo_unitario   TEXT
);


/*----------------------------------------------------------------------
 RAW TABLES FOR ADDITIONAL MONTHS (STRUCTURE CLONE)
----------------------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS raw.ventas_2025_02_raw
(LIKE raw.ventas_2025_01_raw INCLUDING ALL);

CREATE TABLE IF NOT EXISTS raw.ventas_2025_03_raw
(LIKE raw.ventas_2025_01_raw INCLUDING ALL);


/*----------------------------------------------------------------------
 METADATA VALIDATION
----------------------------------------------------------------------*/
-- List RAW tables created
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'raw'
ORDER BY table_name;


/*----------------------------------------------------------------------
 DATA LOAD (MANUAL - DBeaver)
----------------------------------------------------------------------*/
-- Data is loaded using DBeaver:
-- 1. Right click table → Import Data
-- 2. Select source file (CSV)
-- 3. Encoding: UTF-8
-- 4. Delimiter: comma (,)
-- 5. Enable:
--    - Truncate target table before load
--    - Use transactions
--    - Use bulk load
--    - Multi-row insert (500)
-- 6. Validate preview and execute import


/*----------------------------------------------------------------------
 DATA VALIDATION - JANUARY 2025
----------------------------------------------------------------------*/
SELECT COUNT(*) AS total_records
FROM raw.ventas_2025_01_raw;

SELECT *
FROM raw.ventas_2025_01_raw
LIMIT 10;


/*----------------------------------------------------------------------
 DATA VALIDATION - FEBRUARY 2025
----------------------------------------------------------------------*/
SELECT COUNT(*) AS total_records
FROM raw.ventas_2025_02_raw;

SELECT *
FROM raw.ventas_2025_02_raw
LIMIT 10;


/*----------------------------------------------------------------------
 DATA VALIDATION - MARCH 2025
----------------------------------------------------------------------*/
SELECT COUNT(*) AS total_records
FROM raw.ventas_2025_03_raw;

SELECT *
FROM raw.ventas_2025_03_raw
LIMIT 10;


/*----------------------------------------------------------------------
 STRUCTURE INSPECTION (OPTIONAL)
----------------------------------------------------------------------*/
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'ventas_2025_01_raw'
ORDER BY ordinal_position;

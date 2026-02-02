-- =====================================================================
-- File:        04_stg_ventas_2025.sql
-- Project:     Andes Retail - SQL Analytics
-- Description: Creates the STAGING sales table and consolidates monthly
--              RAW sales data (CSV-based) into a cleaned, standardized,
--              and typed structure ready for analytics.
--              Applies trimming, case normalization, type casting,
--              and UNION ALL consolidation.
-- Source:      raw.ventas_2025_01_raw
--              raw.ventas_2025_02_raw
--              raw.ventas_2025_03_raw
-- Period:      January – March 2025
-- Schema:      stg
-- Database:    PostgreSQL
-- =====================================================================


-- ------------------------------------------------------
-- 1. Create STAGING schema
-- ------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS stg;


-- ------------------------------------------------------
-- 2. Drop staging table if it already exists
-- ------------------------------------------------------
DROP TABLE IF EXISTS stg.ventas_2025;


-- ------------------------------------------------------
-- 3. Create consolidated STAGING sales table
-- ------------------------------------------------------
CREATE TABLE stg.ventas_2025 (
    id_venta         SERIAL PRIMARY KEY,
    fecha_venta      DATE,
    ciudad           VARCHAR(50),
    tienda           VARCHAR(100),
    vendedor         VARCHAR(100),
    cliente          VARCHAR(100),
    producto         VARCHAR(150),
    categoria        VARCHAR(50),
    cantidad         INTEGER,
    precio_unitario  NUMERIC(14,2),
    costo_unitario   NUMERIC(14,2)
);


-- ------------------------------------------------------
-- 4. Validate STAGING table structure
-- ------------------------------------------------------
SELECT
    column_name
FROM information_schema.columns
WHERE table_schema = 'stg'
  AND table_name   = 'ventas_2025'
ORDER BY ordinal_position;


-- ======================================================
-- 5. ETL PROCESS: RAW → STAGING
-- ======================================================
-- Applied transformations:
-- - Date parsing
-- - Text normalization (UPPER, INITCAP, LOWER)
-- - Removal of non-numeric characters
-- - Casting to analytical data types
-- ======================================================

INSERT INTO stg.ventas_2025 (
    fecha_venta,
    ciudad,
    tienda,
    vendedor,
    cliente,
    producto,
    categoria,
    cantidad,
    precio_unitario,
    costo_unitario
)

-- -----------------------
-- January 2025
-- -----------------------
SELECT
    TO_DATE(TRIM(fecha_venta), 'YYYY-MM-DD')                    AS fecha_venta,
    UPPER(TRIM(ciudad))                                         AS ciudad,
    UPPER(TRIM(tienda))                                         AS tienda,
    INITCAP(TRIM(vendedor))                                     AS vendedor,
    TRIM(cliente)                                               AS cliente,
    INITCAP(TRIM(producto))                                     AS producto,
    LOWER(TRIM(categoria))                                      AS categoria,
    CAST(REGEXP_REPLACE(TRIM(cantidad), '[^0-9]', '', 'g')
         AS INTEGER)                                            AS cantidad,
    CAST(REGEXP_REPLACE(TRIM(precio_unitario), '[^0-9]', '', 'g')
         AS NUMERIC(14,2))                                      AS precio_unitario,
    CAST(REGEXP_REPLACE(TRIM(costo_unitario), '[^0-9]', '', 'g')
         AS NUMERIC(14,2))                                      AS costo_unitario
FROM raw.ventas_2025_01_raw

UNION ALL

-- -----------------------
-- February 2025
-- -----------------------
SELECT
    TO_DATE(TRIM(fecha_venta), 'YYYY-MM-DD'),
    UPPER(TRIM(ciudad)),
    UPPER(TRIM(tienda)),
    INITCAP(TRIM(vendedor)),
    TRIM(cliente),
    INITCAP(TRIM(producto)),
    LOWER(TRIM(categoria)),
    CAST(REGEXP_REPLACE(TRIM(cantidad), '[^0-9]', '', 'g') AS INTEGER),
    CAST(REGEXP_REPLACE(TRIM(precio_unitario), '[^0-9]', '', 'g') AS NUMERIC(14,2)),
    CAST(REGEXP_REPLACE(TRIM(costo_unitario), '[^0-9]', '', 'g') AS NUMERIC(14,2))
FROM raw.ventas_2025_02_raw

UNION ALL

-- -----------------------
-- March 2025
-- -----------------------
SELECT
    TO_DATE(TRIM(fecha_venta), 'YYYY-MM-DD'),
    UPPER(TRIM(ciudad)),
    UPPER(TRIM(tienda)),
    INITCAP(TRIM(vendedor)),
    TRIM(cliente),
    INITCAP(TRIM(producto)),
    LOWER(TRIM(categoria)),
    CAST(REGEXP_REPLACE(TRIM(cantidad), '[^0-9]', '', 'g') AS INTEGER),
    CAST(REGEXP_REPLACE(TRIM(precio_unitario), '[^0-9]', '', 'g') AS NUMERIC(14,2)),
    CAST(REGEXP_REPLACE(TRIM(costo_unitario), '[^0-9]', '', 'g') AS NUMERIC(14,2))
FROM raw.ventas_2025_03_raw;


-- ======================================================
-- 6. Data Quality Checks (QA)
-- ======================================================

-- Global summary and monthly distribution
SELECT
    COUNT(*)                                                   AS total_records,
    MIN(fecha_venta)                                           AS min_date,
    MAX(fecha_venta)                                           AS max_date,
    COUNT(*) FILTER (WHERE fecha_venta >= '2025-01-01'
                  AND fecha_venta <  '2025-02-01')             AS january,
    COUNT(*) FILTER (WHERE fecha_venta >= '2025-02-01'
                  AND fecha_venta <  '2025-03-01')             AS february,
    COUNT(*) FILTER (WHERE fecha_venta >= '2025-03-01'
                  AND fecha_venta <  '2025-04-01')             AS march
FROM stg.ventas_2025;


-- Sample data from STAGING
SELECT *
FROM stg.ventas_2025;


-- QA: invalid or inconsistent values
SELECT *
FROM stg.ventas_2025
WHERE
    cantidad <= 0
    OR precio_unitario <= 0
    OR costo_unitario <= 0;

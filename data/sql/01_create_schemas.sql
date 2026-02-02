-- =====================================================================
-- File:        01_create_schemas.sql
-- Project:     Andes Retail - SQL Analytics
-- Description: Creates database schemas to organize data by layer:
--              raw  -> raw data ingestion
--              stg  -> staging / transformation layer
--              dim  -> dimension tables
--              fact -> fact tables for analytics and metrics
-- Database:    PostgreSQL
-- =====================================================================

-- ---------------------------------------------------------------------
-- Create schemas if they do not already exist
-- ---------------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS stg;
CREATE SCHEMA IF NOT EXISTS dim;
CREATE SCHEMA IF NOT EXISTS fact;

-- ---------------------------------------------------------------------
-- Verify schema creation
-- ---------------------------------------------------------------------
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('raw', 'stg', 'dim', 'fact')
ORDER BY schema_name;

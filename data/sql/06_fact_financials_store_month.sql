-- =====================================================================
-- File:        06_fact_finanzas_tienda_mes.sql
-- Project:     Andes Retail - SQL Analytics
-- Description: Creates a monthly store-level financial view aggregating
--              sales and profitability metrics to support executive
--              dashboards and profitability analysis.
-- Grain:       One row per store, per city, per month
-- Source:      fact.ventas_2025
-- Metrics:     - Absolute values (sales, costs, profits)
--              - Weighted profitability margins
-- Period:      January – March 2025
-- Schema:      fact
-- Database:    PostgreSQL
-- =====================================================================


-- ------------------------------------------------------
-- 1. Create store-month financial view
-- ------------------------------------------------------
CREATE OR REPLACE VIEW fact.finanzas_tienda_mes AS
SELECT
    periodo,
    ciudad,
    tienda,

    -- -----------------------------
    -- Absolute financial metrics
    -- -----------------------------
    SUM(venta_bruta)              AS venta_total,
    SUM(ganancia_bruta)           AS ganancia_bruta,
    SUM(costo_fijo_prorrateado)   AS costos_fijos,
    SUM(ganancia_operativa)       AS ganancia_operativa,
    SUM(ganancia_neta)            AS ganancia_neta,

    -- -----------------------------
    -- Weighted profitability margins
    -- -----------------------------
    ROUND(
        SUM(ganancia_bruta)
        / NULLIF(SUM(venta_bruta), 0),
        4
    ) AS margen_bruto,

    ROUND(
        SUM(ganancia_operativa)
        / NULLIF(SUM(venta_bruta), 0),
        4
    ) AS margen_operativo,

    ROUND(
        SUM(ganancia_neta)
        / NULLIF(SUM(venta_bruta), 0),
        4
    ) AS margen_neto

FROM fact.ventas_2025
GROUP BY
    periodo,
    ciudad,
    tienda;


-- ------------------------------------------------------
-- 2. Validate financial view
-- ------------------------------------------------------
SELECT *
FROM fact.finanzas_tienda_mes;

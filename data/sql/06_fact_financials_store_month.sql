-- ======================================================
--        FACT LAYER – STORE MONTHLY FINANCIALS
-- ======================================================
-- Purpose:
-- Provide aggregated financial metrics at store-month level
-- to support profitability analysis and executive dashboards.
--
-- Grain:
-- One row per store, per city, per month
--
-- Source:
-- fact.ventas_2025
--
-- Metrics:
-- - Absolute values (sales, costs, profits)
-- - Weighted profitability margins
-- ======================================================


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

-- =====================================================================
-- File:        07_fact_kpis.sql
-- Project:     Andes Retail - SQL Analytics
-- Description: Defines executive-level financial, commercial, and
--              operational KPI views at monthly level, based on the
--              transactional fact table.
--              Includes safeguards against division by zero and
--              standardized KPI calculation conventions.
-- Source:      fact.ventas_2025
-- Metrics:     - Absolute monetary KPIs
--              - Percentage-based KPIs
-- Grain:       Monthly aggregation
-- Period:      January – March 2025
-- Schema:      fact
-- Database:    PostgreSQL
-- =====================================================================


-- =============================================================================
-- KPI 1: AVERAGE TICKET PER STORE AND MONTH
-- =============================================================================
CREATE OR REPLACE VIEW fact.kpi_average_ticket AS
SELECT
    periodo,
    ciudad,
    tienda,

    COUNT(DISTINCT venta_id) AS num_transactions,
    SUM(venta_bruta)         AS total_sales,

    ROUND(
        SUM(venta_bruta) /
        NULLIF(COUNT(DISTINCT venta_id), 0),
        2
    ) AS average_ticket

FROM fact.ventas_2025
GROUP BY periodo, ciudad, tienda;



-- =============================================================================
-- KPI 2: SALES REP PRODUCTIVITY
-- =============================================================================
CREATE OR REPLACE VIEW fact.kpi_sales_rep_productivity AS
SELECT
    periodo,
    vendedor,
    ciudad,
    tienda,

    COUNT(DISTINCT venta_id) AS num_sales,
    SUM(cantidad)            AS units_sold,

    ROUND(SUM(venta_bruta), 2)    AS total_sales,
    ROUND(SUM(ganancia_bruta), 2) AS gross_profit,
    ROUND(SUM(ganancia_neta), 2)  AS net_profit,

    ROUND(
        SUM(venta_bruta) /
        NULLIF(COUNT(DISTINCT venta_id), 0),
        2
    ) AS average_ticket_rep,

    ROUND(
        SUM(ganancia_neta) /
        NULLIF(SUM(venta_bruta), 0) * 100,
        2
    ) AS net_margin_pct

FROM fact.ventas_2025
GROUP BY periodo, vendedor, ciudad, tienda;



-- =============================================================================
-- KPI 3: TOP PROFITABLE PRODUCTS
-- =============================================================================
CREATE OR REPLACE VIEW fact.kpi_top_profitable_products AS
SELECT
    periodo,
    producto,
    categoria,

    SUM(cantidad)            AS units_sold,
    COUNT(DISTINCT venta_id) AS num_transactions,

    ROUND(SUM(venta_bruta), 2)  AS total_sales,
    ROUND(SUM(costo_compra), 2) AS total_cost,
    ROUND(SUM(ganancia_bruta), 2) AS gross_profit,
    ROUND(SUM(ganancia_neta), 2)  AS net_profit,

    ROUND(
        SUM(ganancia_neta) /
        NULLIF(SUM(venta_bruta), 0) * 100,
        2
    ) AS net_margin_pct,

    ROUND(
        SUM(ganancia_bruta) /
        NULLIF(SUM(venta_bruta), 0) * 100,
        2
    ) AS gross_margin_pct,

    ROUND(
        SUM(ganancia_neta) /
        NULLIF(SUM(cantidad), 0),
        2
    ) AS net_profit_per_unit,

    ROUND(
        SUM(ganancia_neta) * 100.0 /
        SUM(SUM(ganancia_neta)) OVER (PARTITION BY periodo),
        2
    ) AS profit_contribution_pct

FROM fact.ventas_2025
GROUP BY periodo, producto, categoria;



-- =============================================================================
-- KPI 4: MONTH-OVER-MONTH GROWTH (MoM)
-- =============================================================================
CREATE OR REPLACE VIEW fact.kpi_monthly_growth_mom AS
WITH monthly_metrics AS (
    SELECT
        periodo,
        ciudad,
        tienda,
        COUNT(DISTINCT venta_id) AS num_transactions,
        SUM(venta_bruta)         AS total_sales,
        SUM(ganancia_neta)       AS net_profit,
        ROUND(
            SUM(venta_bruta) /
            NULLIF(COUNT(DISTINCT venta_id), 0),
            2
        ) AS average_ticket
    FROM fact.ventas_2025
    GROUP BY periodo, ciudad, tienda
)
SELECT
    periodo,
    ciudad,
    tienda,

    total_sales,
    net_profit,
    num_transactions,
    average_ticket,

    ROUND(
        (total_sales - LAG(total_sales) OVER w) /
        NULLIF(LAG(total_sales) OVER w, 0) * 100,
        2
    ) AS sales_growth_pct,

    ROUND(
        (net_profit - LAG(net_profit) OVER w) /
        NULLIF(LAG(net_profit) OVER w, 0) * 100,
        2
    ) AS profit_growth_pct

FROM monthly_metrics
WINDOW w AS (PARTITION BY ciudad, tienda ORDER BY periodo);



-- =============================================================================
-- KPI 5: CATEGORY CONTRIBUTION
-- =============================================================================
CREATE OR REPLACE VIEW fact.kpi_category_contribution AS
SELECT
    periodo,
    categoria,

    SUM(venta_bruta)   AS total_sales,
    SUM(ganancia_neta) AS net_profit,

    ROUND(
        SUM(venta_bruta) * 100.0 /
        SUM(SUM(venta_bruta)) OVER (PARTITION BY periodo),
        2
    ) AS sales_contribution_pct,

    ROUND(
        SUM(ganancia_neta) * 100.0 /
        SUM(SUM(ganancia_neta)) OVER (PARTITION BY periodo),
        2
    ) AS profit_contribution_pct,

    ROUND(
        SUM(ganancia_neta) /
        NULLIF(SUM(venta_bruta), 0) * 100,
        2
    ) AS net_margin_pct

FROM fact.ventas_2025
GROUP BY periodo, categoria;



-- =============================================================================
-- KPI 6: ROI BY STORE
-- =============================================================================
CREATE OR REPLACE VIEW fact.kpi_roi_store AS
SELECT
    periodo,
    ciudad,
    tienda,

    SUM(costo_compra + costo_fijo_prorrateado) AS total_investment,
    SUM(ganancia_neta)                         AS net_profit,

    ROUND(
        SUM(ganancia_neta) /
        NULLIF(SUM(costo_compra + costo_fijo_prorrateado), 0) * 100,
        2
    ) AS roi_pct

FROM fact.ventas_2025
GROUP BY periodo, ciudad, tienda;



-- =============================================================================
-- KPI 7: BREAK-EVEN POINT BY STORE
-- =============================================================================
CREATE OR REPLACE VIEW fact.kpi_break_even AS
SELECT
    periodo,
    ciudad,
    tienda,

    SUM(venta_bruta)            AS actual_sales,
    SUM(costo_compra)           AS variable_cost,
    SUM(costo_fijo_prorrateado) AS fixed_cost,

    ROUND(
        SUM(costo_fijo_prorrateado) /
        NULLIF(
            (SUM(venta_bruta) - SUM(costo_compra)) /
            NULLIF(SUM(venta_bruta), 0),
            0
        ),
        2
    ) AS break_even_sales

FROM fact.ventas_2025
GROUP BY periodo, ciudad, tienda;



-- =============================================================================
-- KPI 8: OPERATIONAL EFFICIENCY SCORECARD BY STORE
-- =============================================================================
CREATE OR REPLACE VIEW fact.kpi_operational_efficiency AS
SELECT
    periodo,
    ciudad,
    tienda,

    SUM(venta_bruta)   AS total_sales,
    SUM(ganancia_neta) AS net_profit,

    ROUND(
        SUM(ganancia_neta) /
        NULLIF(SUM(venta_bruta), 0) * 100,
        2
    ) AS net_margin_pct,

    ROUND(
        SUM(ganancia_neta) /
        NULLIF(SUM(costo_compra + costo_fijo_prorrateado), 0) * 100,
        2
    ) AS roi_pct

FROM fact.ventas_2025
GROUP BY periodo, ciudad, tienda;

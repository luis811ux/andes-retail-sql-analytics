-- ======================================================
--        FACT LAYER – SALES WITH FINANCIAL METRICS
-- ======================================================
-- Purpose:
-- Final analytical fact table containing sales transactions
-- enriched with financial calculations for business KPIs.
--
-- Grain:
-- One row per sale (transaction level)
--
-- Source:
-- stg.ventas_2025
--
-- Period:
-- January – March 2025
-- ======================================================


-- ------------------------------------------------------
-- 1. Create FACT sales table
-- ------------------------------------------------------
CREATE TABLE fact.ventas_2025 (
    venta_id                SERIAL PRIMARY KEY,
    fecha_venta             DATE NOT NULL,
    periodo                 DATE NOT NULL,
    ciudad                  VARCHAR(50) NOT NULL,
    tienda                  VARCHAR(50) NOT NULL,
    vendedor                VARCHAR(100),
    cliente                 VARCHAR(100),
    producto                VARCHAR(100),
    categoria               VARCHAR(50),
    cantidad                INTEGER NOT NULL,
    precio_unitario         NUMERIC(16,2) NOT NULL,
    costo_unitario          NUMERIC(16,2) NOT NULL,
    venta_bruta             NUMERIC(16,2),
    costo_compra            NUMERIC(16,2),
    ganancia_bruta          NUMERIC(16,2),
    costo_fijo_prorrateado  NUMERIC(16,2),
    ganancia_operativa      NUMERIC(16,2),
    impuesto                NUMERIC(16,2),
    ganancia_neta           NUMERIC(16,2)
);


-- ------------------------------------------------------
-- 2. Load base transactional data from STAGING
-- ------------------------------------------------------
INSERT INTO fact.ventas_2025 (
    fecha_venta,
    periodo,
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
SELECT
    fecha_venta,
    DATE_TRUNC('month', fecha_venta)::DATE  AS periodo,
    ciudad,
    tienda,
    vendedor,
    cliente,
    producto,
    categoria,
    cantidad,
    precio_unitario,
    costo_unitario
FROM stg.ventas_2025;


-- Validate initial load
SELECT *
FROM fact.ventas_2025;


-- ======================================================
-- 3. Financial calculations
-- ======================================================

-- Gross sales amount
UPDATE fact.ventas_2025
SET venta_bruta = cantidad * precio_unitario;


-- Purchase cost
UPDATE fact.ventas_2025
SET costo_compra = cantidad * costo_unitario;


-- Gross profit
UPDATE fact.ventas_2025
SET ganancia_bruta = venta_bruta - costo_compra;


-- Validate calculated fields
SELECT *
FROM fact.ventas_2025;


-- ======================================================
-- 4. Supporting view for fixed cost allocation
-- ======================================================

DROP VIEW IF EXISTS fact.vw_ganancia_bruta_tienda_mes;

-- Gross profit by store and month
CREATE OR REPLACE VIEW fact.vw_ganancia_bruta_tienda_mes AS
SELECT
    periodo,
    ciudad,
    tienda,
    SUM(ganancia_bruta) AS ganancia_bruta_total_tienda_mes
FROM fact.ventas_2025
GROUP BY
    periodo,
    ciudad,
    tienda;


-- Validate view
SELECT *
FROM fact.vw_ganancia_bruta_tienda_mes;


-- ======================================================
-- 5. Fixed cost allocation per transaction
-- ======================================================
-- Allocation logic:
-- Each sale receives a proportional share of the monthly
-- fixed cost based on its contribution to gross profit.
-- ======================================================

UPDATE fact.ventas_2025 f
SET costo_fijo_prorrateado =
    (f.ganancia_bruta / v.ganancia_bruta_total_tienda_mes)
    * c.costo_fijo_total
FROM fact.vw_ganancia_bruta_tienda_mes v
JOIN dim.costos_fijos_2025 c
    ON c.ciudad  = v.ciudad
   AND c.tienda = v.tienda
   AND c.periodo = v.periodo
WHERE
    f.ciudad  = v.ciudad
AND f.tienda = v.tienda
AND f.periodo = v.periodo;


-- ======================================================
-- 6. Operating profit, tax, and net profit
-- ======================================================

-- Operating profit
UPDATE fact.ventas_2025
SET ganancia_operativa = ganancia_bruta - costo_fijo_prorrateado;


-- Tax calculation (only if operating profit is positive)
UPDATE fact.ventas_2025
SET impuesto = CASE
    WHEN ganancia_operativa > 0 THEN ganancia_operativa * 0.19
    ELSE 0
END;


-- Net profit
UPDATE fact.ventas_2025
SET ganancia_neta = ganancia_operativa - impuesto;

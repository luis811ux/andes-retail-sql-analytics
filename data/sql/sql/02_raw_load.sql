-- =====================================================================
-- File:        02_create_dimensions.sql
-- Project:     Andes Retail - SQL Analytics
-- Description: Creates dimension tables and loads master data
-- Schema:      dim
-- Database:    PostgreSQL
-- =====================================================================

/*----------------------------------------------------------------------
 DIMENSION: STORES (TIENDAS)
----------------------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS dim.dim_tiendas (
    tienda_id       SERIAL PRIMARY KEY,
    ciudad          VARCHAR(50) NOT NULL,
    pais            VARCHAR(50) NOT NULL,
    region          VARCHAR(50) NOT NULL,
    fecha_apertura  DATE
);

INSERT INTO dim.dim_tiendas (ciudad, pais, region, fecha_apertura)
VALUES
    ('Bogotá',        'Colombia', 'Centro',     '2018-03-15'),
    ('Medellín',      'Colombia', 'Antioquia',  '2019-07-10'),
    ('Cali',          'Colombia', 'Valle',      '2020-01-20'),
    ('Barranquilla',  'Colombia', 'Caribe',     '2021-05-05'),
    ('Neiva',         'Colombia', 'Sur',        '2022-09-12');

-- Validation
SELECT * FROM dim.dim_tiendas ORDER BY tienda_id;


/*----------------------------------------------------------------------
 DIMENSION: PRODUCTS (PRODUCTOS)
----------------------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS dim.dim_productos (
    producto_id     SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    categoria       VARCHAR(50) NOT NULL,
    costo_compra    NUMERIC(10,2) NOT NULL,
    precio_venta    NUMERIC(10,2) NOT NULL,
    activo           BOOLEAN DEFAULT TRUE
);

INSERT INTO dim.dim_productos
(nombre_producto, categoria, costo_compra, precio_venta)
VALUES
    ('Arroz Premium 1kg',        'Alimentos',  2800,  4200),
    ('Aceite Vegetal 1L',        'Alimentos',  6500,  9200),
    ('Café Molido 500g',         'Bebidas',    7800, 11500),
    ('Detergente Líquido 2L',    'Aseo',      10200, 15800),
    ('Papel Higiénico x12',      'Aseo',       8900, 13900),
    ('Galletas Integrales',      'Snacks',     3200,  5200),
    ('Bebida Energética 500ml',  'Bebidas',    4100,  6900);

-- Validation
SELECT * FROM dim.dim_productos ORDER BY producto_id;


/*----------------------------------------------------------------------
 DIMENSION: CUSTOMERS (CLIENTES)
----------------------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS dim.dim_clientes (
    cliente_id      SERIAL PRIMARY KEY,
    nombre_cliente  VARCHAR(100) NOT NULL,
    tipo_cliente    VARCHAR(30) NOT NULL,
    genero          VARCHAR(20),
    fecha_registro  DATE NOT NULL,
    ciudad          VARCHAR(50)
);

INSERT INTO dim.dim_clientes
(nombre_cliente, tipo_cliente, genero, fecha_registro, ciudad)
VALUES
    ('Carlos Pérez',      'Retail',     'Masculino', '2023-01-10', 'Bogotá'),
    ('María Gómez',       'Retail',     'Femenino',  '2023-03-22', 'Medellín'),
    ('Distribuciones JJ', 'Mayorista',  NULL,        '2022-11-05', 'Cali'),
    ('Laura Martínez',    'Online',     'Femenino',  '2024-02-14', 'Barranquilla'),
    ('Comercial Neiva',   'Mayorista',  NULL,        '2021-08-30', 'Neiva'),
    ('Juan Rodríguez',    'Retail',     'Masculino', '2024-06-18', 'Bogotá'),
    ('Ana Torres',        'Online',     'Femenino',  '2024-09-02', 'Cali');

-- Validation
SELECT * FROM dim.dim_clientes ORDER BY cliente_id;


/*----------------------------------------------------------------------
 DIMENSION: SALES REPRESENTATIVES (VENDEDORES)
----------------------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS dim.dim_vendedores (
    vendedor_id     SERIAL PRIMARY KEY,
    nombre_vendedor VARCHAR(100) NOT NULL,
    ciudad          VARCHAR(50) NOT NULL,
    fecha_ingreso   DATE NOT NULL,
    activo          BOOLEAN DEFAULT TRUE
);

INSERT INTO dim.dim_vendedores
(nombre_vendedor, ciudad, fecha_ingreso)
VALUES
    ('Pedro Salazar',    'Bogotá',       '2020-02-15'),
    ('Lucía Fernández',  'Bogotá',       '2021-06-01'),
    ('Andrés Muñoz',     'Medellín',     '2019-09-20'),
    ('Paola Restrepo',   'Medellín',     '2022-01-10'),
    ('Jorge Castillo',   'Cali',          '2020-11-05'),
    ('Diana Ríos',       'Barranquilla', '2021-08-18'),
    ('Camilo Pineda',    'Neiva',         '2023-03-25');

-- Validation
SELECT * FROM dim.dim_vendedores ORDER BY vendedor_id;


/*----------------------------------------------------------------------
 DIMENSION: FIXED COSTS (COSTOS FIJOS)
 NOTE: Simplified dimension for analytical use
----------------------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS dim.costos_fijos_2025 (
    ciudad            VARCHAR(50) NOT NULL,
    tienda            VARCHAR(50) NOT NULL,
    periodo           DATE NOT NULL,
    costo_fijo_total  NUMERIC(14,2) NOT NULL,
    CONSTRAINT uq_costos_fijos UNIQUE (ciudad, tienda, periodo)
);

INSERT INTO dim.costos_fijos_2025 (ciudad, tienda, periodo, costo_fijo_total)
VALUES
    ('BARRANQUILLA', 'TIENDA ESTE',   '2025-01-01', 28842000.00),
    ('BOGOTA',       'TIENDA CENTRO', '2025-01-01', 23616000.00),
    ('CALI',         'TIENDA NORTE',  '2025-01-01', 27801800.00),
    ('MEDELLIN',     'TIENDA SUR',    '2025-01-01',  7434000.00),
    ('BARRANQUILLA', 'TIENDA ESTE',   '2025-02-01',  1597200.00),
    ('BOGOTA',       'TIENDA CENTRO', '2025-02-01', 24904800.00),
    ('CALI',         'TIENDA NORTE',  '2025-02-01', 14613200.00),
    ('MEDELLIN',     'TIENDA SUR',    '2025-02-01',  3780000.00),
    ('BARRANQUILLA', 'TIENDA ESTE',   '2025-03-01',  1782000.00),
    ('BOGOTA',       'TIENDA CENTRO', '2025-03-01', 15366240.00),
    ('CALI',         'TIENDA NORTE',  '2025-03-01',  9649200.00),
    ('MEDELLIN',     'TIENDA SUR',    '2025-03-01',  3323600.00);

-- Validation
SELECT * FROM dim.costos_fijos_2025
ORDER BY periodo, ciudad;

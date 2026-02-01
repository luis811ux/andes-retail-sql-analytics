# 🛒 Andes Retail - Análisis de Ventas con SQL

![PostgreSQL](https://img.shields.io/badge/PostgreSQL_17-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![DBeaver](https://img.shields.io/badge/DBeaver_25.3.3-382923?style=for-the-badge&logo=dbeaver&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)

## 📋 Sobre el Proyecto

Este proyecto representa un análisis completo de ventas para **Andes Retail**, una empresa ficticia que opera tiendas físicas en cuatro ciudades principales de Colombia (Bogotá, Medellín, Cali y Barranquilla), especializadas en productos de tecnología.

Desarrollé este proyecto como parte de mi portafolio profesional para demostrar competencias en:
- Diseño y modelado de bases de datos relacionales
- Procesos ETL (Extract, Transform, Load) con SQL
- Cálculo de métricas financieras y KPIs de negocio
- Análisis de desempeño comercial y diagnóstico de problemas operativos

El análisis cubre el primer trimestre de 2025 (enero - marzo), procesando datos desde su estado crudo hasta métricas ejecutivas accionables.

---

## 🎯 Objetivos del Proyecto

### Objetivos Técnicos:
✅ Implementar un pipeline ETL completo usando únicamente SQL  
✅ Diseñar una arquitectura de datos escalable con capas (raw → staging → fact)  
✅ Crear dimensiones y tablas de hechos siguiendo mejores prácticas  
✅ Desarrollar 8 KPIs financieros clave para análisis de negocio  

### Objetivos de Negocio:
📊 Analizar el desempeño de ventas por tienda, ciudad y periodo  
💰 Calcular métricas de rentabilidad (márgenes bruto, operativo y neto)  
📈 Identificar tendencias y patrones de crecimiento/decrecimiento  
🎯 Evaluar eficiencia operativa y retorno de inversión por tienda  
⚠️ Diagnosticar problemas críticos de performance del negocio  

---

## 🏗️ Arquitectura de Datos

El proyecto implementa una arquitectura de datos en capas diseñada para separar responsabilidades y facilitar el mantenimiento:

### Schemas Implementados:

```
📦 andes_retail_db
│
├── 📂 raw/              → Datos crudos sin procesar
│   ├── ventas_2025_01_raw
│   ├── ventas_2025_02_raw
│   └── ventas_2025_03_raw
│
├── 📂 stg/              → Staging (datos normalizados)
│   └── ventas_2025
│
├── 📂 dim/              → Dimensiones y catálogos
│   ├── dim_tiendas
│   ├── dim_productos
│   ├── dim_clientes
│   ├── dim_vendedores
│   └── costos_fijos_2025
│
└── 📂 fact/             → Tablas de hechos y KPIs
    ├── ventas_2025
    ├── finanzas_tienda_mes
    └── 8 vistas de KPIs
```

### Esquemas, tablas y vistas:
<img width="250" height="170" alt="12" src="https://github.com/user-attachments/assets/6506fe4e-f666-40cd-bcbb-03b178ffa00c" />
<img width="250" height="155" alt="16" src="https://github.com/user-attachments/assets/04147916-ea1f-4068-b358-eb44abb7e280" />
<img width="250" height="156" alt="14" src="https://github.com/user-attachments/assets/67a661d8-e5cb-406e-8414-8dd1bc57dd3d" />
<img width="248" height="295" alt="15" src="https://github.com/user-attachments/assets/370eb9d6-39be-4ee8-808a-b7dd033b171a" />


### Flujo de Datos (Pipeline ETL):

```
CSV Files (Raw Data)
        ↓
   [EXTRACT]
        ↓
  raw.ventas_YYYY_MM_raw (3 tablas mensuales)
        ↓
  [TRANSFORM]
   • Normalización de texto (UPPER, TRIM, INITCAP)
   • Limpieza de formatos numéricos con REGEXP_REPLACE
   • Conversión de tipos de datos
   • Extracción de periodo (DATE_TRUNC)
        ↓
  stg.ventas_2025 (Tabla consolidada normalizada)
        ↓
   [LOAD + ENRICH]
   • Cálculo de métricas financieras:
     - Venta bruta = cantidad × precio_unitario
     - Costo compra = cantidad × costo_unitario
     - Ganancia bruta = venta_bruta - costo_compra
     - Costo fijo prorrateado (según ganancia bruta)
     - Ganancia operativa = ganancia_bruta - costo_fijo
     - Impuesto = ganancia_operativa × 19%
     - Ganancia neta = ganancia_operativa - impuesto
        ↓
  fact.ventas_2025 (Tabla de hechos principal)
        ↓
   [ANALYTICS]
   • Window Functions (LAG, RANK, PARTITION BY)
   • Agregaciones complejas
   • CTEs para análisis temporal
        ↓
  8 Vistas de KPIs + Vista consolidada financiera
```
### Tabla de metricas finacieras:
<img width="525" height="186" alt="22" src="https://github.com/user-attachments/assets/7dbe0d14-738f-4ef2-a46d-80400fc2f1d0" />
<img width="576" height="187" alt="19" src="https://github.com/user-attachments/assets/46eff118-f8b4-4aa0-ad08-41315cfe9233" />
<img width="801" height="183" alt="20" src="https://github.com/user-attachments/assets/4e91c37e-d135-4a0c-9566-c5ffdb0e6296" />

---

## 🛠️ Tecnologías Utilizadas

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **PostgreSQL** | 17 | Sistema de gestión de base de datos relacional |
| **DBeaver** | 25.3.3 | IDE para desarrollo y administración de SQL |
| **SQL** | ANSI SQL | Lenguaje para consultas y transformaciones |

**Características SQL utilizadas:**
- ✅ Common Table Expressions (CTEs) - Para consultas modulares y legibles
- ✅ Window Functions (LAG, RANK, PARTITION BY) - Análisis temporal y rankings
- ✅ Agregaciones complejas con NULLIF - Prevención de errores de división por cero
- ✅ JOINs múltiples - Cruce de tablas de hechos con dimensiones
- ✅ Subconsultas correlacionadas - Cálculos contextuales
- ✅ Funciones de texto (UPPER, TRIM, INITCAP, REGEXP_REPLACE) - Limpieza de datos
- ✅ Funciones de fecha (TO_DATE, DATE_TRUNC, EXTRACT) - Manipulación temporal

---

## 📊 KPIs Desarrollados

Desarrollé 8 indicadores clave de desempeño que cubren diferentes aspectos del negocio:

### 1. 💵 Ticket Promedio
**Métrica:** Valor promedio de venta por transacción  
**Fórmula:** `Venta Total / Número de Transacciones`  
**Vista:** `fact.kpi_ticket_promedio`  
**Uso:** Identificar tiendas con clientes de mayor valor y evaluar estrategias de upselling

### 2. 👥 Productividad por Vendedor
**Métricas:** Ventas totales, ganancia generada, transacciones cerradas, ticket promedio  
**Vista:** `fact.kpi_productividad_vendedor`  
**Uso:** Evaluar desempeño individual, identificar top performers, calcular comisiones

### 3. 🏆 Top Productos Más Rentables
**Métricas:** Ganancia neta, margen neto, contribución al total, unidades vendidas  
**Vista:** `fact.kpi_top_productos`  
**Uso:** Optimizar inventario, identificar productos estrella vs bajo rendimiento

### 4. 📈 Crecimiento MoM (Month over Month)
**Métrica:** Variación porcentual mes a mes de ventas y ganancias  
**Fórmula:** `((Mes Actual - Mes Anterior) / Mes Anterior) × 100`  
**Vista:** `fact.kpi_crecimiento_mom`  
**Uso:** Identificar tendencias, evaluar estrategias comerciales, detectar problemas

### 5. 🎯 Contribución por Categoría
**Métricas:** % de ventas y ganancias por categoría, margen por categoría  
**Vista:** `fact.kpi_contribucion_categoria`  
**Uso:** Decisiones estratégicas sobre portfolio de productos

### 6. 💰 ROI por Tienda
**Métrica:** Retorno sobre inversión  
**Fórmula:** `(Ganancia Neta / Inversión Total) × 100`  
**Vista:** `fact.kpi_roi_tienda`  
**Uso:** Evaluar eficiencia financiera, comparar performance entre tiendas

### 7. ⚖️ Punto de Equilibrio
**Métrica:** Ventas mínimas necesarias para cubrir costos  
**Fórmula:** `Costos Fijos / Margen de Contribución %`  
**Vista:** `fact.kpi_punto_equilibrio`  
**Uso:** Planificación de metas, análisis de riesgo, evaluación de viabilidad

### 8. ⭐ Eficiencia Operativa (Score 0-100)
**Métrica:** Calificación consolidada ponderando ROI (30%), Margen Neto (25%), Ratio Venta/Inversión (20%), Eficiencia Costo Fijo (15%), Peso Costo Fijo (10%)  
**Vista:** `fact.kpi_eficiencia_operativa`  
**Uso:** Comparación ejecutiva entre tiendas, ranking de performance, identificación de áreas críticas

### Ranking de performance entre tiendas:
<img width="593" height="216" alt="23" src="https://github.com/user-attachments/assets/7f7fa496-70ac-49dd-9253-8819649ec064" />
<img width="720" height="216" alt="24" src="https://github.com/user-attachments/assets/d83db95c-5c3d-4d41-acaf-99db20711d8c" />
<img width="857" height="217" alt="25" src="https://github.com/user-attachments/assets/cec24af4-df9a-4347-b7e1-8e91d2894b21" />




---

## 📖 Storytelling: El Desempeño de Andes Retail en Q1 2025

### 🎬 Contexto del Negocio

Andes Retail es una cadena especializada en productos de tecnología que opera en cuatro ciudades colombianas estratégicas. Al analizar el primer trimestre de 2025, el objetivo era evaluar la salud financiera del negocio y responder preguntas críticas:

- ¿Qué tiendas están generando más valor?
- ¿Los márgenes son sostenibles?
- ¿Estamos creciendo o enfrentamos problemas?
- ¿Dónde debemos intervenir urgentemente?

**Lo que descubrí fue una situación que requiere atención inmediata.**

---

### 📊 Hallazgos Principales

#### 💼 Performance Global Q1 2025

**Ventas y Rentabilidad:**
- **Venta Total Q1:** $485.7 millones COP
- **Ganancia Neta Total:** $58.5 millones COP
- **Margen Neto Promedio:** 12.04%
- **ROI Promedio:** 14.31%
- **Total Transacciones:** 24 ventas
- **Ticket Promedio:** $20.2 millones COP

**Análisis:**  
Si bien el margen neto del 12% puede parecer razonable, el ROI del 14.31% está por debajo de estándares saludables para retail tecnológico (objetivo: >30%). El ticket promedio extremadamente alto ($20.2M) indica un modelo de ventas de alto valor pero bajo volumen, con solo 24 transacciones en todo el trimestre.

### Metricas financieras:
<img width="460" height="214" alt="26" src="https://github.com/user-attachments/assets/3f38116a-48ec-4a5f-8660-cdf04e23c1af" />
<img width="686" height="214" alt="28" src="https://github.com/user-attachments/assets/3b6c4974-1f55-4022-85ac-ae80e14bc4ad" />

---

#### ⚠️ HALLAZGO CRÍTICO: Decrecimiento Severo en Febrero

**El análisis temporal revela una caída alarmante:**

| Tienda | Enero | Febrero | Caída % | Marzo | Tendencia |
|--------|-------|---------|---------|-------|-----------|
| **BARRANQUILLA - TIENDA ESTE** | $89.7M | $4.8M | **-94.64%** | $6.5M | 📉 Colapso |
| **MEDELLIN - TIENDA SUR** | $21.5M | $10.3M | **-52.09%** | $8.9M | 📉 Declive |
| **CALI - TIENDA NORTE** | $83.8M | $41.1M | **-50.99%** | $35.9M | 📉 Declive |
| **BOGOTA - TIENDA CENTRO** | $67.0M | $71.5M | **+6.67%** | $44.8M | ⚠️ Única estable en Feb, cae en Mar |

**Impacto en Ganancias:**
- **Barranquilla:** De $12M a $666K (-94.46%)
- **Medellín:** De $2.6M a $1.3M (-49.15%)
- **Cali:** De $10.6M a $5.6M (-47.44%)
- **Bogotá:** Único crecimiento Feb: +5.46%, pero cae -38.3% en Marzo

### Decrecimiento Mensual:
<img width="484" height="216" alt="29" src="https://github.com/user-attachments/assets/1281c256-4cf8-45f5-9cb3-ef9f00475c39" />
<img width="595" height="217" alt="30" src="https://github.com/user-attachments/assets/08e5ec98-ed16-488f-b5b8-f1e9d2f7be89" />
<img width="720" height="215" alt="31" src="https://github.com/user-attachments/assets/710a00bb-d62f-4be6-9776-7abd0d4b72de" />



**Hipótesis del Decrecimiento:**
1. **Estacionalidad post-temporada alta:** Enero pudo ser excepcional (fin de año/regalos corporativos), con normalización en Feb-Mar
2. **Problemas de inventario:** Desabastecimiento de productos clave en febrero
3. **Factores externos:** Cambios en el mercado, competencia, economía local
4. **Datos de muestra:** Al ser datos de ejercicio, podría reflejar volumen bajo de transacciones (24 total)

**Recomendación inmediata:**  
Investigar causas raíz del colapso de Barranquilla (-95%) y Medellín/Cali (-50%). Priorizar estabilización antes de expansión.

---

#### 🏆 Tiendas: Eficiencia Operativa

**Todas las tiendas presentan clasificación "Deficiente" (score 26-33 de 100):**

| Ranking | Tienda | Ciudad | Score | ROI | Margen Neto | Estado |
|---------|--------|--------|-------|-----|-------------|--------|
| 1º | TIENDA ESTE | Barranquilla | 32.73 | 16.72% | 13.86% | ⚠️ Deficiente (mejor Ene) |
| 2º | TIENDA NORTE | Cali | 31.41 | 16.30% | 13.57% | ⚠️ Deficiente (Ene) |
| ... | ... | ... | 26-33 | 11-17% | 10-14% | ⚠️ Todas deficientes |

**Análisis:**  
Ninguna tienda alcanza umbrales de eficiencia óptima (score >65). Los componentes que más penalizan el score son:
- **ROI bajo (11-17% vs objetivo 60%):** Alta inversión, baja rentabilidad
- **Peso de costos fijos (28-34% de ventas):** Estructura operativa muy pesada
- **Margen neto moderado (10-14%):** Presión en precios o costos altos

**Interpretación:**  
El modelo de negocio actual tiene margen de mejora significativo en todas las dimensiones. No hay tiendas "estrella" que sirvan de benchmark interno. Esto sugiere problemas sistémicos más que específicos de ubicación.

### Score de Deficiencia:
<img width="843" height="215" alt="32" src="https://github.com/user-attachments/assets/29f6ac18-854f-4b1e-aa4d-ffde43e88edc" />
<img width="822" height="41" alt="33" src="https://github.com/user-attachments/assets/d7e17371-c9be-47d2-a460-b51cfb3326f5" />

---

#### 💡 Punto de Equilibrio: Margen de Seguridad Moderado

**Todas las tiendas operan rentablemente, pero con margen limitado:**

| Tienda | Venta Necesaria (Break-Even) | Venta Real Promedio | Margen Seguridad | Estado |
|--------|------------------------------|---------------------|------------------|--------|
| **Barranquilla** | $22.2M/mes | $33.7M/mes | 34% | ✅ Rentable, margen aceptable |
| **Cali** | $36.4M/mes | $53.6M/mes | 32% | ✅ Rentable, margen aceptable |
| **Medellín** | $9.5M/mes | $13.6M/mes | 30% | ✅ Rentable, margen justo |
| **Bogotá** | $44.0M/mes | $61.1M/mes | 28% | ✅ Rentable, margen más ajustado |

**Interpretación:**  
El margen de seguridad del 28-34% significa que las ventas pueden caer hasta ese porcentaje antes de entrar en pérdidas. Considerando la caída real de Feb-Mar (-50% a -95%), varias tiendas estuvieron cerca o por debajo del equilibrio en esos meses.

**Implicación:**  
El colchón financiero es insuficiente para volatilidad alta. Se necesita aumentar margen de seguridad a >40% mediante:
- Incremento de márgenes (mejores precios o menores costos)
- Reducción de costos fijos (optimización operativa)
- Diversificación de ingresos (más categorías/productos)

---

#### 🎯 Productos: Concentración Extrema en "Laptop Pro 15"

**Top 5 Productos Más Rentables (Q1 2025):**

| Producto | Ganancia Neta | Venta Total | Margen Neto | Contribución |
|----------|---------------|-------------|-------------|--------------|
| **Laptop Pro 15** | $34.4M | $290.9M | 11.37% | **58.83%** |
| Monitor 27 Pulgadas | $10.0M | $79.1M | 12.60% | 17.04% |
| Monitor 27 | $5.1M | $40.9M | 12.43% | 8.73% |
| Tablet 10 | $4.1M | $36.0M | 11.28% | 7.09% |
| Teclado Mecánico | $1.3M | $10.0M | 12.84% | 2.20% |

**RIESGO CRÍTICO:**  
El 58.83% de las ganancias totales provienen de un solo producto. Esta concentración extrema crea vulnerabilidad:
- ✗ Desabastecimiento de Laptop Pro 15 = colapso de ganancias
- ✗ Obsolescencia del modelo = pérdida de competitividad
- ✗ Entrada de competidores = presión en márgenes

**Oportunidad:**  
Los monitores tienen margen neto superior (12.4-12.6% vs 11.4% del laptop). Impulsar su venta podría mejorar rentabilidad global.

### Top 10 productos mas vendidos:
<img width="726" height="185" alt="34" src="https://github.com/user-attachments/assets/59cf13b1-02dc-4e32-91aa-e31cb7938e49" />
<img width="794" height="185" alt="35" src="https://github.com/user-attachments/assets/e46bfc5d-faad-4f04-b7b2-ffce8762935f" />

---

#### 📦 Categorías: Portafolio Monoproducto

**Contribución por Categoría:**

| Categoría | Venta Total | Ganancia Neta | Contribución Ventas | Contribución Ganancias | Margen Neto |
|-----------|-------------|---------------|---------------------|------------------------|-------------|
| **Tecnología** | $485.7M | $58.5M | 100% | 100% | 11.79% |

**Análisis:**  
El negocio depende 100% de tecnología. No hay diversificación en otras categorías (oficina, accesorios, servicios). Esto limita:
- Oportunidades de cross-selling
- Estabilidad ante cambios en demanda tecnológica
- Márgenes (categorías complementarias suelen tener mejor margen)

**Recomendación:**  
Expandir a categorías adyacentes: suministros de oficina, mobiliario ergonómico, servicios de soporte técnico.

---

#### 👥 Vendedores: Productividad Desigual

**Top 3 Vendedores Más Productivos (Q1 2025):**

| Vendedor | Ciudad | Venta Total | Ganancia Neta | Transacciones | Ticket Promedio | Margen |
|----------|--------|-------------|---------------|---------------|-----------------|--------|
| **Juan Perez** | Bogotá | $160.8M | $17.6M | 3 | $53.6M | 10.91% |
| **Luis Ramirez** | Cali | $104.1M | $13.0M | 3 | $34.7M | 12.47% |
| **Diego Rios** | Barranquilla | $73.3M | $9.7M | 3 | $24.4M | 12.39% |

**Análisis:**  
- **Volumen:** Juan Perez duplica al #3 en ventas
- **Eficiencia:** Luis y Diego tienen mejor margen (12.4% vs 10.9%)
- **Tickets altos:** Todos manejan ventas corporativas/empresariales (promedio $24-54M)

**Hallazgo:**  
Solo hay datos de vendedores top. Falta visibilidad del equipo completo para evaluar distribución de productividad y necesidades de capacitación.

---

## 💡 Insights Clave y Recomendaciones

### ✅ Fortalezas Identificadas

#### 1. **Modelo de Alto Valor por Transacción**
- Ticket promedio de $20.2M indica ventas B2B o corporativas
- Menor volumen de transacciones pero mayor valor unitario
- **Ventaja:** Menor costo de adquisición de clientes por peso vendido

#### 2. **Operación por Encima del Punto de Equilibrio**
- Todas las tiendas generan ganancia neta positiva
- Margen de seguridad del 28-34% proporciona colchón ante variabilidad
- **Estado:** Rentables pero no óptimas

#### 3. **Márgenes Consistentes Entre Productos**
- Rango estrecho de margen neto: 11.3-12.8%
- Indica estrategia de pricing homogénea y control de costos
- **Beneficio:** Predictibilidad financiera

---

### 🎯 Áreas Críticas de Mejora

#### 1. **URGENTE: Diagnosticar y Revertir Decrecimiento de Febrero-Marzo**

**Problema:**  
Caída del 50-95% en ventas de Feb-Mar vs Enero.

**Acciones Inmediatas:**
- ✅ Investigar causas raíz (inventario, demanda, competencia, estacionalidad)
- ✅ Entrevistas con vendedores de Barranquilla (caída del 95%)
- ✅ Análisis de pipeline de ventas: ¿faltaron prospectos o cerramiento?
- ✅ Revisar stock disponible en febrero: ¿hubo faltantes de Laptop Pro 15?

**Meta Q2:** Recuperar al menos el 70% del nivel de ventas de enero.

---

#### 2. **Optimizar Eficiencia Operativa (Score Actual: 26-33 / 100)**

**Problema:**  
Todas las tiendas clasifican como "Deficiente". ROI promedio 14.31% vs objetivo >30%.

**Componentes a Mejorar:**

**A) Reducir Peso de Costos Fijos (Actual: 28-34% de ventas)**
- **Meta:** Bajar a <25% de ventas
- **Tácticas:**
  - Renegociar arrendamientos (especialmente Bogotá: 28% de carga)
  - Evaluar estructura de personal: ¿hay sobrecarga administrativa?
  - Compartir recursos entre tiendas cercanas (ej: bodega centralizada)

**B) Incrementar ROI (Actual: 14.31% → Meta: >25%)**
- **Palanca 1 - Aumentar Margen:** Revisar pricing de productos de bajo margen
- **Palanca 2 - Rotar Inventario:** Reducir inversión en stock de baja rotación
- **Palanca 3 - Upselling:** Incrementar ticket promedio con accesorios complementarios

**C) Mejorar Ratio Venta/Inversión (Actual: 1.14-1.21 → Meta: >1.5)**
- Cada peso invertido genera solo $1.14-1.21 de venta
- Incrementar eficiencia mediante mejora en conversión y productividad de vendedores

**Impacto Esperado:**  
Mejora del 30% en eficiencia operativa elevaría score a ~40-45 (Regular-Bueno) y ROI a ~20-22%.

---

#### 3. **Diversificar Dependencia de "Laptop Pro 15"**

**Problema:**  
58.83% de ganancias de un solo producto = riesgo de concentración.

**Estrategia de Diversificación:**

**Fase 1 - Corto Plazo (1-2 meses):**
- ✅ Impulsar venta de Monitores (margen superior: 12.4-12.6%)
- ✅ Bundles: Laptop + Monitor + Accesorios (incrementa ticket y diversifica)
- ✅ Meta: Reducir contribución de Laptop Pro a <50%

**Fase 2 - Mediano Plazo (3-6 meses):**
- ✅ Ampliar catálogo: Laptops de otras gamas (gamer, ultrabook, estaciones de trabajo)
- ✅ Agregar categoría "Oficina": Sillas ergonómicas, escritorios, iluminación
- ✅ Servicios: Soporte técnico, garantías extendidas (margen >60%)

**Métrica de Éxito:**  
Top 3 productos deben contribuir <70% de ganancias totales (actual: 84.6%).

---

#### 4. **Expandir Portafolio Más Allá de Tecnología**

**Problema:**  
100% de ventas en una sola categoría limita oportunidades.

**Categorías Adyacentes con Sinergia:**

| Nueva Categoría | Margen Esperado | Inversión Inicial | Tiempo Implementación |
|-----------------|-----------------|-------------------|----------------------|
| Suministros Oficina | 25-35% | Baja | 1 mes |
| Mobiliario Ergonómico | 30-40% | Media | 2 meses |
| Servicios Técnicos | 50-70% | Muy baja | Inmediato |
| Software/Licencias | 40-60% | Muy baja | Inmediato |

**Beneficios:**
- ✅ Diversificación de riesgo
- ✅ Mayor valor por cliente (cross-selling)
- ✅ Mejora de márgenes globales (categorías complementarias suelen tener >25% margen)

**Piloto Recomendado:**  
Iniciar con servicios técnicos (instalación, configuración, soporte) en Bogotá por 1 mes. Inversión mínima, alto margen, aprovecha base de clientes de laptops.

---

#### 5. **Nivelar Productividad del Equipo de Ventas**

**Problema:**  
Solo tenemos visibilidad de top 3 vendedores. Falta análisis del equipo completo.

**Acciones:**

**A) Implementar Dashboard de Vendedores:**
- Métricas por vendedor: ventas, transacciones, ticket promedio, margen
- Ranking mensual con objetivos individuales
- Alertas de bajo desempeño (<50% del promedio)

**B) Programa de Capacitación:**
- Shadowing: Vendedores junior acompañan a Juan Perez (top performer)
- Training en técnicas de cierre y upselling
- Certificación en productos (profundidad técnica = mejor asesoría = mayor conversión)

**C) Sistema de Incentivos:**
- Comisión base por volumen + bonus por margen
- Incentiva vender productos de alto margen (monitores) vs solo volumen (laptops)

**Meta:**  
Reducir brecha entre top y bottom performer del actual >100% a <50% en 3 meses.

---

#### 6. **Estrategia Diferenciada por Ciudad**

Cada ciudad presenta un perfil distinto que requiere enfoque específico:

**🏙️ BOGOTÁ - Tienda Centro**
- **Situación:** Única con crecimiento en Feb (+6.67%), pero cae en Mar (-37%)
- **Fortaleza:** Mayor volumen de ventas promedio ($61M/mes)
- **Debilidad:** Costos fijos más pesados (28% vs 30-34% otras)
- **Estrategia:**
  - Optimizar costos: renegociar alquiler o reducir personal administrativo
  - Estabilizar tendencia: entender por qué cayó en marzo
  - Capitalizar ubicación céntrica para eventos/showroom

**🏙️ CALI - Tienda Norte**
- **Situación:** Segundo mejor score (31.41), pero caída del 51% en Feb
- **Fortaleza:** Segundo mayor volumen ($53.6M/mes promedio)
- **Estrategia:**
  - Recuperación urgente de nivel de enero
  - Análisis de competencia local: ¿ingresó competidor en Feb?
  - Explorar alianzas con empresas/universidades locales

**🏙️ MEDELLÍN - Tienda Sur**
- **Situación:** Menor volumen ($13.6M/mes), caída del 52% en Feb
- **Fortaleza:** Costos más controlados (margen de seguridad 30%)
- **Estrategia:**
  - Evaluar viabilidad: ¿el mercado justifica operación?
  - Si sí: enfoque en nicho (ej: gamers, creadores de contenido)
  - Si no: considerar cierre/reubicación

**🏙️ BARRANQUILLA - Tienda Este**
- **Situación:** CRÍTICA - Colapso del 95% en Feb (de $89.7M a $4.8M)
- **Fortaleza:** Cuando funciona, tiene mejor score (32.73)
- **Estrategia:**
  - Investigación inmediata: ¿qué pasó en febrero?
  - Hipótesis: ¿venta excepcional en enero (gran pedido corporativo) vs normalización después?
  - Decisión: ¿mantener, reestructurar o cerrar?

---

## 🎓 Lecciones Aprendidas

### 🔧 Técnicas

#### **1. Diseño de Arquitectura en Capas (Raw → Staging → Fact)**
Separar raw/staging/fact permitió iteraciones rápidas sin afectar datos originales. La capa staging fue crucial para normalizar inconsistencias antes de calcular métricas financieras.

**Aprendizaje clave:** En proyectos reales, invertiría más tiempo en validaciones en la capa staging (checks de calidad, detección de outliers) antes de cargar a fact.

#### **2. Window Functions para Análisis Temporal**
Usar `LAG() OVER (PARTITION BY tienda ORDER BY periodo)` para calcular crecimiento MoM fue más eficiente y legible que JOINs auto-referenciales.

**Caso de uso:** Esta técnica se escala fácilmente a comparaciones YoY, rolling averages, y análisis de cohorts.

#### **3. Prorrateo de Costos Fijos Basado en Ganancia Bruta**
Inicialmente prorratee según venta bruta, pero cambié a ganancia bruta para mayor precisión. Esto refleja mejor qué ventas realmente absorben costos operativos.

**Lección:** El método de asignación de costos fijos impacta directamente en la rentabilidad calculada por producto/transacción. Debe alinearse con el modelo de negocio.

#### **4. Normalización con Expresiones Regulares**
`REGEXP_REPLACE(precio, '[^0-9]', '', 'g')` fue esencial para limpiar formatos monetarios inconsistentes ($3.480.000 vs $220000 vs $65000).

**En producción:** Implementaría validaciones en el origen (aplicación de captura) para evitar este paso. También usaría tipos de datos monetarios nativos.

#### **5. CTEs para Modularidad y Legibilidad**
Usar Common Table Expressions en vistas complejas (como eficiencia_operativa) permitió:
- Dividir lógica en pasos comprensibles
- Facilitar debugging (puedes ejecutar solo el CTE)
- Mejorar mantenibilidad del código

**Ejemplo:** La vista de crecimiento MoM usa un CTE `metricas_mensuales` que luego se auto-joins con LAG, mucho más claro que una consulta monolítica.

---

### 📈 De Negocio

#### **1. Los KPIs Deben Contar una Historia, No Solo Mostrar Números**
No basta calcular métricas; deben responder preguntas de negocio. Por ejemplo:
- ROI solo es útil si se compara contra un benchmark o tendencia
- Punto de equilibrio solo importa si se relaciona con ventas reales y margen de seguridad
- El score de eficiencia integra 5 dimensiones para dar una visión holística

**Aprendizaje:** Siempre pensar "¿Qué decisión se tomaría con este dato?"

#### **2. El Contexto es Crítico para Interpretar Métricas**
Un margen neto del 12% puede ser:
- ✅ Excelente en supermercados (margen típico 2-5%)
- ⚠️ Aceptable en retail tecnológico (margen típico 15-25%)
- ❌ Bajo en software/servicios (margen típico 40-70%)

**Lección:** Siempre investigar benchmarks del sector antes de emitir juicios sobre performance.

#### **3. No Todos los Proyectos Tienen Resultados Positivos**
Este análisis reveló problemas serios (decrecimiento, baja eficiencia, concentración de riesgo). En el mundo real, muchos análisis descubren malas noticias.

**Valor para reclutadores:** Saber diagnosticar problemas y proponer soluciones concretas es más valioso que solo mostrar dashboards bonitos de casos de éxito.

#### **4. La Eficiencia Operativa es Multidimensional**
Una tienda puede tener:
- Alto volumen de ventas pero bajo ROI (costos excesivos)
- Buen margen pero mal ratio venta/inversión (inventario estancado)
- Muchas transacciones pero bajo ticket (ineficiencia comercial)

**Solución:** El score consolidado de eficiencia evita optimizar una métrica a costa de otras.

#### **5. La Concentración de Riesgo es Peligrosa**
Depender del 58% de ganancias de un producto y 100% de una categoría crea vulnerabilidad extrema. Diversificación no es solo "buena práctica", es supervivencia.

**Aplicación:** Este principio aplica a productos, clientes, proveedores, canales de venta.

---

## 🚀 Próximos Pasos: Fase 2 - Visualización con Power BI

Este proyecto SQL es la **Fase 1** de un análisis de dos fases. La siguiente etapa transformará estos insights en visualizaciones interactivas.

### 📊 Dashboard Planeado en Power BI

**Componentes del Dashboard:**

#### **1. Executive Summary (Página Principal)**
- 📌 KPIs Principales en Cards:
  - Venta Total Q1
  - Ganancia Neta Q1
  - Margen Neto %
  - ROI Promedio
  - Score de Eficiencia Promedio
- 📊 Gráfico de líneas: Evolución mensual de ventas y ganancias
- 🚨 Alertas automáticas: Tiendas con caída >30% MoM
- 🏆 Ranking de tiendas por eficiencia operativa

#### **2. Análisis de Ventas (Página 2)**
- 📈 Ventas por ciudad y mes (stacked bar chart)
- 🎯 Contribución por producto (treemap)
- 💵 Distribución de ticket promedio (histogram)
- 📊 Heatmap: Performance por tienda x mes

#### **3. Rentabilidad y Márgenes (Página 3)**
- 💰 Waterfall chart: De venta bruta a ganancia neta
- 📊 Comparación de márgenes: Bruto vs Operativo vs Neto
- 🎯 Scatter plot: ROI vs Margen Neto por tienda
- 📉 Punto de equilibrio vs ventas reales (gauge charts)

#### **4. Análisis de Productos (Página 4)**
- 🏆 Top 10 productos más rentables (bar chart)
- 📊 Matriz: Volumen vs Margen (identificar productos estrella)
- 🎯 Contribución acumulada (Pareto chart)
- 🔍 Drill-through: Detalle por producto individual

#### **5. Tendencias Temporales (Página 5)**
- 📈 Crecimiento MoM por tienda (line chart)
- 📊 Comparativo trimestral (column chart)
- 🎯 Forecast básico para Q2 2025 (si Power BI lo soporta)
- 🚨 Identificación de anomalías (alertas de caídas >40%)

#### **6. Análisis de Vendedores (Página 6)**
- 👥 Productividad individual (bar chart)
- 💼 Ticket promedio por vendedor
- 🎯 Margen generado por vendedor
- 📊 Distribución de transacciones

---

### 🔌 Conexión Técnica

**Power BI se conectará directamente a PostgreSQL:**
- ✅ Lectura en vivo de vistas de KPIs (no duplicación de datos)
- ✅ Refresh automático de métricas
- ✅ Filtros interactivos por periodo, ciudad, tienda, producto
- ✅ Drill-down desde resumen a detalle transaccional

**Beneficios:**
- 📊 Visualización profesional de los insights SQL
- 🔄 Actualización en tiempo real
- 🎯 Interactividad para exploración de datos
- 📱 Publicación online (Power BI Service) o exportación a PDF

---

### 📅 Timeline Estimado Fase 2

| Semana | Actividad | Entregable |
|--------|-----------|------------|
| 1 | Conexión Power BI - PostgreSQL | Conexión funcional |
| 2 | Desarrollo de páginas 1-3 | Executive + Ventas + Rentabilidad |
| 3 | Desarrollo de páginas 4-6 | Productos + Tendencias + Vendedores |
| 4 | Refinamiento y publicación | Dashboard completo + Screenshots para GitHub |

**Resultado final:** Dashboard interactivo `.pbix` + PDF exportado + Screenshots en el README del repo.

---

## 🔄 Cómo Replicar Este Proyecto

### Prerrequisitos

- PostgreSQL 17 o superior
- DBeaver 25.3.3 o cualquier cliente SQL
- Conocimientos básicos de SQL (SELECT, JOIN, agregaciones)
- Familiaridad con conceptos de ETL y modelado de datos

---

### Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/luis811ux/andes-retail-sql-analytics.git
cd andes-retail-sql-analytics
```

---

### Paso 2: Crear la Base de Datos

Abre tu cliente SQL (DBeaver, pgAdmin, psql) y ejecuta:

```sql
CREATE DATABASE andes_retail_db;
\c andes_retail_db  -- Conectar a la base de datos
```

---

### Paso 3: Ejecutar Scripts en Orden

Los scripts SQL deben ejecutarse en el siguiente orden para respetar dependencias:

```bash
# 1. Crear schemas (raw, stg, dim, fact)
sql/01-schemas/create_schemas.sql

# 2. Crear tablas de dimensiones
sql/dim/create_dim_tiendas.sql
sql/dim/create_dim_productos.sql
sql/dim/create_dim_clientes.sql
sql/dim/create_dim_vendedores.sql
sql/dim/create_costos_fijos_2025.sql
sql/dim/insert_costos_fijos.sql  # Insertar datos de costos fijos

# 3. Crear tablas raw (datos crudos)
sql/raw/create_ventas_2025_01_raw.sql
sql/raw/create_ventas_2025_02_raw.sql
sql/raw/create_ventas_2025_03_raw.sql

# 4. Crear tabla staging
sql/stg/create_ventas_2025.sql

# 5. Crear tabla fact (hechos principales)
sql/fact/create_fact_ventas.sql

# 6. Ejecutar ETL (transformar y cargar datos)
sql/fact/etl_raw_to_stg.sql      # Raw → Staging
sql/fact/etl_stg_to_fact.sql     # Staging → Fact
sql/fact/update_costos_fijos.sql # Prorratear costos fijos

# 7. Crear vistas de KPIs
sql/fact/kpis/kpi_ticket_promedio.sql
sql/fact/kpis/kpi_productividad_vendedor.sql
sql/fact/kpis/kpi_top_productos.sql
sql/fact/kpis/kpi_crecimiento_mom.sql
sql/fact/kpis/kpi_contribucion_categoria.sql
sql/fact/kpis/kpi_roi_tienda.sql
sql/fact/kpis/kpi_punto_equilibrio.sql
sql/fact/kpis/kpi_eficiencia_operativa.sql

# 8. Crear vista consolidada financiera
sql/fact/view_finanzas_tienda_mes.sql
```

---

### Paso 4: Cargar Datos CSV

Los archivos CSV están en `data/raw/ventas/2025/`. Importarlos usando DBeaver:

1. **Conectar a la base de datos** `andes_retail_db`
2. **Navegar** a `raw.ventas_2025_01_raw` (clic derecho)
3. **Seleccionar:** "Import Data" → "From CSV file"
4. **Configurar importación:**
   - Archivo: `data/raw/ventas/2025/ventas_2025_01.csv`
   - Delimitador: `;` (punto y coma)
   - Primera fila contiene encabezados: ✅
   - Codificación: UTF-8
5. **Mapear columnas** automáticamente
6. **Ejecutar** importación
7. **Repetir** para `ventas_2025_02.csv` → `raw.ventas_2025_02_raw`
8. **Repetir** para `ventas_2025_03.csv` → `raw.ventas_2025_03_raw`

---

### Paso 5: Verificar Resultados

Ejecuta estas consultas de verificación:

```sql
-- 1. Verificar carga de datos raw
SELECT COUNT(*) FROM raw.ventas_2025_01_raw; -- Debe devolver 8
SELECT COUNT(*) FROM raw.ventas_2025_02_raw; -- Debe devolver 8
SELECT COUNT(*) FROM raw.ventas_2025_03_raw; -- Debe devolver 8

-- 2. Verificar staging
SELECT COUNT(*) FROM stg.ventas_2025; -- Debe devolver 24 (8+8+8)

-- 3. Verificar fact
SELECT COUNT(*) FROM fact.ventas_2025; -- Debe devolver 24

-- 4. Verificar que las métricas se calcularon correctamente
SELECT 
    venta_id,
    venta_bruta,
    costo_compra,
    ganancia_bruta,
    costo_fijo_prorrateado,
    ganancia_operativa,
    impuesto,
    ganancia_neta
FROM fact.ventas_2025
LIMIT 5;

-- 5. Probar un KPI
SELECT * 
FROM fact.kpi_eficiencia_operativa 
ORDER BY score_eficiencia DESC;

-- 6. Verificar totales
SELECT 
    SUM(venta_bruta) AS venta_total,
    SUM(ganancia_neta) AS ganancia_total,
    ROUND(SUM(ganancia_neta) / SUM(venta_bruta) * 100, 2) AS margen_neto
FROM fact.ventas_2025;
-- Debe devolver: $485,692,000 | $58,461,717.6 | 12.04%
```

---

### Paso 6: Explorar los KPIs

Prueba cada KPI con estas consultas de ejemplo:

```sql
-- KPI 1: Ticket Promedio
SELECT * FROM fact.kpi_ticket_promedio 
ORDER BY periodo, ticket_promedio DESC;

-- KPI 2: Productividad Vendedor
SELECT * FROM fact.kpi_productividad_vendedor 
WHERE periodo = '2025-01-01'
ORDER BY venta_total DESC;

-- KPI 3: Top Productos
SELECT * FROM fact.kpi_top_productos 
ORDER BY periodo, ganancia_neta DESC
LIMIT 10;

-- KPI 4: Crecimiento MoM
SELECT * FROM fact.kpi_crecimiento_mom 
WHERE periodo = '2025-02-01'
ORDER BY crecimiento_venta_pct DESC;

-- KPI 5: Contribución Categoría
SELECT * FROM fact.kpi_contribucion_categoria;

-- KPI 6: ROI Tienda
SELECT * FROM fact.kpi_roi_tienda 
ORDER BY periodo, roi_pct DESC;

-- KPI 7: Punto Equilibrio
SELECT * FROM fact.kpi_punto_equilibrio 
ORDER BY margen_seguridad_pct ASC;

-- KPI 8: Eficiencia Operativa
SELECT * FROM fact.kpi_eficiencia_operativa 
ORDER BY score_eficiencia DESC;
```

---

### 📝 Notas Importantes

- ⚠️ **Datos ficticios:** Todos los datos son completamente inventados para fines demostrativos
- 💰 **Moneda:** Todos los valores están en pesos colombianos (COP)
- 📅 **Periodo:** El análisis cubre enero-marzo 2025
- 🔢 **Volumen:** El dataset contiene 24 transacciones totales (8 por mes)
- 🏢 **Costos fijos:** Calculados retroactivamente para generar ~30% de margen operativo en enero
- 📊 **Decrecimiento:** El patrón de caída Feb-Mar es intencional para simular análisis de problemas reales

---

### 🐛 Troubleshooting

**Problema:** Error al importar CSV  
**Solución:** Verificar que el delimitador sea `;` y la codificación UTF-8

**Problema:** Valores NULL en fact.ventas_2025  
**Solución:** Verificar que el ETL se ejecutó correctamente (script `update_costos_fijos.sql`)

**Problema:** KPIs sin datos  
**Solución:** Asegurarse de que `fact.ventas_2025` tenga las 24 filas antes de crear las vistas

**Problema:** Error en window functions  
**Solución:** Verificar que PostgreSQL sea versión 17 o superior (window functions requieren versiones modernas)

---

## 📧 Contacto

**Luis Fernando Alcalá R.**  
*Data Analyst | SQL | Business Intelligence*

📧 Email: [luisfer811@gmail.com](mailto:luisfer811@gmail.com)  
💼 LinkedIn: [linkedin.com/in/luis-f-alcala](https://www.linkedin.com/in/luis-f-alcala)  
🐙 GitHub: [github.com/luis811ux](https://github.com/luis811ux)

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Siéntete libre de usar este código como referencia, base para tus propios proyectos de análisis, o para aprendizaje.

**Permisiones:**
- ✅ Uso comercial
- ✅ Modificación
- ✅ Distribución
- ✅ Uso privado

**Limitaciones:**
- ❌ Sin garantía
- ❌ Sin responsabilidad del autor

Ver archivo `LICENSE` para detalles completos.

---

## ⭐ Agradecimientos

Si este proyecto te fue útil para:
- Aprender SQL y diseño de bases de datos
- Entender cómo estructurar un proyecto de análisis de datos
- Preparar tu propio portafolio
- Comprender cálculo de KPIs financieros

Considera darle una estrella ⭐ al repositorio. ¡Gracias!

---

## 🔖 Keywords

`SQL` `PostgreSQL` `Data Analytics` `ETL` `Business Intelligence` `KPIs` `Financial Analysis` `Database Design` `Data Modeling` `Window Functions` `Retail Analytics` `Data Pipeline` `DBeaver` `Data Warehouse`

---

**Última actualización:** Febrero 2025  
**Versión:** 1.0  
**Estado:** Completo (Fase 1 - SQL) | En desarrollo (Fase 2 - Power BI)

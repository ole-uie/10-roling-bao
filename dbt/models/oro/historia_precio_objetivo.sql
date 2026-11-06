-- ORO · Historia: ¿a qué precio tendría que vender Fiesta Universitaria para ganar lo que un festival típico?
-- Objetivo = la MEDIANA del margen total de los otros siete festivales, no la media, porque:
--   · es un festival real (el del medio), así que se explica sin fórmulas: «ganar lo que gana un festival típico»;
--   · no la mueven los extremos: la media depende de los dos más grandes (Electro Puerto y Brisa Fest),
--     y con solo siete festivales uno grande la desplaza; la J7 insiste en que la media sola engaña.
-- Costes por ración: los de historia_rentabilidad (ingredientes 6 €/kg; mano de obra 5 min a 12,70 €/h).
-- Dos escenarios de volumen (supuesto de la dirección): se venden las mismas raciones, o un 20 % menos.
-- precio_base es el precio del escenario «mismas raciones»; margen_precio_base y perdida_max_pct dicen
-- qué pasaría con ese precio en cada escenario y cuántas raciones se pueden perder sin ganar menos que hoy.
with r as (
    select * from {{ ref('historia_rentabilidad') }}
),
fu as (
    select raciones, margen as margen_hoy, precio_racion as precio_hoy,
           (coste_ingredientes + coste_mano_obra) / raciones as coste_racion
    from r where festival = 'Fiesta Universitaria'
),
objetivo as (
    select median(margen) as margen_objetivo from r where festival <> 'Fiesta Universitaria'
),
escenarios as (
    select * from (values (0, 'Mismas raciones', 1.0), (1, '20 % menos de raciones', 0.8)) as e(orden, escenario, factor)
),
calculo as (
    select e.orden, e.escenario, e.factor,
           fu.raciones * e.factor                                                  as raciones,
           fu.coste_racion, fu.margen_hoy, fu.precio_hoy, o.margen_objetivo,
           fu.coste_racion + o.margen_objetivo / (fu.raciones * e.factor)          as precio_objetivo,
           round(fu.coste_racion + o.margen_objetivo / fu.raciones, 2)             as precio_base
    from escenarios e, fu, objetivo o
)
select
    escenario,
    round(raciones, 0)                                                      as raciones,
    precio_hoy,
    round(coste_racion, 2)                                                  as coste_racion,
    round(margen_hoy, 0)                                                    as margen_hoy,
    round(margen_objetivo, 0)                                               as margen_objetivo,
    round(precio_objetivo, 2)                                               as precio_objetivo,
    round(precio_objetivo - precio_hoy, 2)                                  as subida_eur,
    round(100 * (precio_objetivo - precio_hoy) / precio_hoy, 0)             as subida_pct,
    precio_base,
    round(raciones * (precio_base - coste_racion), 0)                       as margen_precio_base,
    -- con precio_base, cuántas raciones (sobre las de hoy) se pueden perder sin ganar menos que hoy
    round(100 * (1 - margen_hoy / (raciones / factor * (precio_base - coste_racion))), 0) as perdida_max_pct
from calculo
order by orden

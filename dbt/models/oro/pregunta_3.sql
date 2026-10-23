-- ORO · Pregunta 3: ¿qué food truck acumula más incidencias por cada 1.000 raciones?
-- Turnos con incidencia / total de raciones × 1.000: así se compara a trucks con distinto volumen.
-- De mayor a menor: la fila 0 es la respuesta.
select
    food_truck,
    round(count(*) filter (where con_incidencia) / sum(raciones) * 1000, 2) as incidencias_1000raciones
from {{ ref('fact_turnos') }}
group by food_truck
order by incidencias_1000raciones desc
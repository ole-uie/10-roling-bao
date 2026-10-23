-- ORO · Pregunta 2: ¿qué cocinero gasta más ingredientes por ración?
-- kg por cada 100 raciones = total de kg / total de raciones × 100 (cociente de sumas).
-- De mayor a menor: la fila 0 es la respuesta.
select
    cocinero,
    round(sum(kg_ingredientes) / sum(raciones) * 100, 2) as kg_100raciones
from {{ ref('fact_turnos') }}
group by cocinero
order by kg_100raciones desc
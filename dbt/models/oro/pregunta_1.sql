-- ORO · Pregunta 1: ¿qué festival deja menos ingreso por ración?
-- Cociente de sumas (todo lo cobrado / todas las raciones), no media de ratios:
-- así un turno de 270 raciones pesa más que uno de 70. De menor a mayor: la fila 0 es la respuesta.
select
    festival,
    round(sum(importe_eur) / sum(raciones), 2) as ingreso_racion
from {{ ref('fact_turnos') }}
group by festival
order by ingreso_racion asc
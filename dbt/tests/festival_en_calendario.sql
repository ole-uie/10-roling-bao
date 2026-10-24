-- TEST PROTAGONISTA · Todo festival del parte existe en el calendario.
-- Versión estricta: cada turno del parte tiene que coincidir con lo planificado en el calendario
-- ese mismo día, para ese mismo food truck y en ese mismo festival.
-- Devuelve los turnos que incumplen la regla: si sale alguna fila, el test falla.
select
    p.turno,
    p.fecha,
    p.food_truck,
    p.festival
from {{ ref('stg_parte') }} p
where not exists (
    select 1
    from {{ ref('stg_calendario') }} c
    where c.fecha      = p.fecha
      and c.food_truck = p.food_truck
      and c.festival   = p.festival
)

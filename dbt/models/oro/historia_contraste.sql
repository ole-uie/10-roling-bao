-- ORO · Historia, paso 3: la misma cifra con los datos tal como llegan y limpios.
-- Sin limpiar, los turnos con el festival mal escrito («Fiesta Uni», «ROCK NA VILA»…) no casan
-- con ningún festival oficial y se pierden; las raciones imposibles entran tal cual.
with sin_limpiar as (
    select festival,
           count(*)                                                       as turnos,
           sum(importe_eur::double) / sum(raciones::integer)              as racion
    from {{ source('bronce', 'parte') }}
    group by festival
),
limpio as (
    select festival,
           count(*)                                                       as turnos,
           sum(importe_eur) / sum(raciones)                               as racion
    from {{ ref('stg_parte') }}
    group by festival
)
select
    l.festival,
    s.turnos                  as turnos_sin_limpiar,
    l.turnos                  as turnos_limpio,
    round(s.racion, 2)        as racion_sin_limpiar,
    round(l.racion, 2)        as racion_limpio
from limpio l
join sin_limpiar s using (festival)
order by racion_limpio asc

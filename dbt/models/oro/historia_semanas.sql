-- ORO · Historia, paso 2: ingreso por ración semana a semana (semana ISO del año, 'S19'),
-- Fiesta Universitaria frente al resto. Si fuera un mal fin de semana, la línea subiría y bajaría.
select
    'S' || strftime(fecha, '%V')                                                    as semana,
    round(sum(importe_eur) / sum(raciones), 2)                                      as todos,
    round(sum(importe_eur) filter (where festival = 'Fiesta Universitaria')
        / sum(raciones) filter (where festival = 'Fiesta Universitaria'), 2)        as fiesta_universitaria,
    round(sum(importe_eur) filter (where festival <> 'Fiesta Universitaria')
        / sum(raciones) filter (where festival <> 'Fiesta Universitaria'), 2)       as resto
from {{ ref('fact_turnos') }}
group by semana
order by semana

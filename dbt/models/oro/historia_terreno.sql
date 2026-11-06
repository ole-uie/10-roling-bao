-- ORO · Historia, paso 2a: el terreno. Una fila con las cifras de contexto del parte limpio.
select
    count(*)                                         as turnos,
    count(distinct festival)                         as festivales,
    count(distinct food_truck)                       as food_trucks,
    sum(raciones)                                    as raciones,
    round(sum(importe_eur), 0)                       as facturacion,
    round(sum(importe_eur) / sum(raciones), 2)       as ingreso_racion,
    strftime(min(fecha), '%d/%m/%Y')                 as desde,
    strftime(max(fecha), '%d/%m/%Y')                 as hasta
from {{ ref('fact_turnos') }}

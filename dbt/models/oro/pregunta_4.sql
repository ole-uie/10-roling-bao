-- ORO · Pregunta 4: ¿qué festival rinde más por hora abierta y cuál es su mejor hora?
-- Rinde = € facturados / horas abiertas ese día (del calendario).
-- Mejor hora = la hora con más pedidos; si empatan, la que más € facturó.
-- EL GIRO: todo se cuenta por la hora del pedido (hora_pedido = ts_evento), nunca por la de envío.
-- FT-11 (Jazz Jardín, sin cobertura) manda sus pedidos de golpe: por hora de envío su mejor hora
-- saldría las 23:00, cuando ya había cerrado.
-- Cada parte se lleva por separado al nivel festival antes de unirlas, para no multiplicar filas.
with ventas as (
    select
        festival,
        food_truck,
        hora_pedido::date              as fecha,
        sum(importe_eur)               as importe_eur
    from {{ ref('stg_eventos') }}
    group by all
),
por_hora as (
    select
        festival,
        hour(hora_pedido)              as hora,
        count(*)                       as pedidos,
        sum(importe_eur)               as importe_eur
    from {{ ref('stg_eventos') }}
    group by all
),
mejor_hora as (
    select festival, hora
    from por_hora
    qualify row_number() over (partition by festival order by pedidos desc, importe_eur desc) = 1
)
select
    v.festival,
    round(v.importe_eur / c.horas_abiertas, 2)            as eur_hora_abierta,
    lpad(m.hora::varchar, 2, '0') || ':00'                as mejor_hora
from ventas v
join {{ ref('stg_calendario') }} c
  on c.fecha = v.fecha and c.festival = v.festival and c.food_truck = v.food_truck
join mejor_hora m on m.festival = v.festival
order by eur_hora_abierta desc

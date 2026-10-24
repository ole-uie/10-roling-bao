-- PLATA · registro de pedidos de los TPV del 2026-06-27: un pedido por fila.
-- EL GIRO: FT-11 (Jazz Jardín) está en un recinto sin cobertura. Guarda los pedidos y los envía
-- de golpe (20:00, 21:36 y 23:12), con hasta 95 minutos de retraso. Si se cuenta por la hora de
-- llegada al servidor (ts_envio), su mejor hora sería las 23:00, cuando ya había cerrado.
-- Arreglo: la hora que vale es la del pedido (ts_evento). ts_envio se guarda solo para medir el retraso.
with bruto as (
    select * from {{ source('bronce', 'eventos') }}
)
select
    pedido_id,
    food_truck,
    festival,
    ts_evento                                                as hora_pedido,
    ts_envio                                                 as hora_envio,
    round(epoch(ts_envio - ts_evento) / 60, 1)               as minutos_retraso,
    raciones,
    importe                                                  as importe_eur
from bruto
-- Un pedido por fila: hoy no hay duplicados, pero un TPV que reenvía tras perder la conexión
-- podría mandar el mismo pedido dos veces. Me quedo con el último envío de cada pedido_id
-- (si un reenvío trajera una corrección, esa es la versión buena). esto impacta la hora de envio
qualify row_number() over (partition by pedido_id order by ts_envio desc) = 1
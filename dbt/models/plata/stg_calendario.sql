-- PLATA · calendario: en qué festival estuvo cada food truck cada día y su horario.
-- Una fila por día, festival y food truck (427 filas, del 2026-05-04 al 2026-06-27). Se guarda
-- entero: el test protagonista lo necesita para comprobar todo el parte, y la pregunta 4 ya se
-- queda solo con el 27 de junio al cruzarlo con los pedidos.
-- HORAS ABIERTAS: casi todos los días el horario cruza la medianoche (18:00 -> 02:00). Restar
-- cierre - apertura daría -16 h; si el cierre es igual o anterior a la apertura, sumo 24 h -> 8 h.
select
    fecha,
    festival,
    food_truck,
    hora_apertura,
    hora_cierre,
    (
        epoch(hora_cierre) - epoch(hora_apertura)
        + case when hora_cierre <= hora_apertura then 24 * 3600 else 0 end
    ) / 3600                                                   as horas_abiertas
from {{ source('bronce', 'calendario') }}
-- ORO · hecho turnos: un turno por fila, con sus medidas y las claves de las tres dimensiones.
-- Lee de plata (stg_parte), donde ya están limpios el festival, el cocinero y las raciones.
select
    turno,
    fecha,
    cocinero,                                   -- clave hacia dim_cocinero
    food_truck,                                 -- clave hacia dim_food_truck
    festival,                                   -- clave hacia dim_festival
    raciones,
    kg_ingredientes,
    importe_eur,
    -- en el parte la incidencia viene vacía cuando no hubo ninguna
    incidencia is not null as con_incidencia
from {{ ref('stg_parte') }}
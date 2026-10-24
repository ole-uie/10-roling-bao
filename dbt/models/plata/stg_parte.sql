-- PLATA · el parte diario limpio: la limpieza que hiciste en la J3, ahora como modelo dbt.
-- Cada entrega del parte es una carpeta fecha_carga=… en bronce: aquí se leen todas juntas.
with bruto as (
    select *, parse_filename(filename) as archivo
    from {{ source('bronce', 'parte') }}
),
con_clave as (
    -- Clave de comparación del festival: sin tildes, en minúsculas, cualquier signo
    -- (espacios dobles, guiones, puntos, paréntesis…) convertido en un solo espacio,
    -- y sin un año suelto (2000-2099). Ej.: '  Electro_Puerto (2025) ' -> 'electro puerto'
    select *,
        trim(regexp_replace(
            regexp_replace(lower(strip_accents(festival)), '[^a-z0-9]+', ' ', 'g'),
            '(^| )20[0-9][0-9]( |$)', ' ', 'g'
        )) as clave_festival
    from bruto
),
normalizado as (
    -- REMESA 2026-06-25: los cocineros rellenaron el festival desde el móvil, cada uno a su manera.
    -- 26 de 89 filas traen 8 grafías que no existen: mayúsculas ('ROCK NA VILA', 'FIESTA UNIVERSITARIA'),
    -- minúsculas ('electro puerto', 'jazz jardín'), sin tilde ('Jazz Jardin'), abreviado ('Fiesta Uni')
    -- y con el año ('Electro-Puerto 2026'). La entrega del 2026-06-15 venía bien.
    -- Arreglo en dos niveles:
    --   1) La clave (con_clave) absorbe sola mayúsculas, tildes, signos y años.
    --   2) La clave se traduce al nombre oficial con el seed equivalencias_festival.csv: los 8
    --      festivales oficiales y los casos que la clave no resuelve (abreviaturas, erratas).
    --      Para un caso nuevo, se añade una fila al CSV; no hay que tocar este SQL.
    -- Lo que no está en el seed sale tal cual (left join): NO se corrige a ciegas ni se pierde;
    -- el test protagonista y accepted_values se ponen rojos y alguien decide a qué festival corresponde.
    -- Va antes de la mediana por festival para que cada festival tenga una sola mediana.
    select c.* replace (coalesce(e.festival, trim(c.festival)) as festival)
    from con_clave c
    left join {{ ref('equivalencias_festival') }} e on e.clave = c.clave_festival
),
sin_dup as (
    -- una fila por turno
    select * from normalizado
    qualify row_number() over (partition by turno order by fecha_carga desc) = 1
),
mediana_festival as (
    select festival, median(raciones::integer) as raciones_mediana
    from sin_dup
    where raciones::integer between 1 and 1000
    group by festival
)
select
    s.turno,
    s.fecha::date                                              as fecha,
    upper(trim(s.cocinero))                                         as cocinero,
    s.food_truck,
    s.festival,
    case when s.raciones::integer between 1 and 1000 then s.raciones::integer
         else round(m.raciones_mediana)::integer end               as raciones,
    not (s.raciones::integer between 1 and 1000)                   as raciones_corregido,
    s.kg_ingredientes::double                                              as kg_ingredientes,
    s.importe_eur::double                                      as importe_eur,
    s.incidencia,
    s.archivo,
    s.fecha_carga
from sin_dup s
join mediana_festival m using (festival)

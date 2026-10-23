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
    --   1) La clave (con_clave) absorbe sola mayúsculas, tildes, signos y años: no hay que tocar nada.
    --   2) Lo que la clave no resuelve (abreviaturas, erratas) va en "EQUIVALENCIAS", una línea por caso.
    -- Lo que no se reconoce sale tal cual (else): NO se corrige a ciegas; el test accepted_values
    -- se pone rojo y alguien decide a qué festival corresponde.
    -- Va antes de la mediana por festival para que cada festival tenga una sola mediana.
    select * replace (
        case clave_festival
            -- los 8 festivales oficiales (clave -> nombre oficial)
            when 'brisa fest'           then 'Brisa Fest'
            when 'indie ria'            then 'Indie Ría'
            when 'electro puerto'       then 'Electro Puerto'
            when 'rock na vila'         then 'Rock na Vila'
            when 'jazz jardin'          then 'Jazz Jardín'
            when 'feria gastro'         then 'Feria Gastro'
            when 'mercado nocturno'     then 'Mercado Nocturno'
            when 'fiesta universitaria' then 'Fiesta Universitaria'
            -- EQUIVALENCIAS: casos que la clave no resuelve. Para uno nuevo, añade una línea
            -- con su clave (la columna "clave" de la consulta de revisión) y el nombre oficial.
            when 'fiesta uni'           then 'Fiesta Universitaria'
            else trim(festival)
        end as festival
    )
    from con_clave
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

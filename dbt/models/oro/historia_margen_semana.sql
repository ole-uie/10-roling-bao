-- ORO · Historia, paso 2b: el mapa de calor festival × semana con el margen total (€) de cada casilla.
-- Mismos supuestos de coste que historia_rentabilidad: ingredientes a 6 €/kg; mano de obra 5 min
-- por ración a 9,55 €/h brutos × 1,33 de Seguridad Social de empresa = 12,70 €/h.
-- Los valores están en el seed supuestos_coste.csv.
-- celda identifica la fila (festival y semana) para el test unique.
with supuestos as (
    select
        max(valor) filter (where supuesto = 'eur_kg_ingredientes') as eur_kg_ingredientes,
        max(valor) filter (where supuesto = 'min_por_racion')      as min_por_racion,
        max(valor) filter (where supuesto = 'eur_hora_bruto')
          * (1 + max(valor) filter (where supuesto = 'pct_ss_empresa')) as eur_hora
    from {{ ref('supuestos_coste') }}
)
select
    f.festival || ' · S' || strftime(f.fecha, '%V')                               as celda,
    f.festival,
    'S' || strftime(f.fecha, '%V')                                                as semana,
    round(sum(f.importe_eur - f.kg_ingredientes * s.eur_kg_ingredientes
              - f.raciones * s.min_por_racion / 60 * s.eur_hora), 0)            as margen
from {{ ref('fact_turnos') }} f, supuestos s
group by all
order by festival, semana

-- ORO · Historia: una fila por turno, para los histogramas.
--   · eur_racion: lo cobrado por ración, tal cual (paso 2a).
--   · coste_racion y margen_racion: con los mismos supuestos de historia_rentabilidad (paso 2b):
--     ingredientes a 6 €/kg; mano de obra 5 min por ración a 9,55 €/h brutos × 1,33 de Seguridad
--     Social de empresa = 12,70 €/h. Los valores están en el seed supuestos_coste.csv.
with supuestos as (
    select
        max(valor) filter (where supuesto = 'eur_kg_ingredientes') as eur_kg_ingredientes,
        max(valor) filter (where supuesto = 'min_por_racion')      as min_por_racion,
        max(valor) filter (where supuesto = 'eur_hora_bruto')
          * (1 + max(valor) filter (where supuesto = 'pct_ss_empresa')) as eur_hora
    from {{ ref('supuestos_coste') }}
)
select
    f.turno,
    f.festival,
    round(f.importe_eur / f.raciones, 2)                                                    as eur_racion,
    round((f.kg_ingredientes * s.eur_kg_ingredientes
           + f.raciones * s.min_por_racion / 60 * s.eur_hora) / f.raciones, 2)             as coste_racion,
    round((f.importe_eur - f.kg_ingredientes * s.eur_kg_ingredientes
           - f.raciones * s.min_por_racion / 60 * s.eur_hora) / f.raciones, 2)             as margen_racion
from {{ ref('fact_turnos') }} f, supuestos s
order by f.turno

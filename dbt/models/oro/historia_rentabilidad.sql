-- ORO · Historia: rentabilidad por festival = lo cobrado menos el coste de producir las raciones.
-- El parte no trae costes en euros; se calculan con dos SUPUESTOS de la dirección:
--   · Ingredientes: 6 €/kg (PRECIO_CONSUMO del cuaderno de la J3).
--   · Mano de obra: cada ración ocupa 5 min (tomar el pedido, preparar ingredientes, cocinar,
--     emplatar y cobrar). Coste del empleado para la empresa = 9,55 €/h brutos (salario mínimo)
--     × (1 + 33 % de Seguridad Social de empresa) = 12,70 €/h. El 33 % es aproximado, para un
--     contrato temporal: contingencias comunes 23,6 %, desempleo 6,7 %, FOGASA 0,2 %,
--     formación 0,6 %, MEI ≈ 0,75 % y accidentes de trabajo ≈ 1,5 %.
-- No incluye canon del festival, transporte, gas ni amortización del truck.
-- De menor a mayor margen por ración: la fila 0 es la que menos deja.
-- Los valores están en un solo sitio: el seed supuestos_coste.csv.
with supuestos as (
    select
        max(valor) filter (where supuesto = 'eur_kg_ingredientes') as eur_kg_ingredientes,
        max(valor) filter (where supuesto = 'min_por_racion')      as min_por_racion,
        max(valor) filter (where supuesto = 'eur_hora_bruto')      as eur_hora_bruto,
        max(valor) filter (where supuesto = 'pct_ss_empresa')      as pct_ss_empresa
    from {{ ref('supuestos_coste') }}
),
coste_hora as (
    select *, eur_hora_bruto * (1 + pct_ss_empresa) as eur_hora from supuestos
),
por_festival as (
    select
        f.festival,
        sum(f.raciones)                                          as raciones,
        sum(f.importe_eur)                                       as ingreso,
        sum(f.kg_ingredientes) * s.eur_kg_ingredientes           as coste_ingredientes,
        sum(f.raciones) * s.min_por_racion / 60 * s.eur_hora     as coste_mano_obra
    from {{ ref('fact_turnos') }} f, coste_hora s
    group by f.festival, s.eur_kg_ingredientes, s.min_por_racion, s.eur_hora
)
select
    festival,
    raciones,
    round(ingreso, 0)                                                        as ingreso,
    round(coste_ingredientes, 0)                                             as coste_ingredientes,
    round(coste_mano_obra, 0)                                                as coste_mano_obra,
    round(ingreso - coste_ingredientes - coste_mano_obra, 0)                 as margen,
    round(ingreso / raciones, 2)                                             as precio_racion,
    round((coste_ingredientes + coste_mano_obra) / raciones, 2)              as coste_racion,
    round((ingreso - coste_ingredientes - coste_mano_obra) / raciones, 2)    as margen_racion,
    round(100 * (ingreso - coste_ingredientes - coste_mano_obra) / ingreso, 1) as margen_pct
from por_festival
order by margen_racion asc

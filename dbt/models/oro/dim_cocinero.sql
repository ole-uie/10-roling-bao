-- ORO · dimensión cocinero: una fila por cada cocinero distinto del parte.
select distinct cocinero
from {{ ref('stg_parte') }}
order by cocinero
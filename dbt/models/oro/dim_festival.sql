-- ORO · dimensión festival: una fila por cada festival distinto del parte.
select distinct festival
from {{ ref('stg_parte') }}
order by festival
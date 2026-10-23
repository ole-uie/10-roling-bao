-- ORO · dimensión food truck: una fila por cada food truck distinto del parte.
select distinct food_truck
from {{ ref('stg_parte') }}
order by food_truck
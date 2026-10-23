# 2 · El oro

Mi estrella: Una fila de `fact_turnos` es un turno de un cocinero en un food truck y un festival, con sus raciones, kilos de ingredientes, importe y si hubo incidencia: {{ fact_turnos.filas }} turnos en total.
Lo rodean tres dimensiones:
-`dim_cocinero` ({{ dim_cocinero.filas }} cocineros),
`dim_food_truck` ({{ dim_food_truck.filas }} food trucks)
`dim_festival` ({{ dim_festival.filas }} festivales). 
Los tests garantizan que no hay turnos repetidos y que todo cocinero, truck y festival del hecho existe en su dimensión
Lo comprobé apuntando un test a la dimensión equivocada: se puso rojo y dbt no construyó las preguntas.

Pregunta 1 · ¿Qué festival deja menos ingreso por ración? 
{{ pregunta_1.festival[0] }}, con {{ pregunta_1.ingreso_racion[0] }} €/ración, muy por debajo del siguiente, {{ pregunta_1.festival[1] }}, con {{ pregunta_1.ingreso_racion[1] }} €.

Pregunta 2 · ¿Qué cocinero gasta más ingredientes por ración?
{{ pregunta_2.cocinero[0] }}, con {{ pregunta_2.kg_100raciones[0] }} kg por cada 100 raciones, frente a {{ pregunta_2.kg_100raciones[1] }} kg de {{ pregunta_2.cocinero[1] }}.

Pregunta 3 · ¿Qué food truck acumula más incidencias por cada 1.000 raciones?
{{ pregunta_3.food_truck[0] }}, con {{ pregunta_3.incidencias_1000raciones[0] }} incidencias por cada 1.000 raciones, frente a {{ pregunta_3.incidencias_1000raciones[1] }} de {{ pregunta_3.food_truck[1] }}.

¿Se mantienen las respuestas de la J3? 
Aunque agregamos 89 turnos (+25%) a la base de datos, el "ganador" de cada pregunta sigue siendo el mismo porque la diferencia con el segundo puesto es muy grande. Lo que si cambió es el segundo puesto en en incidencias (FT-11 adelanta a FT-51).
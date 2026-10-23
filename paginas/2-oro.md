# 2 · El oro

Mi estrella. Una fila de `fact_turnos` es un turno de un cocinero en un food truck y un festival, con sus raciones, kilos de ingredientes, importe y si hubo incidencia: {{ fact_turnos.filas }} turnos en total. Lo rodean tres dimensiones: `dim_cocinero` ({{ dim_cocinero.filas }} cocineros), `dim_food_truck` ({{ dim_food_truck.filas }} food trucks) y `dim_festival` ({{ dim_festival.filas }} festivales). Los tests garantizan que no hay turnos repetidos y que todo cocinero, truck y festival del hecho existe en su dimensión; lo comprobé apuntando un test a la dimensión equivocada: se puso rojo y dbt no construyó las preguntas.

Pregunta 1 · ¿Qué festival deja menos ingreso por ración? {{ pregunta_1.festival[0] }}, con {{ pregunta_1.ingreso_racion[0] }} €/ración, muy por debajo del siguiente, {{ pregunta_1.festival[1] }}, con {{ pregunta_1.ingreso_racion[1] }} €.

Pregunta 2 · ¿Qué cocinero gasta más ingredientes por ración? {{ pregunta_2.cocinero[0] }}, con {{ pregunta_2.kg_100raciones[0] }} kg por cada 100 raciones, frente a {{ pregunta_2.kg_100raciones[1] }} kg de {{ pregunta_2.cocinero[1] }}.

Pregunta 3 · ¿Qué food truck acumula más incidencias por cada 1.000 raciones? {{ pregunta_3.food_truck[0] }}, con {{ pregunta_3.incidencias_1000raciones[0] }} incidencias por cada 1.000 raciones, frente a {{ pregunta_3.incidencias_1000raciones[1] }} de {{ pregunta_3.food_truck[1] }}.

Cómo calculo los ratios. Siempre como cociente de sumas (todo lo cobrado entre todas las raciones), no como media de los ratios de cada turno: así un turno grande pesa más que uno pequeño.

¿Se mantienen las respuestas de la J3? Sí: calculadas solo con la entrega de la J3 salen los mismos tres. La remesa añade una cuarta parte más de turnos, pero las diferencias con el segundo de cada pregunta son tan amplias que unos días más no las cambian. Sin el arreglo del bloque 1, en cambio, los turnos de «Fiesta Uni» o «FIESTA UNIVERSITARIA» se habrían contado como festivales distintos y la pregunta 1 habría salido partida.
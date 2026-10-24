# Memo para la dirección de Rolling Bao

## Qué hemos visto y qué recomendamos
**1.** {{ pregunta_1.festival[0] }} es el festival que menos deja por ración: {{ pregunta_1.ingreso_racion[0] }} €, frente a {{ pregunta_1.ingreso_racion[1] }} € del siguiente.
**Recomendación:** revisar precios y carta en {{ pregunta_1.festival[0] }}. Si no mejora, valorar si compensa ir.

**2.** {{ pregunta_2.cocinero[0] }} es quien más ingredientes gasta: {{ pregunta_2.kg_100raciones[0] }} kg por cada 100 raciones, frente a {{ pregunta_2.kg_100raciones[1] }} kg del siguiente.
**Recomendación:** revisar las porciones con {{ pregunta_2.cocinero[0] }} y unificar las recetas.

**3.** {{ pregunta_3.food_truck[0] }} es el truck con más incidencias: {{ pregunta_3.incidencias_1000raciones[0] }} por cada 1.000 raciones, frente a {{ pregunta_3.incidencias_1000raciones[1] }} del siguiente.
**Recomendación:** hacer una revisión técnica de {{ pregunta_3.food_truck[0] }} antes del próximo festival.

**4.** {{ pregunta_4.festival[0] }} es el festival que más rinde: {{ pregunta_4.eur_hora_abierta[0] }} € por hora abierta. Su mejor hora son las {{ pregunta_4.mejor_hora[0] }}.
**Recomendación:** reforzar el personal de {{ pregunta_4.festival[0] }} hacia las {{ pregunta_4.mejor_hora[0] }} y negociar más horas allí. Darle conexión al truck, para que sus ventas lleguen a tiempo.

## Qué no sabemos todavía
- La pregunta 4 se basa en un solo día. Con más días, el ranking podría cambiar.
- {{ pregunta_4.festival[0] }} abrió menos horas que otros. No sabemos si mantendría su ritmo con un horario más largo.
- Las incidencias cuentan turnos con algún problema, no su gravedad. Una avería y una devolución pesan igual.
- Hemos corregido datos. Suponemos que «Fiesta Uni» es Fiesta Universitaria; habría que confirmarlo con los cocineros.

## Cómo se ha hecho
- Los datos llegan a un lakehouse en tres capas: bronce (tal cual llegan) → plata (limpios) → oro (respuestas). Bronce no se toca nunca.
- Problema de calidad: la entrega del 25 de junio traía el festival mal escrito («Fiesta Uni», «ROCK NA VILA»…). Se corrige en plata (`stg_parte`) con una clave normalizada y una tabla de equivalencias (seed `equivalencias_festival.csv`).
- Test que lo vigila: `festival_en_calendario` comprueba que cada turno del parte existe en el calendario. Si llega un nombre nuevo, se pone rojo y para todo hasta que alguien lo revise.
- El truck sin cobertura se trata contando cada venta por la hora del pedido (`ts_evento`), no por la de llegada al servidor.
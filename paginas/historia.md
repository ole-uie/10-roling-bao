# Fiesta Universitaria vende más raciones que nadie y gana como los más pequeños: para ganar como la mediana de los otros siete festivales hay que subir la ración de {{ historia_precio_objetivo.precio_hoy[0] }} € a {{ historia_precio_objetivo.precio_objetivo[0] }} € (o a {{ historia_precio_objetivo.precio_objetivo[1] }} €, suponiendo un 20 % menos de ventas)
Fiesta Universitaria es el festival donde Rolling Bao vende más raciones ({{ historia_rentabilidad.raciones[0] }}), pero las cobra a {{ historia_rentabilidad.precio_racion[0] }} €, con casi el mismo coste de producción que los demás: deja {{ historia_rentabilidad.margen_racion[0] }} € por ración frente a entre {{ historia_rentabilidad.margen_racion[1] }} € y {{ historia_rentabilidad.margen_racion[7] }} € en el resto, y su margen total ({{ historia_rentabilidad.margen[0] }} €) queda entre los más bajos. Para que gane como la mediana de los otros siete festivales ({{ historia_precio_objetivo.margen_objetivo[0] }} €), proponemos subir la ración, antes de confirmar la próxima edición, a {{ historia_precio_objetivo.precio_objetivo[0] }} € (o a {{ historia_precio_objetivo.precio_objetivo[1] }} €, suponiendo un 20 % menos de ventas).
```grafico
titular: Fiesta Universitaria vende más que nadie y gana como los más pequeños
modelo: historia_rentabilidad
barras: festival → margen
destacar: Fiesta Universitaria
orden: desc
referencia: historia_precio_objetivo.margen_objetivo · mediana de los otros siete
```
```grafico
tipo: histograma
titular: Ningún turno de Fiesta Universitaria se acerca al margen del resto
modelo: historia_turnos
columna: margen_racion
tramo: 0.5
```

La conclusión no sale de un error de datos: al limpiar el parte, el precio por ración de Fiesta Universitaria no cambia ({{ historia_contraste.racion_sin_limpiar[0] }} € antes y {{ historia_contraste.racion_limpio[0] }} € después). El detalle está en «Cómo se construyó la historia».

## Qué proponemos

1. **Subir el precio de la ración en Fiesta Universitaria a {{ historia_precio_objetivo.precio_objetivo[0] }} € (precio A) y comprobar en los próximos festivales si afecta a las ventas.** La dirección decide el precio antes de confirmar la próxima edición; el equipo de datos compara las raciones vendidas con las de esta edición en cuanto llegue el parte.
2. **Averiguar por qué se cobra la mitad** (un precio para estudiantes, un menú distinto o un precio máximo fijado por el organizador), revisando la carta y el contrato con el organizador. La dirección, antes de fijar el precio nuevo: si el organizador limita el precio, la acción 1 se negocia con él.

## Qué no sabemos todavía

- **Por qué se cobra la mitad.** Un precio para estudiantes, un menú distinto o un límite del organizador son hipótesis: el parte no recoge la carta ni los precios.
- **Cuántas ventas se perderían al subir el precio.** El precio B supone un 20 % menos de ventas; es un supuesto, no un dato.
- **Los costes son supuestos.** Ingredientes a 6 €/kg, 5 min de trabajo por ración para cualquier cocinero, salario mínimo y un 33 % aproximado de Seguridad Social. No incluyen costes fijos: canon o licencia del festival, carrito, transporte ni gas.
- **El periodo es corto.** Del {{ historia_terreno.desde[0] }} al {{ historia_terreno.hasta[0] }}, en dos entregas: con menos de dos meses no sabemos si pasa igual en otras épocas del año.

## La misma historia para cada audiencia

- **Comité de dirección (5 segundos):** «Fiesta Universitaria vende más que nadie y gana como los más pequeños: hay que subir la ración a {{ historia_precio_objetivo.precio_objetivo[0] }} € para conseguir el margen mediano de los otros festivales».
- **Quien decide el precio (1 minuto):** «Subiendo la ración de {{ historia_precio_objetivo.precio_hoy[0] }} € a {{ historia_precio_objetivo.precio_objetivo[0] }} €, Fiesta Universitaria ganaría como la mediana de los otros siete festivales ({{ historia_precio_objetivo.margen_objetivo[0] }} €)». Acción 1: subir el precio y medir las ventas en los próximos festivales. Acción 2: revisar la carta y el contrato con el organizador antes de fijarlo.
- **Equipo de datos (5 minutos):** «Margen por festival, del {{ historia_terreno.desde[0] }} al {{ historia_terreno.hasta[0] }}»: parte diario limpio ({{ stg_parte.filas }} turnos), ingredientes a 6 €/kg y 5 min de trabajo por ración a 12,70 €/h; objetivo = mediana del margen de los otros siete festivales (`historia_rentabilidad`, `historia_precio_objetivo`).

# Cómo se construyó la historia

La portada cuenta el destino. Aquí queda el viaje: la decisión que hay detrás, lo que buscamos en los datos y lo que dejamos fuera.

## Paso 1 · De tema a decisión

| Nivel | En Rolling Bao | Qué obliga a hacer |
|---|---|---|
| Tema | «Lo que deja cada festival» | Nada: admite cualquier gráfico |
| Pregunta | «¿Qué festival deja menos por ración, y por qué?» | El ingreso por ración de cada festival y una base de comparación: el resto de festivales |
| Decisión | «¿Debería la dirección de Rolling Bao subir el precio de la ración en Fiesta Universitaria antes de confirmar la próxima edición?» | Quién (la dirección), qué (subir el precio de la ración) y cuándo (antes de confirmar la próxima edición) |

**La prueba:** después de leer la portada, la dirección sube o no el precio de la ración en Fiesta Universitaria antes de confirmar la próxima edición.

## Paso 2 · Qué se mueve en los datos

### 2a · El terreno: el parte de Rolling Bao tal cual

```cifras
{{ historia_terreno.turnos[0] }} | turnos en el parte limpio
{{ historia_terreno.raciones[0] }} | raciones servidas
{{ historia_terreno.facturacion[0] }} | euros cobrados
{{ historia_terreno.festivales[0] }} | festivales
```

```grafico
titular: Ingreso por ración de cada festival, {{ historia_terreno.desde[0] }}–{{ historia_terreno.hasta[0] }}
modelo: pregunta_1
barras: festival → ingreso_racion
orden: desc
```

Siete festivales cobran entre {{ pregunta_1.ingreso_racion[1] }} € y {{ pregunta_1.ingreso_racion[7] }} € por ración. Uno se queda en {{ pregunta_1.ingreso_racion[0] }} €: {{ pregunta_1.festival[0] }}.

```grafico
tipo: linea
titular: Ingreso por ración, semana a semana: Fiesta Universitaria y el resto
modelo: historia_semanas
x: semana
y: fiesta_universitaria, resto
leyenda: Fiesta Universitaria, resto de festivales
```

Las dos líneas son planas: no hay una semana que se separe. La diferencia entre Fiesta Universitaria y el resto está ahí desde la primera semana hasta la última.

```grafico
tipo: histograma
titular: Ingreso por ración de cada turno
modelo: historia_turnos
columna: eur_racion
tramo: 0.5
```

El reparto tiene dos grupos: la mayoría de los turnos cobra entre 8 y 10 € por ración, y un grupo aparte se queda alrededor de 4 €. La media de todos los turnos no describe a ninguno de los dos.

### 2b · El disparador: cuánto deja cada ración

Al restar lo que cuesta producir cada ración, la diferencia ya no es solo de precio: es de lo que se gana. **Qué costes incluimos**, los mismos por ración en todos los festivales:

- **Ingredientes:** los kg que apunta el parte, a 6 €/kg.
- **Mano de obra:** 5 min por ración (tomar el pedido, preparar los ingredientes, cocinar, emplatar y cobrar) a 12,70 €/h: 9,55 €/h brutos de salario mínimo más un 33 % de Seguridad Social de empresa.

```grafico
titular: Fiesta Universitaria vende más raciones que nadie y deja {{ historia_rentabilidad.margen[0] }} € de margen
modelo: historia_rentabilidad
barras: festival → margen
destacar: Fiesta Universitaria
orden: desc
referencia: historia_precio_objetivo.margen_objetivo · mediana de los otros siete
```

```grafico
tipo: histograma
titular: Margen por ración de cada turno
modelo: historia_turnos
columna: margen_racion
tramo: 0.5
```

Los turnos de Fiesta Universitaria forman un grupo aparte, muy por debajo del resto: ningún turno de los otros festivales se acerca a ellos.

```grafico
tipo: calor
titular: Margen total por festival y semana
modelo: historia_margen_semana
filas: festival
columnas: semana
valor: margen
destacar: Fiesta Universitaria
orden: desc
```

Semana a semana, Fiesta Universitaria deja lo mismo que los festivales pequeños, aunque mueve más raciones que ninguno.

**El hallazgo:** Fiesta Universitaria deja {{ historia_rentabilidad.margen_racion[0] }} € por ración, frente a entre {{ historia_rentabilidad.margen_racion[1] }} € y {{ historia_rentabilidad.margen_racion[7] }} € en los otros siete festivales. Producir una ración le cuesta casi lo mismo que a los demás ({{ historia_rentabilidad.coste_racion[0] }} €; las pequeñas diferencias entre festivales vienen de qué cocineros trabajan en cada uno): la diferencia está en el precio, {{ historia_rentabilidad.precio_racion[0] }} € frente a {{ pregunta_1.ingreso_racion[1] }} € o más. Por eso, aunque es donde más raciones se venden ({{ historia_rentabilidad.raciones[0] }}), su margen total ({{ historia_rentabilidad.margen[0] }} €) queda entre los más bajos. Por qué cobra la mitad no lo sabemos: un precio para estudiantes o un límite del organizador son hipótesis, porque el parte no recoge la carta ni los precios.

### 2c · Qué lo puede explicar

- **Anomalía:** sí. Fiesta Universitaria deja {{ historia_rentabilidad.margen_racion[0] }} € por ración cuando los otros siete festivales dejan entre {{ historia_rentabilidad.margen_racion[1] }} € y {{ historia_rentabilidad.margen_racion[7] }} €, con el mismo coste por ración.
- **Cambio significativo:** no. La diferencia es la misma las ocho semanas, del {{ historia_terreno.desde[0] }} al {{ historia_terreno.hasta[0] }}: no hay tendencia ni quiebre. Con menos de dos meses de datos no podemos saber si pasa también en otras épocas del año.
- **Fuerzas del mercado:** posible. El público universitario puede gastar menos, o el organizador puede fijar precios máximos. Es una hipótesis: no tenemos datos del festival ni de la competencia.
- **Iniciativas propias:** posible. Un precio o un menú de estudiante decidido por Rolling Bao lo explicaría. Es una hipótesis: el parte no recoge precios ni promociones. Es lo primero que la dirección puede comprobar.

## Paso 3 · Qué datos entran y cuáles se quedan fuera

| Dato candidato | ¿Pasa el filtro? | Dónde se usa |
|---|---|---|
| Ingreso por ración de cada festival (pregunta 1) | Sí: es el precio que la dirección decide subir | Paso 2a; portada, titular |
| Margen por festival: total, por ración y por semana | Sí: demuestra que Fiesta Universitaria no solo cobra poco, sino que gana poco, con el mismo coste por ración | Paso 2b; portada, gráfico-mensaje |
| Precio objetivo para llegar a la mediana, con y sin un 20 % menos de raciones | Sí: dice cuánto subir y si aguanta perder clientes | Portada, «Qué proponemos» |
| Kg de ingredientes por cocinero (pregunta 2) | No: es un problema de cocina, no cambia el precio de un festival | Fuera |
| Incidencias por food truck (pregunta 3) | No: los siete trucks trabajan en Fiesta Universitaria y no explican su precio | Fuera |
| € por hora abierta y horas de pedido (pregunta 4) | No: es un solo día (27/06) y Fiesta Universitaria no está en él | Fuera |
| Costes fijos (canon o licencia, carrito, transporte) | No: no tenemos datos, y un coste igual por festival no cambia la comparación | Fuera; se dice en «Qué no sabemos todavía» |

### Sin limpiar frente a limpio

```grafico
titular: Sin limpiar, Feria Gastro parecería el peor festival; Fiesta Universitaria no cambia
modelo: historia_contraste
barras: festival → racion_sin_limpiar, racion_limpio
leyenda: tal como llegan, limpios
```

Tal como llegan, a Fiesta Universitaria le faltan turnos escritos de otra forma («Fiesta Uni», «FIESTA UNIVERSITARIA»): pasa de {{ historia_contraste.turnos_sin_limpiar[0] }} a {{ historia_contraste.turnos_limpio[0] }} turnos al limpiar. Pero su ingreso por ración es el mismo: {{ historia_contraste.racion_sin_limpiar[0] }} € frente a {{ historia_contraste.racion_limpio[0] }} €. Lo que sí engañaría es Feria Gastro: con las raciones imposibles sin corregir saldría a {{ historia_contraste.racion_sin_limpiar[6] }} € por ración y parecería el peor festival. La conclusión aguanta porque sale de los datos limpios.

### El eje cortado

```grafico
tipo: eje
titular: Mismos datos, dos lecturas: el eje manda
modelo: historia_rentabilidad
barras: festival → coste_racion
corte: 2.1
```

Con el eje cortado, Indie Ría parecería mucho más caro de producir que Mercado Nocturno, cuando la diferencia es de unos céntimos y se explica por qué cocineros trabajan en cada festival. Por eso todas las barras de la portada empiezan en cero.

> **Alcance.** Parte diario de Rolling Bao, del {{ historia_terreno.desde[0] }} al {{ historia_terreno.hasta[0] }}, en dos entregas (15 y 25 de junio): {{ stg_parte.filas }} turnos tras quitar duplicados, con los festivales mal escritos unificados con una tabla de equivalencias y las raciones imposibles sustituidas por la mediana de su festival. Los importes son los que apunta el parte.

> **Supuestos de coste.** Ingredientes a 6 €/kg (supuesto de la dirección, del cuaderno de la J3). Mano de obra: 5 min de trabajo por ración a 9,55 €/h brutos de salario mínimo más un 33 % de Seguridad Social de empresa (aproximado, contrato temporal), es decir, 12,70 €/h. Los cuatro valores están en un solo fichero del lakehouse, `supuestos_coste.csv`. No incluye costes fijos: canon o licencia del festival, carrito, transporte ni gas.

## Las cinco comprobaciones

- **Hay una decisión detrás:** la dirección decide antes de confirmar la próxima edición si sube la ración de Fiesta Universitaria a {{ historia_precio_objetivo.precio_objetivo[0] }} € (precio A) o a {{ historia_precio_objetivo.precio_objetivo[1] }} € (precio B, si se perdiera un 20 % de ventas).
- **El titular afirma:** leído sin gráficos, dice qué pasa (vende más que nadie y gana como los más pequeños) y qué hacer (subir la ración de {{ historia_precio_objetivo.precio_hoy[0] }} € a {{ historia_precio_objetivo.precio_objetivo[0] }} €).
- **Cada cifra tiene fuente:** todas salen del lakehouse con marca (`fact_turnos` y los modelos `historia_*`); el periodo está en el alcance y los supuestos de coste en `supuestos_coste.csv`, explicados en el Paso 3.
- **La evidencia es diversa:** dos pruebas en la misma dirección en la portada (barras del margen total e histograma del margen por turno), más la línea por semana y el mapa de calor en el Paso 2.
- **Lo que no cuadra se dice:** los festivales mal escritos y las raciones imposibles (con el contraste: Fiesta Universitaria no cambia, Feria Gastro sí), los costes supuestos y sin costes fijos, las ventas perdidas como supuesto, el periodo corto y el porqué del precio como hipótesis.

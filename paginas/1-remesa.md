# 1 · La remesa nueva

Qué llegó. La entrega del 25 de junio (`fecha_carga=2026-06-25`) traía la columna festival escrita a mano desde el móvil: en mayúsculas («ROCK NA VILA»), sin tilde («Jazz Jardin»), abreviada («Fiesta Uni») o con el año («Electro-Puerto 2026»). La entrega anterior venía bien.

Cómo lo descubrí. `dbt build` puso rojo el test de valores aceptados de `festival`. Con `dbt show` comparé bronce por `fecha_carga`: el error solo está en la entrega nueva y ya venía así en el CSV. El resto de columnas estaba limpio.

Cómo lo arreglé. En el modelo de plata `stg_parte`, antes de cualquier cálculo, cada festival pasa por dos filtros:

1. Una clave normalizada (sin tildes, en minúsculas, sin signos ni año) corrige sola las variantes de escritura.
2. Una lista de equivalencias recoge lo que la clave no resuelve, como «Fiesta Uni».

Lo desconocido no se corrige a ciegas: el test vuelve a ponerse rojo y una persona decide.

Por qué en plata y no en bronce. Bronce es la prueba de lo que nos mandaron: si lo corrijo ahí, pierdo el rastro de qué venía mal y ya no puedo comprobar el arreglo. Además, corregir el CSV a mano solo arregla esta entrega; la regla en plata se aplica sola a todas las que lleguen, y cada `dbt build` la vuelve a ejecutar desde el dato original.

Resultado. Tras el arreglo, plata conserva los {{ stg_parte.filas }} turnos recibidos, todos con su festival oficial.
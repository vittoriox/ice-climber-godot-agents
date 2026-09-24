# Inventario de mecánicas

| ID | Mecánica | Comportamiento | Datos físicos | Interacción | Fuente / confianza |
|---|---|---|---|---|---|
| M-01 | Escalada | ocho pisos; romper → abrir hueco → saltar → avanzar | velocidad, aceleración, gravedad y salto exactos: NO DETERMINADO | escenario vertical | síntesis + manual · VERIFICADO |
| M-02 | Golpe de martillo | rompe hielo desde abajo; un bloque por golpe es regla del prototipo corregido, no del ROM medido | frames activos: NO DETERMINADO | jugador ↔ bloque | planos + HTML · PROBABLE |
| M-03 | Hielo rompible | pasa de intacto a hueco; puede ser rellenado por Topi | tamaño de bloque exacto: NO DETERMINADO | cambia ruta y colisión | manual + captura · VERIFICADO |
| M-04 | Hielo sólido | no se rompe; obliga a otra ruta | dimensiones por piso: NO DETERMINADO | colisión estática | manual · VERIFICADO |
| M-05 | Superficie móvil | tipo de piso/plataforma móvil; patrón exacto no medido | velocidad: NO DETERMINADO | modifica posición de apoyo | manual · VERIFICADO |
| M-06 | Nube | plataforma temporal/móvil según documentación | velocidad y duración: NO DETERMINADO | apoyo sin romper | manual · VERIFICADO |
| M-07 | Hielo deslizante | desplaza al jugador aun sin dirección | magnitud/dirección: NO DETERMINADO | altera control horizontal | planos previos · PROBABLE |
| M-08 | Gravedad y salto | el jugador cae y puede alcanzar pisos | valores del ROM: NO DETERMINADO | colisión al aterrizar | captura + HTML · PROBABLE |
| M-09 | Bordes | salir por un borde y reaparecer por el contrario | límite exacto: NO DETERMINADO | continuidad horizontal | síntesis · PROBABLE |
| M-10 | Cámara | acompaña el ascenso y mantiene zona visible | ventana 256×240: VERIFICADO; scroll exacto: NO DETERMINADO | deja atrás la parte baja | capturas · PROBABLE |
| M-11 | Topi repara | detecta hueco, vuelve a cueva, trae hielo y rellena | duración/velocidad: NO DETERMINADO | reintroduce colisión | manual + síntesis · VERIFICADO |
| M-12 | Nitpicker | ave cruza la zona y amenaza trayectorias | velocidad/hitbox: NO DETERMINADO | contacto daña; martillo puede derrotarlo | manual + síntesis · PROBABLE |
| M-13 | Polar Bear | aparece tras tardanza y empuja la pantalla arriba | umbral/velocidad: NO DETERMINADO | presión temporal | manual + síntesis · PROBABLE |
| M-14 | Icicle | se forma y cae desde plataformas | aviso/tiempo/tamaño: NO DETERMINADO | contacto daña | planos + guía · PROBABLE |
| M-15 | Daño | contacto o caída resta vida; respawn futuro independiente | invulnerabilidad: NO DETERMINADO | afecta al jugador receptor | planos · PROBABLE |
| M-16 | Bonus | tras ocho pisos; verduras, maíz, tiempo y Condor; termina por Condor, caída o tiempo | límite 40 s documentado | suma bonus y cambia estado | manual + planos · VERIFICADO |
| M-17 | Puntuación | bloque montaña×10; Topi 400; Nitpicker 800; bonus según tabla | variantes deben citar fuente | score individual y futura suma cooperativa | historial + guía · PROBABLE |
| M-18 | Vidas | vidas y extra de primer maíz documentadas; valor inicial no confirmado | inicial: NO DETERMINADO | game over al agotarse | planos · PROBABLE |
| M-19 | Dos jugadores futuro | ambos interactúan con el mismo escenario | sincronización: NO DETERMINADO | enemigos aceptan cualquiera | requisito futuro · OBJETIVO |

Los valores HTML `180`, `330` y `500` describen el prototipo, no el juego de referencia.

## Evidencia dinámica repetida

El probe `probe.mjs` arrancó Mountain 01, ejecutó diez secuencias de derecha + salto y produjo `out/003-scripted-play.png` junto con volcados de RAM. La captura muestra respuesta a entradas y huecos visuales tras la secuencia. Esto confirma que la observación es reproducible; no fija todavía hitboxes ni tiempos de invulnerabilidad.

La prueba controlada y sus límites están registrados en [`CONTROLLED_PROBES.md`](./CONTROLLED_PROBES.md). En particular, el experimento de B no debe interpretarse todavía como confirmación de qué bloque se rompe: dos ejecuciones con el mismo arranque no produjeron una diferencia de píxeles aislable en la ventana probada.

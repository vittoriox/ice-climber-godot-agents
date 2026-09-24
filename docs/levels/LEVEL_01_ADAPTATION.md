# Registro de adaptación Nivel 1 → Web 16:9

| Cambio | ORIGINAL | ADAPTADO | MOTIVO | IMPACTO | CONFIANZA |
|---|---|---|---|---|---|
| Ventana | 256×240, 4:3 | 1280×720 candidato, 16:9 | destino móvil landscape | cambia marco visual; no cambia distancias críticas | PROBABLE |
| Anchura jugable | ventana original 4:3 | área central `960×720` con relación 4:3; laterales de `160 px` por lado | evitar estirar mapa | jugabilidad conservada; espacio visual separado | PROBABLE |
| Coordenadas desconocidas | algunas no extraídas | permanecen `null` y `TRACE_ONLY` | no inventar | requiere extracción posterior antes de construir | VERIFICADO como limitación |
| Safe area | no documentada | rectángulo interior propuesto | legibilidad móvil | HUD/amenazas no quedan bajo notch/controles | PROBABLE |
| Controles | no existen en ROM como tacto | izquierda/derecha a izquierda; salto/ataque a derecha | teléfono | ocupa espacio visual no jugable | OBJETIVO del usuario |
| Player 2 | no inferido del mapa original | spawn reservado y `players[]` | futuro multijugador | no modifica Nivel 1 ahora | OBJETIVO del usuario |
| Network | no existe | `session_id`/`game_id` nulos; servidor futuro | preparar evolución | sin sincronización actual | VERIFICADO como fuera de alcance |

No se añadieron plataformas, enemigos ni trampas para llenar laterales. El cambio es una propuesta y requiere playtest antes de convertirse en contrato de implementación.

## Estado

La propuesta queda aprobada como base de trabajo documental. La aprobación no fija la adaptación 16:9 como definitiva: cualquier ajuste posterior deberá registrarse aquí y en el JSON correspondiente antes de implementarse.

## Decoración futura de laterales

Los laterales visuales no jugables podrán utilizarse posteriormente para mostrar animaciones ambientales o estados del jugador, por ejemplo:

- jugador en estado normal;
- jugador con poca vida;
- reacción al daño, caída o recuperación;
- animaciones decorativas relacionadas con el progreso.

Estas imágenes o animaciones serán presentación secundaria. No deberán modificar la física, las colisiones, la cámara, la dificultad ni el área jugable. Su inclusión queda pendiente de la fase de assets y UI.

# Auditoría del prototipo HTML

Fuentes comparadas: `main/src/game.js`, `main/src/index.html`, `main/src/styles.css`, `main/tests/`; síntesis ROM `docs/03-investigacion/revision-1/SINTESIS.md`; capturas `m01-overview.png`, `m01-start.png`. El HTML es autoridad únicamente para “qué hace hoy”.

| Sistema | HTML actual | Evidencia verificada | Estado | Conservar / reconstruir |
|---|---|---|---|---|
| Movimiento horizontal | velocidad fija `180`, A/D y tacto | el movimiento existe, valor original NO DETERMINADO | NO VERIFICADO | conservar separación de entrada; reconstruir física |
| Aceleración/desaceleración | no existe; cambia a velocidad fija | NO DETERMINADO | INCOMPLETO | reconstruir como parámetro verificable |
| Salto | impulso `330`, solo con suelo | salto existe; fuerza exacta NO DETERMINADA | PARCIALMENTE CORRECTO | conservar intención; medir en Godot |
| Gravedad | `500` en Arcade | gravedad existe; valor exacto NO DETERMINADO | PARCIALMENTE CORRECTO | conservar concepto, no valor |
| Caída | colisión con límites; no ciclo de vida | caer puede costar vida según reglas de referencia | INCOMPLETO | reconstruir muerte/respawn |
| Colisiones | suelo, repisas y bloques estáticos | pisos rompibles/irrompibles y huecos | INCORRECTO | rehacer por tipo de superficie |
| Plataformas | suelo + 3 repisas | montaña tiene ocho pisos y otros tipos | INCORRECTO | usar datos de nivel |
| Rompibles | tres bloques; martillo destruye por proximidad | romper piso abre ruta | INCORRECTO | modelar celdas/segmentos rompibles |
| Superficies especiales | ninguna real | hielo sólido, móvil, nube, pilares | INCOMPLETO | reconstruir estados y colisión |
| Cámara | `RESIZE`, sigue jugador | progreso vertical por pisos | PARCIALMENTE CORRECTO | conservar seguimiento; definir límites |
| Progresión vertical | 3 saltos prefijados | 8 pisos antes del bonus | INCORRECTO | reconstruir ocho pisos |
| Enemigos | no hay entidades funcionales | Topi, Nitpicker, Polar Bear, Icicle | INCOMPLETO | separar entidades y patrones |
| Comportamiento enemigo | no existe | patrones distintos por enemigo | INCOMPLETO | reconstruir con estados |
| Peligros | ningún peligro real | contacto, caída, Icicle y Polar Bear | INCOMPLETO | definir daño por fuente |
| Trampas | no existen | huecos, hielo y presión temporal | INCOMPLETO | no inferir trampas adicionales |
| Daño | no implementado | contacto puede quitar vida | INCOMPLETO | sistema de daño independiente por jugador |
| Vidas | no implementadas | vidas y maíz extra están documentados | INCOMPLETO | reglas y persistencia por jugador |
| Puntuación | no implementada | tabla de puntos existente en planos | INCOMPLETO | individual; cooperativa futura |
| Victoria | no implementada | cima → bonus; Condor termina bonus | INCOMPLETO | estados explícitos |
| Derrota | no implementada | vidas agotadas/caída/tiempo según estado | INCOMPLETO | separar muerte, respawn y game over |
| Transición niveles | no implementada | ocho pisos → bonus → siguiente montaña | INCOMPLETO | cargador de datos |
| Tacto | 5 controles, posiciones por viewport | distribución móvil solicitada; no autoridad sobre ROM | PARCIALMENTE CORRECTO | conservar zonas, no lógica |
| Teclado | A/D, J/W, K/S, N/M | manual usa controles distintos; HTML es adaptación | PARCIALMENTE CORRECTO | capa de entrada configurable |
| Interfaz | estado LISTO/PAUSA y controles | HUD, vidas y score requeridos | INCOMPLETO | reconstruir HUD |
| Audio | ninguno | sonidos del original no se trasladan | INCOMPLETO | planificar, no inventar |
| Sistema de niveles | constantes en JS | nivel debe ser datos cargables | INCORRECTO | JSON + LevelLoader |

Conclusión: se conserva conocimiento de entrada, viewport y pruebas, no el código JavaScript como base de fidelidad.

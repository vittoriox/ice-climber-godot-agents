# Sistema de coordenadas

## Original

- Origen: esquina superior izquierda de la ventana visible.
- X: aumenta hacia la derecha. Y: aumenta hacia abajo.
- Unidades: píxel lógico de la referencia NES.
- Ventana observada: `256×240`, relación `4:3` — VERIFICADO por las capturas.
- Grid de representación: `8×8` píxeles para no fingir precisión menor que la observación visual. El tamaño interno exacto de cada bloque es NO DETERMINADO.
- Scroll: las capturas muestran ventanas sucesivas del mismo nivel; `screen_y` y `world_y` no se mezclan.

## Medición nueva del ROM

La captura nativa confirma bandas visuales de 8×8 píxeles con separación vertical de 48 píxeles por franja visible. En `m01-overview.png` se observan bandas en `screen_y=24,72,120,168,216`; en `m01-start.png`, `screen_y=142,190`. Estas son coordenadas de pantalla verificadas, no todavía coordenadas de mundo ni una declaración automática de colisión.

## Regla de precisión

Las coordenadas de límites de la ventana son verificadas. Las posiciones exactas de cada bloque, spawn, enemigo y objetivo no están extraídas de RAM/mapa binario en la evidencia disponible; se representan como `null` con `coordinate_status: NO DETERMINADO`. No se sustituyen por proporciones.

## Web 16:9

- Resolución lógica recomendada: `1280×720` como candidato inicial, con viewport adaptable y escala entero/letterbox cuando el dispositivo lo permita. Es una recomendación, no dato del original.
- Playable area: `x=160..1120`, `960×720`; conserva una relación `4:3` dentro del lienzo `1280×720`. La transformación horizontal no estira elementos.
- Visual area: `x=0..160` y `x=1120..1280`; bandas laterales disponibles para decoración, estados animados del jugador, paredes, iluminación y profundidad sin colisión.
- Safe area: rectángulo interior que mantiene jugador, ruta crítica, enemigos, trampas, objetivo y HUD fuera de las zonas de controles y recortes.
- Conversión: `world_y` y distancias críticas se conservan; `world_x` se centra en el playable area. El espacio extra se declara visual hasta que un playtest autorice ampliar jugabilidad.

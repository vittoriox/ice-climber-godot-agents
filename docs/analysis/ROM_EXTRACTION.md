# Extracción reproducible del ROM · Montaña 1

## Fuente

- ROM: `/Users/vitto/Downloads/Ice Climber (USA, Europe, Korea) (En).nes`
- Tamaño: `24592` bytes
- SHA-256: `491898c9b0bf6b242d08bb0841141ca404f8e54383a1814cdb7feab451da8701`
- Emulador usado: `jsnes` del laboratorio anterior.
- Captura: `.runtime/nes-lab/capture-mountains.mjs`, ejecutada el 2026-09-23.
- Ventana nativa: `256×240`.
- `m01-overview.png` SHA-256: `af18d76ad94f847a7cc536832370b7dac4734a3684588fe59accde58fa5b576a`.
- `m01-start.png` SHA-256: `3045774e03c74d00a735c70b43e0e1783941ba688401e3bb132e26aa2cde22fc`.

## Método

Se arrancó la ROM, se seleccionó Mountain 01 y se capturaron frames a 20 y 100 frames después de START, además de un estado inactivo a 600 frames. Se midieron bandas horizontales y patrones visuales en una cuadrícula de 8×8 píxeles. `#` indica tile visualmente lleno, `+` parcialmente ocupado y `.` ausencia visual en esa banda; esto no declara por sí solo colisión.

## Resultado verificable

Las franjas de piso aparecen separadas aproximadamente 48 píxeles en pantalla (`y=24,72,120,168,216` en `m01-overview.png`; `y=142,190` en `m01-start.png`). La primera fila de cada franja es continua; las filas inferiores contienen patrones parciales y huecos. El patrón exacto se conserva en `level_01_original.json` como firma de pantalla.

## Límite

La captura permite reconstruir geometría visual y relación de scroll. Todavía no prueba qué píxel exacto es sólido, rompible, decorativo o parte de una entidad. Para convertir cada tile en colisión hay que correlacionar la firma con eventos de golpe, caída y paso en el emulador; ese trabajo sigue siendo necesario antes de una implementación fiel.

## Prueba dinámica existente

`probe.mjs` ejecuta una secuencia de desplazamientos y saltos y deja `out/003-scripted-play.png` y volcados de RAM. Esta evidencia confirma que la escena responde a entradas y que aparecen huecos visuales, pero no basta para asignar cada hueco a una coordenada de mundo sin un probe controlado por evento.

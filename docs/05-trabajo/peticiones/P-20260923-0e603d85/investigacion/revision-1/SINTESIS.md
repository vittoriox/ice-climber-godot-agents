# Síntesis de investigación · P-20260923-0e603d85 · revisión 1

## Respuestas

- respondida · ¿Qué comportamiento del Nivel 1 está verificado, qué queda incierto y cómo se representa sin inventar datos para una futura migración a Godot Web 16:9? · evidencia: docs/03-investigacion/revision-1/SINTESIS.md#L1 · fecha: 2026-09-23

La evidencia confirma el bucle de ocho pisos, romper para abrir ruta, salto, tipos de suelo, amenazas y bonus; no confirma todas las coordenadas, hitboxes, velocidades, frames, tiempos internos ni el mapa binario completo. Esos campos se marcarán `NO DETERMINADO`, `PROBABLE` o `VERIFICADO` sin inventar valores. También se contrastan `.runtime/nes-lab/mountains-out/m01-overview.png#captura`, `main/src/game.js#LEVEL` y el manual oficial `https://www.nintendo.co.jp/clv/manuals/en/pdf/CLV-P-NAAUE_en.pdf`.

## Decisión para el triaje definitivo

La salida será una unidad documental separada, adaptada al meta-repo: análisis y planos específicos bajo la carpeta de esta unidad; `main/` queda protegido y solo lectura. La adaptación 16:9 será propuesta trazable, no una deformación del original. No se genera Nivel 2, Godot, networking ni assets definitivos.

## Conclusiones estables que se promocionan

- El prototipo HTML es evidencia secundaria: sirve para describir el estado actual, no para declarar fidelidad.
- El Nivel 1 debe modelar ocho pisos y el ciclo romper → abrir hueco → saltar → progresar.
- El formato de nivel debe reservar `players[]`, `player_id`, `session_id` y `game_id` sin implementar todavía la red.

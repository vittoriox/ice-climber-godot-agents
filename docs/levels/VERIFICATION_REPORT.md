# Informe de verificación

Fecha: 2026-09-23. Herramienta: `tools/verify_level_01.py`.

| Check | Resultado |
|---|---|
| Elementos originales presentes en JSON | PASS: 14/14 |
| Coordenadas no inventadas | PASS: desconocidas como `null` |
| Símbolos definidos en leyenda | PASS |
| Adaptación rastreable | PASS: cada objeto web tiene `source_id` |
| Cambios documentados | PASS |
| HTML no usado como autoridad | PASS |
| Incertidumbres marcadas | PASS |
| Solo Nivel 1 | PASS |

| Extracción ROM | PASS: ROM identificado por SHA-256; 19 firmas visuales 8×8 conservadas |
| Prueba dinámica | PASS: `probe.mjs` produce captura y RAM tras secuencia reproducible; el aislamiento del efecto de B queda inconcluso y documentado |

El verificador comprueba IDs, símbolos y trazabilidad. La extracción añade firmas visuales reproducibles, pero no demuestra todavía qué píxel exacto es sólido o rompible; esa frontera queda marcada como `NO DETERMINADO`.

La revisión de jugabilidad no convierte las respuestas visuales del emulador en valores físicos. La velocidad, aceleración, gravedad, salto, daño, invulnerabilidad, hitboxes y regla exacta del martillo permanecen pendientes de una extracción frame-a-frame correlacionada con RAM y bounding boxes.

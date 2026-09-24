---
unidad: 005-reconstruccion-nivel-1-godot-web
tipo: documentacion
carril: normal
estado: planificada
aprobado: no
actividad: ice-climber-html5
ficheros:
  - nuevo: docs/05-trabajo/005-reconstruccion-nivel-1-godot-web/entrega/**
  - docs/05-trabajo/005-reconstruccion-nivel-1-godot-web/especificacion.md
  - docs/05-trabajo/005-reconstruccion-nivel-1-godot-web/hallazgos.md
peticiones: [P-20260923-0e603d85@1]
actualizado: 2026-09-23
---

# 005 · Especificación verificable del Nivel 1 y preparación futura

## Diseño conversado

- **Decisión:** separar observado, HTML actual y propuesta futura; entregar JSON, planos y documentación dentro de esta unidad.
- **Alternativas descartadas:** editar `main/`; estirar 4:3 a 16:9; inventar coordenadas ausentes.
- **Diseño aprobado por el usuario:** PENDIENTE — el método exige revisión del contrato.
- **Plan listo para despacho:** SÍ — fuentes, SHA, síntesis y capturas localizados.

## Qué

Se documentará el Nivel 1 original con una leyenda, coordenadas y JSON, y una adaptación Web 16:9 trazable que no deforme el mapa. La documentación preparará una futura construcción en Godot Web y una evolución a dos jugadores sin implementar ninguna de las dos.

## Criterios de aceptación

- **R1** — La auditoría clasifica todos los sistemas del HTML y declara coincidencia y reconstrucción futura.
- **R2** — Mecánicas y enemigos tienen fuente, confianza y `NO DETERMINADO` donde falte evidencia.
- **R3** — El Nivel 1 original tiene leyenda única, coordenadas, JSON e IDs únicos; no contiene Nivel 2.
- **R4** — La adaptación 16:9 conserva trazabilidad, separa áreas y documenta cada diferencia.
- **R5** — El plan Godot incluye `players[]`, `player_id`, `session_id` y `game_id`, sin networking todavía.

## Cómo lo pruebas tú

| # | Dónde | Qué haces | Qué deberías ver |
|---|---|---|---|
| 1 | Entrega documental | Abrir `README.md` | Fuentes y niveles de confianza claros |
| 2 | Plano original | Comparar leyenda y JSON | Cada símbolo tiene ID y definición |
| 3 | Plano 16:9 | Compararlo con el original | Cada cambio aparece en el registro |
| 4 | Verificación | Ejecutar `python3 tools/verify_level_01.py` | Checks de símbolos, IDs y trazabilidad en verde |

- **NO debe haber cambiado:** `main/`, planos compilados, HTML, JavaScript y assets existentes.
- **Si algo no cuadra:** abrir un bug o una nueva petición; no corregir silenciosamente.

## Deltas al mapa

- AÑADIDO: paquete documental del Nivel 1 bajo esta unidad.
- MODIFICADO: ninguno de los planos compilados ni el código.
- ELIMINADO: nada.

## Cómo

Se usan Markdown, JSON y un verificador documental local. Las fuentes se leen desde `docs/03-investigacion`, `docs/02-flujos`, `.runtime/nes-lab` y `main/`; la salida vive en `entrega/`. Godot, QR, servidor y multijugador se describen como arquitectura futura, no como código.

## Fuera de alcance

No se modifica `main/`, no se reestructura HTML, no se implementa GDScript, Godot, networking, matchmaking, sincronización, QR real, assets definitivos, audio, Nivel 2 ni niveles posteriores.

## Verificación

- Comando: `python3 tools/verify_level_01.py`

| Caso | Nivel | Referencias | Resultado |
|---|---|---|---|
| Inventario de fuentes | documental | R1-R2 | cada afirmación tiene fuente/confianza |
| JSON original | unitario documental | R3 | IDs y símbolos consistentes |
| Adaptación 16:9 | unitario documental | R4 | cada elemento rastrea un origen |
| Preparación futura | documental | R5 | contrato no depende de un solo jugador |

- **Nivel de test:** verificación documental local; no se requiere E2E porque esta unidad no cambia la aplicación.
- **Criterio portante:** R3 — ningún elemento del plano se acepta sin ID JSON y símbolo definido.
- **Evidencia:** salida del verificador y listado de artefactos.

## Contexto para el constructor

1. Este fichero.
2. `docs/03-investigacion/revision-1/SINTESIS.md`.
3. `docs/02-flujos/planos/planos.json`.
4. `.runtime/nes-lab/mountains-out/`.
5. `main/src/` y `main/tests/`, solo lectura.

## Plan de trabajo

- [ ] 1. Completar auditoría, mecánicas, enemigos, leyenda y coordenadas · _Req: R1-R3_
- [ ] 2. Crear JSON y planos original/16:9 sin inventar valores · _Depende de: 1_
- [ ] 3. Crear adaptación, verificación y plan Godot/multijugador futuro · _Depende de: 2_
- [ ] 4. Ejecutar verificador documental y revisar resultados · _Depende de: 3_
- [ ] 5. PARAR para aprobación del Nivel 1 · _Depende de: 4_

## Reglas

La unidad es documental. `main/` queda protegido; el resultado se adapta a la organización del meta-repo y no crea una segunda fuente de verdad de producto hasta que el Nivel 1 sea aprobado.

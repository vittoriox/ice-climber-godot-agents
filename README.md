# Entrega documental · Nivel 1

Esta carpeta es el proyecto separado `ice-climber-godot-agents`. Contiene la reconstrucción documental del Nivel 1 y la preparación de la futura migración a Godot Web. No contiene todavía un proyecto Godot ni código de networking.

## Orden de lectura

1. `docs/analysis/HTML_AUDIT.md`
2. `docs/analysis/GAME_MECHANICS.md`
3. `docs/analysis/ENEMIES.md`
4. `docs/levels/COORDINATES.md` y `LEGEND.md`
5. `docs/levels/LEVEL_01_ORIGINAL.md` y `docs/levels/LEVEL_01_WEB_16_9.md`
6. JSONs de `levels/reference/` y `levels/web/`
7. `docs/levels/LEVEL_01_ADAPTATION.md`, `VERIFICATION_REPORT.md`
8. `docs/godot/GODOT_MIGRATION_PLAN.md`

## Autoridad

`VERIFICADO` = ingeniería inversa/documentación comprobada. `PROBABLE` = inferencia apoyada por varias observaciones. `NO DETERMINADO` = no se conoce con evidencia suficiente. El HTML solo describe el estado actual.

La revisión profunda usa el ROM local identificado en `docs/analysis/ROM_EXTRACTION.md`; el ROM no se copia a este proyecto.

## Parada

Solo se reconstruye el Nivel 1. No hay Nivel 2, Godot implementado, networking, matchmaking ni assets finales.

## Estado de aprobación

El usuario aprobó la documentación y la revisión actual del Nivel 1 el 2026-09-23. Esta aprobación valida la base documental para continuar más adelante; no convierte todavía la adaptación 16:9 en diseño definitivo ni autoriza la implementación Godot. Las modificaciones de jugabilidad, formato y arquitectura podrán revisarse posteriormente.

La siguiente fase contiene ya un esqueleto Godot 4.x data-first: `project.godot`, `scenes/Main.tscn`, `scripts/LevelLoader.gd` y `scripts/Main.gd`. El preview sólo valida y representa áreas del JSON; no implementa físicas, enemigos, controles táctiles ni networking.

Validado con `/Users/vitto/Documents/Godot_4.7/Godot.app`, versión `4.7.2.stable.official`. El proyecto abrió en modo editor/headless y la escena principal ejecutó sin errores reportados.

El preview técnico ahora incluye un marco de juego 4:3 identificable, HUD de Mountain 01, marcador provisional de jugador, paneles visuales P1/P2, controles táctiles dibujados, leyenda cromática y aviso de coordenadas pendientes. No representa todavía plataformas reales ni gameplay.

Se añadió un jugador provisional `CharacterBody2D` en `scenes/Player.tscn` con representación técnica, movimiento horizontal y salto de prueba. Está limitado al área visual para validar la sensación de escala; no usa aún plataformas, hitboxes ni parámetros físicos extraídos del ROM.

También existe `scenes/PhysicsSandbox.tscn`, un laboratorio aislado con plataformas temporales para validar colisiones del jugador. No forma parte del Nivel 1 y sus posiciones no deben copiarse al JSON de referencia.

El sandbox usa ahora un salto de prueba más alto y plataformas escalonadas alcanzables. Ese ajuste sólo calibra el laboratorio; no fija todavía la fuerza de salto del juego original.

El preview principal incorpora controles táctiles funcionales en las zonas laterales: izquierda, derecha, salto y ataque. El ataque muestra ahora un martillo animado, destello y etiqueta `HAMMER` como feedback. Todavía no rompe bloques ni daña enemigos.

La exportación Web quedó preparada en `export_presets.cfg` con orientación landscape. Para ejecutarla falta instalar la plantilla oficial de exportación Web de Godot 4.7.2, que no viene incluida en la aplicación local.

La exportación Web ya fue generada en `build/web/`. El servidor móvil debe iniciarse con `python3 tools/serve_web.py` para incluir las cabeceras COOP/COEP requeridas por la variante Web con hilos.

Decisión de diseño pendiente de implementación: los laterales visuales 16:9 podrán mostrar animaciones del jugador —estado normal, poca vida y reacciones— sin formar parte del área jugable.

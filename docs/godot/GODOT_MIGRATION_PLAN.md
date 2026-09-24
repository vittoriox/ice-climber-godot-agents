# Plan de migración futura a Godot Web

## Flujo

`level_01_web_16_9.json` → `LevelLoader` → escena de nivel → entidades y colisiones.

## Arquitectura futura

- Nivel raíz `Node2D`; `TileMapLayer` para piezas repetitivas y escenas para objetos con comportamiento.
- Jugadores como `CharacterBody2D`, almacenados en `players[]` con `player_id`, vida, score, estado y spawn.
- Plataformas rompibles, sólidas, móviles y nubes construidas desde el `type` del JSON.
- Enemigos con máquina de estados y objetivo seleccionable entre jugadores.
- `Camera2D` con modo individual y modo cooperativo; política de encuadre queda abierta.
- UI con puntuaciones individuales y posible puntuación cooperativa derivada.
- Laterales visuales desacoplados del mundo jugable para animaciones ambientales o estados del jugador; no deben alterar colisiones ni reglas.
- Entrada desacoplada para teclado y tacto.
- Carga con validación estricta del JSON; ningún valor desconocido se rellena silenciosamente.

## Multijugador futuro, no implementado

Se reservan `players[]`, `player_id`, `session_id` y `game_id`. El servidor futuro coordinará sesión, asignación de teléfonos, estado compartido y sincronización. Muerte/respawn y score serán eventos por jugador. Networking, matchmaking y sincronización quedan fuera de esta fase.

## Web, QR y móvil

La fase posterior debe probar Safari y Chrome móvil, landscape, safe area, escalado, carga, rendimiento, assets comprimidos y servidor propio. El QR codificará URL/sesión; aquí no se implementa.

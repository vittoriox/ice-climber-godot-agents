# LEVEL_01_WEB_16_9 · propuesta de plano

Propuesta de adaptación, no autoridad del ROM. Resolución lógica candidata `1280×720`.

```text
+------------------------------- 1280 -------------------------------+
|  VISUAL  |<----------- PLAYABLE 4:3 ----------- >|  VISUAL  |
|  PANEL   |             SAFE AREA                 |  PANEL   |
| estado   |  [HUD]   P / B / E? · SP1 · ruta · G? | estado   |
| jugador  |                                        | jugador  |
|          |                                        |          |
| controles|                                        |controles |
+----------+----------------------------------------+----------+
 x=0      x=160                                  x=1120   x=1280
                 y=0                                  y=720
```

La zona jugable central mide `960×720`, conservando la relación `4:3` del original sin estirar horizontalmente. Cada lateral mide `160×720` y queda fuera de la jugabilidad. Las franjas superiores pueden alojar estados visuales del jugador; las franjas inferiores reservan controles táctiles (`TA` a la izquierda y `TJ`, `TK` a la derecha). `SP2` queda reservado para el futuro, no se afirma que exista en la referencia.

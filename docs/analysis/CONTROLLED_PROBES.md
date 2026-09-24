# Pruebas controladas de jugabilidad · Mountain 01

## Objetivo

Separar tres niveles de evidencia:

1. que la ROM acepta una entrada;
2. que la entrada cambia el estado emulado;
3. que el cambio corresponde a una regla jugable concreta.

Sólo los dos primeros quedan confirmados por los probes actuales. El tercero requiere todavía sincronizar una captura con una coordenada de jugador y una entidad identificada.

## Secuencia reproducible

El laboratorio anterior ejecutó `controlled-probe.mjs` sobre la ROM identificada por SHA-256 `491898c9b0bf6b242d08bb0841141ca404f8e54383a1814cdb7feab451da8701`:

| Captura | Entrada | Resultado observable | Estado |
|---|---|---|---|
| `01-start` | START y espera | Mountain 01 en ventana nativa 256×240 | VERIFICADO |
| `02-right-12f` | derecha 12 frames | cambian la escena y el estado RAM | VERIFICADO |
| `03-jump-12f` | salto 12 frames | cambian la escena y el estado RAM | VERIFICADO |
| `04-hammer-8f` | B 8 frames | cambia la escena/estado emulado | VERIFICADO |
| `05-after-actions-60f` | espera 60 frames | la simulación continúa y el estado evoluciona | VERIFICADO |

Esto demuestra respuesta temporal a entradas, pero no permite por sí solo afirmar velocidad, aceleración, gravedad, fuerza de salto, daño o hitbox.

## Resultado del intento de aislamiento

Se compararon dos emulaciones que parten del mismo arranque: una sin B y otra con B durante 1, 2, 4, 8 y 12 frames. En esas ventanas el frame final no mostró una diferencia de píxeles suficientemente atribuible al martillo (`count=0` con el comparador usado).

Interpretación válida:

- no se ha aislado todavía la animación o el efecto de B;
- la prueba no demuestra que B no funcione;
- el momento del ciclo, el foco del estado de juego y la duración de la captura pueden ocultar el efecto;
- las capturas anteriores con cámara en movimiento no deben usarse como prueba de que un bloque concreto fue destruido.

Por tanto, `hammer_probe` queda como experimento inconcluso, no como regla de diseño.

## Qué puede incorporarse ya a la especificación

- La ventana nativa del juego de referencia es 256×240.
- La montaña tiene progresión vertical visible y desplazamiento de cámara.
- Hay respuesta reproducible a derecha, salto y B.
- Las bandas visuales de 8×8 y su separación de aproximadamente 48 píxeles son evidencia geométrica visual.
- La semántica de colisión de cada patrón, el estado rompible y la consecuencia exacta de B siguen `NO DETERMINADO`.

## Próxima prueba necesaria antes de fijar física

La siguiente extracción debería capturar cada frame desde un estado estable, con un jugador detenido sobre un patrón conocido, y guardar simultáneamente:

- frame de pantalla;
- entrada exacta por frame;
- RAM completa;
- bounding box visual del jugador;
- bounding box de la entidad afectada;
- pantalla antes, durante y después del evento.

Hasta obtener esa correlación no se deben fijar valores numéricos en Godot ni convertir automáticamente las firmas visuales en `CollisionShape2D`.

## Extracción frame-a-frame ejecutada

Se ejecutó `frame-probe.mjs` en el laboratorio anterior. Produjo 171 frames consecutivos, cada uno con PNG y RAM completa. La secuencia fue:

```text
0–30   sin entrada
31–60  RIGHT
61–70  sin entrada
71–100 A
101–110 sin entrada
111–140 B
141–170 sin entrada
```

La RAM cambia en cada tramo y la escena continúa evolucionando después de soltar cada botón. Esto confirma que el emulador está avanzando por frames y que la entrada se registra temporalmente. Sin embargo, el comparador visual simple no separa todavía al jugador del escenario: el render completo cambia de forma amplia por animación, sprites y cámara. No se extraen aún coordenadas físicas desde estos PNG.

La salida queda en el workspace temporal del laboratorio, no en este proyecto documental ni en el repositorio del juego. El ROM tampoco se copia.

# LEVEL_01_ORIGINAL · plano técnico

Ventana de referencia: `256×240`, 4:3. Esto es un plano de ingeniería, no arte final. Las franjas visibles corresponden a pisos observados en capturas; las coordenadas de objetos no extraídas quedan `?`.

```text
y=000  +------------------------ 256 px ------------------------+
       | P? / B? / ?       E2?       B? / P?                    |  piso 8?
       |--------------------------------------------------------|
       | B?        P?             ?              B?             |  piso 7?
       |--------------------------------------------------------|
       | P? / B?        ?       E1?        ?       P?            |  piso 6?
       |--------------------------------------------------------|
       | B?     ?     P?       ?        ?       B?              |  piso 5?
       |--------------------------------------------------------|
       | P? / B?       SP1?       ?        E2?                  |  piso 4?
       |--------------------------------------------------------|
       | B?       P?       ?      B?       ?       P?           |  piso 3?
       |--------------------------------------------------------|
       | P? / B?        ?        E1?        ?                  |  piso 2?
       |--------------------------------------------------------|
       | SP1?   B? B? B? B? B? B? B? B? B? B? P?                |  piso 1
       +--------------------------------------------------------+
       x=000                                                     x=255
```

La forma exacta de cada tramo se conserva en las capturas citadas, pero no se convierte a coordenadas inventadas. Los elementos confirmados son ocho pisos, bloques rompibles/otros tipos de suelo, progresión vertical, spawn de jugador y amenazas funcionales; posición individual exacta: NO DETERMINADA.

## Firmas visuales extraídas

Cada cadena representa 22 columnas de 8 px del área interior `x=40..215`; se conserva el patrón observado, no se interpreta todavía como colisión.

```text
m01-overview.png
screen_y=24  ######################
screen_y=32  ##++###+#####+++######
screen_y=40  +....+...+++.....+++++
screen_y=72  ######################
screen_y=80  #####+++##########+###
screen_y=88  .+++.....++++++++...++
screen_y=120 ######################
screen_y=128 ++########+####+++####
screen_y=136 ...++++++...++.....+++
screen_y=168 ######################
screen_y=176 #####++++##########+++
screen_y=184 ++++......+#++++++....
screen_y=216 ######################
```

```text
m01-start.png
screen_y=142 ######################
screen_y=150 ##++###+#####+++######
screen_y=158 +....+...+++.....+++++
screen_y=190 ######################
screen_y=198 #####+++##########+###
screen_y=206 .+++.....++++++++...++
```

La repetición de firmas entre ventanas es evidencia de desplazamiento/solapamiento visual, no permiso para duplicar pisos sin confirmar su `world_y`.

## Relación con JSON

Cada objeto observado aparece en `levels/reference/level_01_original.json`. Los objetos con posición desconocida conservan `x: null`, `y: null` y una referencia de evidencia. El plano no introduce símbolos que no estén en `LEGEND.md`.

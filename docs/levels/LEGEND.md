# Leyenda universal de planos

| Símbolo | ID/tipo | Función | Colisión | Daño | Movilidad | Destruible | Propiedades |
|---|---|---|---|---|---|---|---|
| `P` | platform.solid | hielo fijo | sólida | no | no | no | soporte |
| `B` | platform.breakable | hielo que abre ruta | sólida mientras intacto | no | no | sí | hueco al romper |
| `M` | platform.moving | piso/plataforma móvil | sólida según estado | no | sí | no | velocidad NO DETERMINADA |
| `C` | platform.cloud | nube | sólida al apoyar | no | sí/temporal | no | patrón NO DETERMINADO |
| `S` | surface.slippery | hielo que arrastra | sólida | no | no | no | dirección NO DETERMINADA |
| `Y` | pillar | barrera vertical | sólida | no | no | NO DETERMINADO | presencia exacta Nivel 1: NO DETERMINADA |
| `H` | hazard.icicle | peligro que cae | contacto | sí | sí | sí/efímero | aviso NO DETERMINADO |
| `E1` | enemy.topi | rellena huecos | cuerpo/camino NO DETERMINADO | contacto NO DETERMINADO | sí | NO DETERMINADO | busca/repara |
| `E2` | enemy.nitpicker | ave aérea | contacto | sí | sí | sí/NO DETERMINADO | vuela entre capas |
| `E3` | enemy.polar_bear | presión por tardanza | interacción de pantalla | NO DETERMINADO | sí | NO | empuja pantalla |
| `O1` | object.vegetable | bonus de puntos | no/recogible | no | no | al recoger | valor según bonus |
| `O2` | object.corn | extra de vida documentado | no/recogible | no | no | al recoger | primer maíz |
| `G` | goal.condor | final de bonus | recogible | no | sí | al agarrar | bonificación |
| `SP1` | spawn.player_1 | nacimiento P1 | no | no | no | no | coordenada exacta NO DETERMINADA |
| `SP2` | spawn.player_2 | nacimiento P2 futuro | no | no | no | no | reservado; no se afirma que exista en ROM |
| `TA` | touch.area | control izquierdo/derecho | no | no | no | no | visual, no jugable |
| `TJ` | touch.jump | control salto | no | no | no | no | visual, no jugable |
| `TK` | touch.attack | control ataque | no | no | no | no | visual, no jugable |

`?` significa elemento que la fuente menciona pero cuya posición o parámetro no está determinado. La leyenda se reutiliza en ambos planos.

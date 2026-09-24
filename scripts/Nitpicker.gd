class_name PreviewNitpicker
extends Node2D

## Enemigo aéreo provisional. Velocidad y trayectoria no son valores del ROM.

@export var enemy_id := "TEST-NITPICKER"
@export var speed := 130.0
@export var left_limit := 210.0
@export var right_limit := 1070.0
@export var wave_height := 22.0
var direction := -1.0
var base_y := 250.0
var elapsed := 0.0
var defeated := false

func _ready() -> void:
	base_y = position.y
	add_to_group("enemies")
	queue_redraw()

func _process(delta: float) -> void:
	if defeated:
		return
	elapsed += delta
	position.x += direction * speed * delta
	position.y = base_y + sin(elapsed * 3.0) * wave_height
	if position.x <= left_limit or position.x >= right_limit:
		direction *= -1.0
		position.x = clamp(position.x, left_limit, right_limit)
	queue_redraw()

func defeat() -> void:
	if defeated:
		return
	defeated = true
	queue_free()

func _draw() -> void:
	var body := Color("d87fbd")
	var wing := Color("f0b5df")
	draw_line(Vector2(-6, 0), Vector2(-35, -15), wing, 7.0)
	draw_line(Vector2(6, 0), Vector2(35, -15), wing, 7.0)
	draw_circle(Vector2(0, 0), 13, body)
	draw_circle(Vector2(-5, -3), 2.5, Color("24162b"))
	draw_circle(Vector2(5, -3), 2.5, Color("24162b"))
	draw_line(Vector2(-7, 12), Vector2(-13, 22), body, 4.0)
	draw_line(Vector2(7, 12), Vector2(13, 22), body, 4.0)
	draw_string(ThemeDB.fallback_font, Vector2(-40, 42), enemy_id, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color("f6c7ea"))

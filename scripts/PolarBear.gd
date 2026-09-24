class_name PreviewPolarBear
extends Node2D

## Presión temporal provisional. El umbral y velocidad del ROM siguen sin determinar.

@export var enemy_id := "TEST-POLAR-BEAR"
@export var speed := 55.0
var active := false
var direction := -1.0

func _ready() -> void:
	add_to_group("enemies")
	queue_redraw()

func _process(delta: float) -> void:
	if active:
		position.x += direction * speed * delta
		if position.x < 210.0:
			queue_free()
	queue_redraw()

func activate() -> void:
	active = true
	position.x = 1060.0
	queue_redraw()

func _draw() -> void:
	if not active:
		return
	var body := Color("d8edf4")
	var shadow := Color("7195a5")
	_draw_shadow_ellipse(Vector2(0, 7), Vector2(28, 9), Color(0.0, 0.0, 0.0, 0.24))
	draw_circle(Vector2(0, -16), 20, body)
	draw_circle(Vector2(0, 4), 25, body)
	draw_circle(Vector2(-15, -31), 8, body)
	draw_circle(Vector2(15, -31), 8, body)
	draw_circle(Vector2(-7, -18), 3, Color("1b2a32"))
	draw_circle(Vector2(7, -18), 3, Color("1b2a32"))
	draw_circle(Vector2(0, -8), 4, shadow)
	draw_line(Vector2(-12, 25), Vector2(-18, 36), shadow, 7)
	draw_line(Vector2(12, 25), Vector2(18, 36), shadow, 7)
	draw_string(ThemeDB.fallback_font, Vector2(-52, 55), enemy_id, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color("d8edf4"))

func _draw_shadow_ellipse(center: Vector2, radius: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for i in range(25):
		var angle := TAU * float(i) / 24.0
		points.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
	draw_colored_polygon(points, color)

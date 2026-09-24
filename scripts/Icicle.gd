class_name PreviewIcicle
extends Node2D

## Peligro provisional: aviso breve, caída y desaparición.

@export var fall_speed := 260.0
@export var warning_time := 0.8
var elapsed := 0.0
var active := false
var broken := false

func _ready() -> void:
	add_to_group("hazards")
	queue_redraw()

func _process(delta: float) -> void:
	elapsed += delta
	if not active:
		if elapsed >= warning_time:
			active = true
	else:
		position.y += fall_speed * delta
		if position.y > 650.0:
			queue_free()
	queue_redraw()

func break_hazard() -> void:
	if broken:
		return
	broken = true
	queue_free()

func _draw() -> void:
	if not active:
		draw_arc(Vector2.ZERO, 18.0, 0.0, TAU, 24, Color("b9f3ff", 0.45), 2.0)
		draw_string(ThemeDB.fallback_font, Vector2(-26, -24), "WARNING", HORIZONTAL_ALIGNMENT_LEFT, -1, 9, Color("ffcf66"))
		return
	var ice := PackedVector2Array([
		Vector2(-10, -8), Vector2(10, -8), Vector2(6, 8), Vector2(0, 30), Vector2(-6, 8)
	])
	draw_colored_polygon(ice, Color("b9f3ff"))
	draw_polyline(ice, Color("eafcff"), 2.0)

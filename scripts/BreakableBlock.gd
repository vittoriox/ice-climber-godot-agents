class_name BreakableBlock
extends StaticBody2D

## Bloque rompible de prueba. Su posición y tamaño no son coordenadas del ROM.

@export var block_size := Vector2(32, 32)
@export var block_id := "B-PENDING"
var broken := false

func _ready() -> void:
	z_index = 1
	add_to_group("breakable_blocks")
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = block_size
	collision.shape = shape
	add_child(collision)
	queue_redraw()

func break_block() -> void:
	if broken:
		return
	broken = true
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)
	queue_free()

func _draw() -> void:
	var rect := Rect2(-block_size * 0.5, block_size)
	draw_rect(rect, Color("49a9c5"), true)
	draw_rect(rect, Color("b9f3ff"), false, 2.0)
	draw_line(rect.position + Vector2(6, 7), rect.position + Vector2(20, 17), Color("d9fbff", 0.7), 2.0)
	draw_line(rect.position + Vector2(20, 17), rect.position + Vector2(11, 27), Color("d9fbff", 0.7), 2.0)
	draw_string(ThemeDB.fallback_font, Vector2(-14, -25), block_id, HORIZONTAL_ALIGNMENT_LEFT, -1, 9, Color("d9fbff", 0.75))

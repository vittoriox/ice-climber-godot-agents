class_name LevelPlatform
extends StaticBody2D

## Geometría provisional de gameplay. No representa coordenadas verificadas del ROM.

@export var platform_size := Vector2(240, 24)
@export var platform_color := Color("53c7e8")
@export var platform_id := "PENDING"
@export var one_way_collision := true

func _ready() -> void:
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = platform_size
	collision.shape = shape
	collision.one_way_collision = one_way_collision
	collision.one_way_collision_margin = 12.0
	add_child(collision)
	queue_redraw()

func _draw() -> void:
	var rect := Rect2(-platform_size * 0.5, platform_size)
	draw_rect(rect, Color("102f43"), true)
	draw_rect(Rect2(rect.position, Vector2(rect.size.x, 8)), platform_color, true)
	draw_rect(rect, Color(platform_color, 0.9), false, 2.0)
	for x in range(int(rect.position.x) + 12, int(rect.end.x) - 8, 24):
		draw_line(Vector2(x, 9), Vector2(x + 8, 20), Color(platform_color, 0.45), 2.0)
	draw_string(ThemeDB.fallback_font, Vector2(rect.position.x + 8, rect.position.y - 8), platform_id, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(platform_color, 0.75))

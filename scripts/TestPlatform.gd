class_name TestPlatform
extends StaticBody2D

@export var platform_size := Vector2(300, 28)
@export var platform_color := Color("6bc7df")

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	var rect := Rect2(-platform_size * 0.5, platform_size)
	draw_rect(rect, Color("102f43"), true)
	draw_rect(Rect2(rect.position, Vector2(rect.size.x, 8)), platform_color, true)
	draw_rect(rect, Color(platform_color, 0.8), false, 2.0)
	for x in range(int(rect.position.x) + 12, int(rect.end.x) - 8, 24):
		draw_line(Vector2(x, 9), Vector2(x + 8, 20), Color(platform_color, 0.45), 2.0)

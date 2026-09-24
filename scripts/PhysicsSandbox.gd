extends Node2D

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color("08121f"), true)
	draw_rect(Rect2(160, 70, 960, 560), Color("0b1d2b"), true)
	draw_rect(Rect2(160, 70, 960, 560), Color("3f8db8"), false, 3.0)
	draw_string(ThemeDB.fallback_font, Vector2(190, 112), "PHYSICS SANDBOX · NOT LEVEL 01", HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color("eaf7ff"))
	draw_string(ThemeDB.fallback_font, Vector2(190, 142), "Temporary test geometry for player movement and collision", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("8fb6c8"))
	draw_string(ThemeDB.fallback_font, Vector2(190, 680), "A/D or arrows: move    SPACE/W/UP: jump", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("f4c95d"))

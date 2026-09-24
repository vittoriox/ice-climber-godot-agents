extends Node2D

const LEVEL_PATH := "res://levels/web/level_01_web_16_9.json"
const PLAYER_SCENE := preload("res://scenes/Player.tscn")
const TOUCH_CONTROLS := preload("res://scripts/TouchControls.gd")
const LOGICAL_SIZE := Vector2(1280, 720)

var loader := LevelLoader.new()
var status_text := "Cargando..."

func _ready() -> void:
	var valid := loader.load_level(LEVEL_PATH)
	if valid:
		status_text = "JSON válido · %d objetos · coordenadas desconocidas preservadas" % loader.level_data.get("objects", []).size()
	else:
		status_text = "ERROR DE DATOS: %s" % " | ".join(loader.errors)
	if valid:
		var player = PLAYER_SCENE.instantiate()
		player.player_id = "P1"
		player.preview_only = true
		player.position = Vector2(640, 340)
		add_child(player)
		var touch_controls = TOUCH_CONTROLS.new()
		touch_controls.player = player
		add_child(touch_controls)
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, LOGICAL_SIZE), Color("08121f"), true)
	if loader.level_data.is_empty():
		_draw_text(status_text, Vector2(48, 72), Color.WHITE)
		return
	var areas: Dictionary = loader.level_data.get("areas", {})
	var playable: Dictionary = areas.get("playable", {})
	var safe: Dictionary = areas.get("safe", {})
	_draw_grid()
	_draw_header()
	_draw_playfield(playable, safe)
	for visual in areas.get("visual", []):
		_draw_area(visual, Color(0.12, 0.22, 0.34, 0.85), Color("344b63"), "VISUAL")
	var panels: Dictionary = areas.get("side_panels", {})
	_draw_side_panel("P1", "PLAYER 1", panels.get("left", {}), Color("53c7e8"), true)
	_draw_side_panel("P2", "PLAYER 2 · FUTURE", panels.get("right", {}), Color("bd83d8"), false)
	_draw_touch_controls(areas)
	_draw_status_card()
	_draw_legend()

func _draw_area(data: Dictionary, fill: Color, outline: Color, label: String) -> void:
	if not data.has_all(["x", "y", "width", "height"]):
		return
	var rect := Rect2(float(data.x), float(data.y), float(data.width), float(data.height))
	draw_rect(rect, fill, true)
	draw_rect(rect, outline, false, 2.0)
	_draw_text(label, rect.position + Vector2(8, 22), outline)

func _draw_grid() -> void:
	var grid_size := 40
	for x in range(160, 1121, grid_size):
		draw_line(Vector2(x, 76), Vector2(x, 600), Color(0.35, 0.62, 0.78, 0.08), 1.0)
	for y in range(80, 601, grid_size):
		draw_line(Vector2(160, y), Vector2(1120, y), Color(0.35, 0.62, 0.78, 0.08), 1.0)

func _draw_header() -> void:
	draw_rect(Rect2(0, 0, 1280, 76), Color("0d2234"), true)
	draw_line(Vector2(0, 76), Vector2(1280, 76), Color("4ca6e8"), 2.0)
	_draw_text("ICE CLIMBER", Vector2(24, 32), Color("eaf7ff"), 24)
	_draw_text("GODOT WEB · LEVEL 01", Vector2(24, 57), Color("78b9d6"), 14)
	_draw_text("MOUNTAIN 01", Vector2(520, 29), Color("f4c95d"), 18)
	_draw_text("FLOOR 01  ·  DATA PREVIEW", Vector2(520, 53), Color("b7c6d8"), 14)
	_draw_text("SCORE 000000", Vector2(1060, 31), Color("eaf7ff"), 14)
	_draw_text("LIFE  ♥♥♥", Vector2(1060, 55), Color("ff8e9e"), 14)

func _draw_playfield(playable: Dictionary, safe: Dictionary) -> void:
	if not playable.has_all(["x", "y", "width", "height"]):
		return
	var field := Rect2(float(playable.x), 76.0, float(playable.width), 524.0)
	draw_rect(field, Color("0b1d2b"), true)
	draw_rect(field, Color("3f8db8"), false, 3.0)
	_draw_text("PLAYABLE AREA · 4:3 PRESERVED", Vector2(184, 101), Color("63c9ee"), 14)
	if safe.has_all(["x", "y", "width", "height"]):
		var safe_rect := Rect2(float(safe.x), 108.0, float(safe.width), 456.0)
		draw_rect(safe_rect, Color(0.2, 0.75, 0.35, 0.04), true)
		draw_rect(safe_rect, Color(0.44, 0.83, 0.55, 0.55), false, 1.0)
		_draw_text("SAFE AREA", safe_rect.position + Vector2(8, 20), Color("70d48a"), 12)
	# Technical marker only: it is not a level position.
	draw_line(Vector2(640, 140), Vector2(640, 540), Color(0.4, 0.8, 0.95, 0.18), 1.0)
	draw_line(Vector2(260, 340), Vector2(1020, 340), Color(0.4, 0.8, 0.95, 0.12), 1.0)
	_draw_text("PLAYER SPAWN PREVIEW · POSITION PENDING ROM EXTRACTION", Vector2(430, 386), Color("7da6b8"), 12)

func _draw_side_panel(id: String, title: String, data: Dictionary, color: Color, active: bool) -> void:
	if not data.has_all(["x", "y", "width", "height"]):
		return
	var x := float(data.x)
	var w := float(data.width)
	draw_rect(Rect2(x + 12, 96, w - 24, 260), Color(0.04, 0.09, 0.15, 0.9), true)
	draw_rect(Rect2(x + 12, 96, w - 24, 260), Color(color, 0.7), false, 2.0)
	_draw_text(id, Vector2(x + 24, 128), color, 22)
	_draw_text(title, Vector2(x + 24, 151), Color("d3e5ef"), 11)
	_draw_avatar(Vector2(x + w * 0.5, 220), color, active)
	_draw_text("NORMAL" if active else "RESERVED", Vector2(x + 35, 305), color, 12)
	_draw_text("visual only", Vector2(x + 35, 326), Color("71889a"), 11)

func _draw_avatar(center: Vector2, color: Color, active: bool) -> void:
	var tone := color if active else Color("745b88")
	draw_circle(center + Vector2(0, -34), 17, tone)
	draw_rect(Rect2(center + Vector2(-20, -16), Vector2(40, 50)), tone, true)
	draw_line(center + Vector2(-12, 34), center + Vector2(-20, 62), tone, 7.0)
	draw_line(center + Vector2(12, 34), center + Vector2(20, 62), tone, 7.0)
	draw_line(center + Vector2(-20, 0), center + Vector2(-38, 20), tone, 6.0)
	draw_line(center + Vector2(20, 0), center + Vector2(38, 20), tone, 6.0)
	if active:
		draw_circle(center + Vector2(-6, -36), 3, Color("08121f"))
		draw_circle(center + Vector2(6, -36), 3, Color("08121f"))

func _draw_player_marker(center: Vector2) -> void:
	draw_circle(center + Vector2(0, -18), 9, Color("53c7e8"))
	draw_rect(Rect2(center + Vector2(-11, -8), Vector2(22, 28)), Color("53c7e8"), true)
	draw_line(center + Vector2(-7, 20), center + Vector2(-12, 34), Color("53c7e8"), 4.0)
	draw_line(center + Vector2(7, 20), center + Vector2(12, 34), Color("53c7e8"), 4.0)

func _draw_touch_controls(areas: Dictionary) -> void:
	var left: Dictionary = areas.get("touch_left", {})
	var right: Dictionary = areas.get("touch_right", {})
	if left.has_all(["x", "y", "width", "height"]):
		var lx := float(left.x)
		_draw_button(Vector2(lx + 48, 650), 25, "<", Color("f0a04b"))
		_draw_button(Vector2(lx + 112, 650), 25, ">", Color("f0a04b"))
		_draw_text("MOVE", Vector2(lx + 40, 595), Color("f0a04b"), 11)
	if right.has_all(["x", "y", "width", "height"]):
		var rx := float(right.x)
		_draw_button(Vector2(rx + 48, 650), 25, "↑", Color("ffcf66"))
		_draw_button(Vector2(rx + 112, 650), 25, "M", Color("ff8e9e"))
		_draw_text("JUMP ↑   HAMMER M", Vector2(rx + 10, 595), Color("ffcf66"), 11)

func _draw_button(center: Vector2, radius: float, label: String, color: Color) -> void:
	draw_circle(center, radius, Color(color, 0.14))
	draw_arc(center, radius, 0.0, TAU, 32, Color(color, 0.85), 2.0)
	_draw_text(label, center + Vector2(-7, 7), color, 20)

func _draw_status_card() -> void:
	draw_rect(Rect2(330, 520, 620, 58), Color("102b3c"), true)
	draw_rect(Rect2(330, 520, 620, 58), Color("3d7189"), false, 1.0)
	_draw_text("14 OBJECTS · COORDINATES PENDING", Vector2(354, 545), Color("f4c95d"), 14)
	_draw_text("This is a layout preview, not final gameplay", Vector2(354, 566), Color("a7c3d1"), 12)

func _draw_legend() -> void:
	_draw_text("LEGEND", Vector2(184, 626), Color("8fd8f1"), 12)
	_draw_text("BLUE = PLAYABLE    GREEN = SAFE    PURPLE = PLAYER PANEL    ORANGE = TOUCH", Vector2(184, 648), Color("819cad"), 11)
	_draw_text("JSON-driven preview · no invented level geometry", Vector2(184, 672), Color("819cad"), 11)

func _draw_text(value: String, position: Vector2, color: Color, font_size: int = 18) -> void:
	draw_string(ThemeDB.fallback_font, position, value, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)

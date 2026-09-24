extends Node2D

const LEVEL_PATH := "res://levels/web/level_01_web_16_9.json"
const PLAYER_SCENE := preload("res://scenes/Player.tscn")
const TOUCH_CONTROLS := preload("res://scripts/TouchControls.gd")
const PLATFORM_SCRIPT := preload("res://scripts/LevelPlatform.gd")
const BLOCK_SCRIPT := preload("res://scripts/BreakableBlock.gd")
const TOPI_SCRIPT := preload("res://scripts/Topi.gd")
const NITPICKER_SCRIPT := preload("res://scripts/Nitpicker.gd")
const POLAR_BEAR_SCRIPT := preload("res://scripts/PolarBear.gd")
const ICICLE_SCRIPT := preload("res://scripts/Icicle.gd")
const LOGICAL_SIZE := Vector2(1280, 720)

# Provisional playtest layout. The source JSON intentionally keeps the ROM
# coordinates unknown until frame-by-frame extraction is complete.
const PROVISIONAL_PLATFORMS := [
	{"id": "TEST-FLOOR", "position": Vector2(640, 584), "size": Vector2(880, 28), "color": Color("53c7e8"), "one_way": false},
	{"id": "TEST-P02", "position": Vector2(640, 320), "size": Vector2(180, 24), "color": Color("72d6e8"), "one_way": false},
	{"id": "TEST-P03", "position": Vector2(420, 200), "size": Vector2(180, 24), "color": Color("72d6e8"), "one_way": false},
	{"id": "TEST-P04", "position": Vector2(640, 80), "size": Vector2(180, 24), "color": Color("72d6e8"), "one_way": false}
]

var loader := LevelLoader.new()
var status_text := "Cargando..."
var active_player: PreviewPlayer
var lives := 3
var score := 0
var spawn_position := Vector2(640, 540)
var icicle_timer := 4.0
var highest_progress_y := 540.0
var stalled_time := 0.0
var polar_bear: PreviewPolarBear
var level_complete := false
var topi: PreviewTopi
var open_holes: Array[Vector2] = []

func _ready() -> void:
	var valid := loader.load_level(LEVEL_PATH)
	if valid:
		status_text = "JSON válido · %d objetos · coordenadas desconocidas preservadas" % loader.level_data.get("objects", []).size()
	else:
		status_text = "ERROR DE DATOS: %s" % " | ".join(loader.errors)
	if valid:
		_spawn_provisional_platforms()
		_spawn_provisional_blocks()
		var player = PLAYER_SCENE.instantiate()
		player.player_id = "P1"
		player.preview_only = false
		player.use_preview_bounds = false
		player.jump_speed = -600.0
		player.position = spawn_position
		add_child(player)
		player.hammer_hit.connect(_on_player_hammer_hit)
		player.damaged.connect(_on_player_damaged)
		active_player = player
		_spawn_provisional_enemies()
		var touch_controls = TOUCH_CONTROLS.new()
		touch_controls.player = player
		add_child(touch_controls)
	queue_redraw()

func _process(_delta: float) -> void:
	if active_player == null:
		return
	if not level_complete and active_player.global_position.y <= 48.0:
		level_complete = true
		score += 1000
		status_text = "LEVEL 01 COMPLETE · BONUS +1000"
		queue_redraw()
	if active_player.global_position.y < highest_progress_y - 8.0:
		highest_progress_y = active_player.global_position.y
		stalled_time = 0.0
	else:
		stalled_time += _delta
	if stalled_time >= 12.0 and (polar_bear == null or not is_instance_valid(polar_bear)):
		_spawn_polar_bear()
		stalled_time = 0.0
	icicle_timer -= _delta
	if icicle_timer <= 0.0:
		_spawn_provisional_icicle()
		icicle_timer = 5.0
	if active_player.global_position.y > LOGICAL_SIZE.y + 80.0:
		_on_player_fallen()
		return
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy is PreviewPolarBear and not enemy.active:
			continue
		if enemy.global_position.distance_to(active_player.global_position) <= 38.0:
			active_player.take_damage(enemy.global_position)
	for hazard in get_tree().get_nodes_in_group("hazards"):
		if hazard.global_position.distance_to(active_player.global_position) <= 30.0:
			active_player.take_damage(hazard.global_position)
			hazard.queue_free()

func _on_player_damaged() -> void:
	lives -= 1
	status_text = "DAMAGE · LIFE LOST"
	if lives <= 0:
		lives = 3
		status_text = "RESPAWN · 3 LIVES RESTORED"
		active_player.global_position = spawn_position
		active_player.velocity = Vector2.ZERO
	queue_redraw()

func _on_player_fallen() -> void:
	lives -= 1
	status_text = "FALL · LIFE LOST"
	if lives <= 0:
		lives = 3
		status_text = "RESPAWN · 3 LIVES RESTORED"
	active_player.global_position = spawn_position
	active_player.velocity = Vector2.ZERO
	active_player.damage_cooldown = 1.0
	queue_redraw()

func _spawn_provisional_enemies() -> void:
	topi = TOPI_SCRIPT.new()
	topi.enemy_id = "TEST-TOPI"
	topi.position = Vector2(350, 408)
	topi.patrol_min = 220.0
	topi.patrol_max = 1060.0
	topi.repair_callback = Callable(self, "_repair_block")
	add_child(topi)
	var nitpicker = NITPICKER_SCRIPT.new()
	nitpicker.enemy_id = "TEST-NITPICKER"
	# Keep the provisional flyer reachable with the current test layout.
	nitpicker.position = Vector2(930, 340)
	nitpicker.left_limit = 220.0
	nitpicker.right_limit = 1060.0
	add_child(nitpicker)

func _spawn_polar_bear() -> void:
	polar_bear = POLAR_BEAR_SCRIPT.new()
	polar_bear.enemy_id = "TEST-POLAR-BEAR"
	polar_bear.position = Vector2(1060, 540)
	add_child(polar_bear)
	polar_bear.activate()
	status_text = "POLAR BEAR · PROGRESS STALLED"
	queue_redraw()

func _spawn_provisional_icicle() -> void:
	var icicle = ICICLE_SCRIPT.new()
	icicle.position = Vector2(640, 150)
	add_child(icicle)

func _repair_block(block_position: Vector2, scan_direction: float) -> Array[Vector2]:
	var filled := 0
	var filled_positions: Array[Vector2] = []
	var candidates: Array[Vector2] = [block_position]
	var adjacent_position := block_position + Vector2(32.0 * sign(scan_direction), 0.0)
	for hole in open_holes:
		if hole.distance_to(adjacent_position) < 4.0:
			candidates.append(hole)
			break
	for candidate in candidates:
		var occupied := false
		for existing in get_tree().get_nodes_in_group("breakable_blocks"):
			if existing.global_position.distance_to(candidate) < 4.0:
				occupied = true
				break
		if not occupied:
			var block = BLOCK_SCRIPT.new()
			block.block_id = "REPAIRED"
			block.position = candidate
			add_child(block)
			filled += 1
		filled_positions.append(candidate)
		open_holes.erase(candidate)
	status_text = "TOPI · HIELO REPARADO"
	if filled > 0:
		status_text = "TOPI · %d BLOQUES REPARADOS" % filled
	queue_redraw()
	return filled_positions

func _spawn_provisional_platforms() -> void:
	for data in PROVISIONAL_PLATFORMS:
		var platform = PLATFORM_SCRIPT.new()
		platform.platform_id = data.id
		platform.position = data.position
		platform.platform_size = data.size
		platform.platform_color = data.color
		platform.one_way_collision = data.get("one_way", true)
		add_child(platform)

func _spawn_provisional_blocks() -> void:
	# A complete breakable row is the first playtest platform. Breaking one
	# block from below opens the route upward; the remaining row supports the
	# player from above.
	for index in range(24):
		var data := {"id": "TEST-B%02d" % (index + 1), "position": Vector2(256 + index * 32, 440)}
		var block = BLOCK_SCRIPT.new()
		block.block_id = data.id
		block.position = data.position
		add_child(block)

func _on_player_hammer_hit(origin: Vector2, direction: float) -> void:
	var horizontal_hitbox := Rect2(origin + Vector2(direction * 20.0 - 28.0, -22.0), Vector2(56.0, 44.0))
	var upward_hitbox := Rect2(origin + Vector2(-22.0, -76.0), Vector2(44.0, 60.0))
	var enemy_hit_center := origin + Vector2(direction * 48.0, 0)
	var selected_block: BreakableBlock
	var selected_distance := INF
	for node in get_tree().get_nodes_in_group("breakable_blocks"):
		var block_rect := Rect2(node.global_position - node.block_size * 0.5, node.block_size)
		# Blocks can be hit from the front for testing and from below, which
		# matches the documented Ice Climber interaction. Rectangles keep the
		# logical hit aligned with the visible hammer reach.
		var horizontal_hit := horizontal_hitbox.intersects(block_rect)
		var upward_hit := upward_hitbox.intersects(block_rect)
		if horizontal_hit or upward_hit:
			var desired_x := origin.x + direction * 20.0
			if upward_hit and not horizontal_hit:
				desired_x = origin.x
			var candidate_distance := absf(node.global_position.x - desired_x)
			if candidate_distance < selected_distance:
				selected_distance = candidate_distance
				selected_block = node
	if selected_block != null:
		var broken_position: Vector2 = selected_block.global_position
		selected_block.break_block()
		var already_recorded := false
		for hole in open_holes:
			if hole.distance_to(broken_position) < 4.0:
				already_recorded = true
				break
		if not already_recorded:
			open_holes.append(broken_position)
		if topi != null and is_instance_valid(topi):
			topi.notify_block_broken(broken_position)
		status_text = "HUECO ABIERTO · TOPI BUSCANDO"
		score += 10
		queue_redraw()
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.global_position.distance_to(enemy_hit_center) <= 44.0 and enemy.has_method("defeat"):
			enemy.defeat()
			score += 800 if enemy is PreviewNitpicker else 400
			queue_redraw()
			break
	for hazard in get_tree().get_nodes_in_group("hazards"):
		if hazard.global_position.distance_to(enemy_hit_center) <= 38.0 and hazard.has_method("break_hazard"):
			hazard.break_hazard()
			break

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
	_draw_status_card()
	_draw_legend()

func _draw_area(data: Dictionary, fill: Color, outline: Color, label: String) -> void:
	if not data.has_all(["x", "y", "width", "height"]):
		return
	# Visual side areas must never paint over the HUD/header. Their source
	# rectangles cover the full canvas, but the playable presentation starts
	# below the 76px header.
	var top := maxf(float(data.y), 76.0)
	var bottom := minf(float(data.y) + float(data.height), LOGICAL_SIZE.y)
	if bottom <= top:
		return
	var rect := Rect2(float(data.x), top, float(data.width), bottom - top)
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
	_draw_text("SCORE %06d" % score, Vector2(1038, 31), Color("eaf7ff"), 14)
	_draw_text("LIFE  %s" % "♥".repeat(lives), Vector2(1060, 55), Color("ff8e9e"), 14)

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
	if level_complete:
		draw_rect(Rect2(350, 150, 580, 92), Color(0.05, 0.16, 0.22, 0.94), true)
		draw_rect(Rect2(350, 150, 580, 92), Color("f4c95d"), false, 3.0)
	_draw_text("MOUNTAIN 01 CLEAR", Vector2(482, 190), Color("f4c95d"), 26)
	_draw_text("BONUS +1000 · PROVISIONAL GOAL", Vector2(482, 218), Color("eaf7ff"), 13)

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
		_draw_button(Vector2(lx + 32, 650), 25, "<", Color("f0a04b"))
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
	_draw_text("14 OBJECTS · PROVISIONAL COLLISION LAYOUT", Vector2(354, 545), Color("f4c95d"), 14)
	_draw_text(status_text, Vector2(354, 566), Color("a7c3d1"), 12)

func _draw_legend() -> void:
	_draw_text("LEGEND", Vector2(184, 626), Color("8fd8f1"), 12)
	_draw_text("BLUE = PLAYABLE    GREEN = SAFE    PURPLE = PLAYER PANEL    ORANGE = TOUCH", Vector2(184, 648), Color("819cad"), 11)
	_draw_text("JSON-driven preview · no invented level geometry", Vector2(184, 672), Color("819cad"), 11)

func _draw_text(value: String, position: Vector2, color: Color, font_size: int = 18) -> void:
	draw_string(ThemeDB.fallback_font, position, value, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)

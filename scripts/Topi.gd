class_name PreviewTopi
extends Node2D

## Enemigo provisional para probar patrulla, contacto y martillo.

@export var enemy_id := "TEST-TOPI"
@export var patrol_min := 330.0
@export var patrol_max := 540.0
@export var speed := 70.0
var direction := 1.0
var defeated := false
var repair_callback: Callable
var repair_target := Vector2.ZERO
var pending_holes: Array[Vector2] = []
var repair_state := 0 # 0 patrol, 1 returning to cave, 2 carrying ice
var repair_wait := 0.0
var repair_scan_direction := 1.0
var repair_cave_x := 220.0
@export var cave_left_x := 220.0
@export var cave_right_x := 1060.0

func _ready() -> void:
	z_index = 12
	add_to_group("enemies")
	queue_redraw()

func _process(delta: float) -> void:
	if defeated:
		return
	if repair_state == 1:
		var cave_distance := repair_cave_x - position.x
		if absf(cave_distance) > 4.0:
			position.x = move_toward(position.x, repair_cave_x, speed * 1.35 * delta)
			direction = sign(cave_distance)
		else:
			position.x = repair_cave_x
			repair_state = 2
			repair_wait = 0.0
			direction = sign(repair_target.x - repair_cave_x)
		queue_redraw()
		return
	if repair_state == 2:
		var first_hole_ahead := _first_hole_ahead(direction)
		if first_hole_ahead == Vector2.INF:
			repair_state = 0
			direction = repair_scan_direction
			queue_redraw()
			return
		repair_target = first_hole_ahead
		var distance := repair_target.x - position.x
		if absf(distance) > 4.0:
			position.x += speed * 1.35 * delta
			direction = 1.0
		else:
			repair_wait += delta
			if repair_wait >= 0.9:
				var filled_positions: Array = []
				if repair_callback.is_valid():
					filled_positions = repair_callback.call(repair_target, repair_scan_direction)
				_remove_filled_holes(filled_positions)
				repair_wait = 0.0
				# One ice load is used for this repair. Topi must walk again,
				# find another hole, and return to the cave for a new load.
				repair_state = 0
				direction = repair_scan_direction
			queue_redraw()
		return
	position.x += direction * speed * delta
	if position.x <= patrol_min or position.x >= patrol_max:
		direction *= -1.0
		position.x = clamp(position.x, patrol_min, patrol_max)
	if repair_state == 0:
		var hole_ahead := _hole_ahead()
		if hole_ahead != Vector2.INF:
			repair_target = hole_ahead
			repair_scan_direction = direction
			repair_cave_x = cave_left_x if direction > 0.0 else cave_right_x
			repair_state = 1
	queue_redraw()

func notify_block_broken(block_position: Vector2) -> void:
	if defeated:
		return
	for hole in pending_holes:
		if hole.distance_to(block_position) < 4.0:
			return
	pending_holes.append(block_position)
	queue_redraw()

func _hole_ahead() -> Vector2:
	var candidate := Vector2.INF
	for hole in pending_holes:
		var ahead := hole.x >= position.x - 4.0 if direction > 0.0 else hole.x <= position.x + 4.0
		if not ahead:
			continue
		if absf(hole.x - position.x) > 18.0:
			continue
		if candidate == Vector2.INF or absf(hole.x - position.x) < absf(candidate.x - position.x):
			candidate = hole
	return candidate

func _first_hole_ahead(travel_direction: float) -> Vector2:
	var candidate := Vector2.INF
	for hole in pending_holes:
		if travel_direction > 0.0:
			if hole.x < position.x - 4.0:
				continue
			if candidate == Vector2.INF or hole.x < candidate.x:
				candidate = hole
		else:
			if hole.x > position.x + 4.0:
				continue
			if candidate == Vector2.INF or hole.x > candidate.x:
				candidate = hole
	return candidate

func _remove_filled_holes(filled_positions: Array) -> void:
	if filled_positions.is_empty():
		return
	var remaining: Array[Vector2] = []
	for hole in pending_holes:
		var still_open := true
		for filled in filled_positions:
			if hole.distance_to(filled) < 4.0:
				still_open = false
				break
		if still_open:
			remaining.append(hole)
	pending_holes = remaining

func defeat() -> void:
	if defeated:
		return
	defeated = true
	queue_free()

func _draw() -> void:
	var carrying := repair_state == 2
	var body := Color("b8df62") if carrying else Color("8bcf62")
	var shadow := Color("477b4b")
	_draw_shadow_ellipse(Vector2(0, 8), Vector2(22, 8), Color(0.0, 0.0, 0.0, 0.22))
	draw_circle(Vector2(0, -10), 15, body)
	draw_rect(Rect2(-19, -9, 38, 25), body, true)
	draw_circle(Vector2(-7, -12), 3, Color("13251b"))
	draw_circle(Vector2(7, -12), 3, Color("13251b"))
	draw_line(Vector2(-12, 16), Vector2(-17, 25), shadow, 5)
	draw_line(Vector2(12, 16), Vector2(17, 25), shadow, 5)
	draw_string(ThemeDB.fallback_font, Vector2(-28, 43), "ICE LOAD" if carrying else enemy_id, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color("d8f5a0"))
	if carrying:
		draw_rect(Rect2(-25, 18, 50, 15), Color("b9f3ff"), true)
		draw_rect(Rect2(-25, 18, 50, 15), Color("e8fdff"), false, 2.0)

func _draw_shadow_ellipse(center: Vector2, radius: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for i in range(25):
		var angle := TAU * float(i) / 24.0
		points.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
	draw_colored_polygon(points, color)

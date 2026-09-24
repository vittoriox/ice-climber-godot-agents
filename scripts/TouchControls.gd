class_name PreviewTouchControls
extends Node2D

var player: PreviewPlayer
var held_left := false
var held_right := false
var pressed_jump := false
var pressed_attack := false
var active_touches: Dictionary = {}
var mouse_active := false
var mouse_position := Vector2.ZERO

func _ready() -> void:
	set_process_unhandled_input(true)
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			active_touches[event.index] = event.position
		else:
			active_touches.erase(event.index)
		_refresh_controls()
	elif event is InputEventScreenDrag:
		active_touches[event.index] = event.position
		_refresh_controls()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		mouse_active = event.pressed
		mouse_position = event.position
		_refresh_controls()
	elif event is InputEventMouseMotion and mouse_active:
		mouse_position = event.position
		_refresh_controls()

func _refresh_controls() -> void:
	var next_left := false
	var next_right := false
	var next_jump := false
	var next_attack := false
	for position in active_touches.values():
		if position.y >= 560.0:
			if position.x < 80.0:
				next_left = true
			elif position.x < 160.0:
				next_right = true
			elif position.x > 1120.0 and position.x < 1200.0:
				next_jump = true
			elif position.x >= 1200.0:
				next_attack = true
	if mouse_active:
		var position := mouse_position
		if position.y >= 560.0:
			if position.x < 80.0:
				next_left = true
			elif position.x < 160.0:
				next_right = true
			elif position.x > 1120.0 and position.x < 1200.0:
				next_jump = true
			elif position.x >= 1200.0:
				next_attack = true
	_set_jump_state(next_jump)
	held_left = next_left
	held_right = next_right
	pressed_attack = next_attack
	if player:
		player.virtual_left = held_left
		player.virtual_right = held_right
		player.virtual_jump = pressed_jump
		player.virtual_attack = pressed_attack
	queue_redraw()
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		active_touches.clear()
		mouse_active = false
		_refresh_controls()

func _set_jump_state(pressed: bool) -> void:
	# Keep the visual pressed state, but also latch the press so a quick tap
	# cannot be lost between input events and the next physics tick.
	if pressed and not pressed_jump and player:
		player.virtual_jump_requested = true
	pressed_jump = pressed

func consume_jump() -> bool:
	var result := pressed_jump
	pressed_jump = false
	if player:
		player.virtual_jump = false
	return result

func consume_attack() -> bool:
	var result := pressed_attack
	pressed_attack = false
	if player:
		player.virtual_attack = false
	return result

func _draw() -> void:
	_draw_button(Vector2(48, 650), "<", Color("f0a04b"), held_left)
	_draw_button(Vector2(112, 650), ">", Color("f0a04b"), held_right)
	_draw_button(Vector2(1168, 650), "↑", Color("ffcf66"), pressed_jump)
	_draw_button(Vector2(1232, 650), "M", Color("ff8e9e"), pressed_attack)
	draw_string(ThemeDB.fallback_font, Vector2(40, 595), "MOVE", HORIZONTAL_ALIGNMENT_LEFT, -1, 11, Color("f0a04b"))
	draw_string(ThemeDB.fallback_font, Vector2(1145, 595), "JUMP ↑/K   HAMMER M", HORIZONTAL_ALIGNMENT_LEFT, -1, 11, Color("ffcf66"))

func _draw_button(center: Vector2, label: String, color: Color, active: bool) -> void:
	var fill := Color(color, 0.34 if active else 0.14)
	draw_circle(center, 25.0, fill)
	draw_arc(center, 25.0, 0.0, TAU, 32, color, 2.0)
	draw_string(ThemeDB.fallback_font, center + Vector2(-7, 7), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, color)

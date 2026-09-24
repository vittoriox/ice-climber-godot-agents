class_name PreviewTouchControls
extends Node2D

var player: PreviewPlayer
var held_left := false
var held_right := false
var pressed_jump := false
var pressed_attack := false

func _ready() -> void:
	set_process_unhandled_input(true)
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_apply_touch(event.position, event.pressed)
	elif event is InputEventScreenDrag:
		_apply_touch(event.position, true)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_apply_touch(event.position, event.pressed)

func _apply_touch(position: Vector2, pressed: bool) -> void:
	if position.y < 560.0:
		return
	var left_side := position.x < 160.0
	var right_side := position.x > 1120.0
	if left_side:
		if position.x < 80.0:
			held_left = pressed
		else:
			held_right = pressed
	elif right_side:
		if position.x < 1200.0:
			pressed_jump = pressed
		else:
			pressed_attack = pressed
	if player:
		player.virtual_left = held_left
		player.virtual_right = held_right
		player.virtual_jump = pressed_jump
		player.virtual_attack = pressed_attack
	queue_redraw()

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
	_draw_button(Vector2(64, 650), "<", Color("f0a04b"), held_left)
	_draw_button(Vector2(112, 650), ">", Color("f0a04b"), held_right)
	_draw_button(Vector2(1168, 650), "↑", Color("ffcf66"), pressed_jump)
	_draw_button(Vector2(1232, 650), "M", Color("ff8e9e"), pressed_attack)

func _draw_button(center: Vector2, label: String, color: Color, active: bool) -> void:
	var fill := Color(color, 0.34 if active else 0.14)
	draw_circle(center, 25.0, fill)
	draw_arc(center, 25.0, 0.0, TAU, 32, color, 2.0)
	draw_string(ThemeDB.fallback_font, center + Vector2(-7, 7), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, color)

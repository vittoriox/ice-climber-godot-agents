class_name PreviewPlayer
extends CharacterBody2D

## Prototipo visual y de input. No representa todavía la física verificada del ROM.

@export var player_id := "P1"
@export var preview_only := true
@export var use_preview_bounds := true
var gravity := 1150.0
var move_speed := 260.0
var jump_speed := -470.0
var virtual_left := false
var virtual_right := false
var virtual_jump := false
var virtual_attack := false
var facing := 1.0
var attack_timer := 0.0
var attack_cooldown := 0.0

func _ready() -> void:
	queue_redraw()

func _physics_process(delta: float) -> void:
	attack_timer = maxf(attack_timer - delta, 0.0)
	attack_cooldown = maxf(attack_cooldown - delta, 0.0)
	var direction := Input.get_axis("move_left", "move_right")
	if virtual_left:
		direction = -1.0
	if virtual_right:
		direction = 1.0
	if direction == 0.0:
		if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
			direction = -1.0
		elif Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
			direction = 1.0
	velocity.x = move_toward(velocity.x, direction * move_speed, 900.0 * delta)
	if direction != 0.0:
		facing = sign(direction)
	velocity.y += gravity * delta
	var preview_grounded := global_position.y >= 549.0
	if (virtual_jump or Input.is_action_just_pressed("jump") or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_SPACE)) and (is_on_floor() or preview_grounded):
		velocity.y = jump_speed
	var attack_requested := virtual_attack or Input.is_key_pressed(KEY_J)
	if attack_requested and attack_cooldown <= 0.0:
		attack_timer = 0.24
		attack_cooldown = 0.34
	move_and_slide()
	if use_preview_bounds:
		global_position.x = clamp(global_position.x, 190.0, 1090.0)
		global_position.y = clamp(global_position.y, 130.0, 550.0)
	if use_preview_bounds and global_position.y >= 550.0:
		velocity.y = 0.0
		set_floor_snap_length(8.0)
	queue_redraw()

func _draw() -> void:
	var ice := Color("53c7e8")
	var coat := Color("28688b")
	var skin := Color("ffd2a1")
	# Shadow and body silhouette.
	_draw_ellipse_custom(Vector2(0, 31), Vector2(25, 7), Color(0.0, 0.0, 0.0, 0.25))
	draw_circle(Vector2(0, -31), 14.0, skin)
	draw_rect(Rect2(-17, -20, 34, 43), coat, true)
	draw_rect(Rect2(-17, -20, 34, 7), ice, true)
	draw_line(Vector2(-11, 23), Vector2(-17, 43), ice, 7.0)
	draw_line(Vector2(11, 23), Vector2(17, 43), ice, 7.0)
	draw_line(Vector2(-16, -5), Vector2(-34, 14), ice, 6.0)
	draw_line(Vector2(16, -5), Vector2(34, 14), ice, 6.0)
	draw_circle(Vector2(-5, -33), 2.5, Color("0b1d2b"))
	draw_circle(Vector2(5, -33), 2.5, Color("0b1d2b"))
	if attack_timer > 0.0:
		_draw_hammer()
	draw_string(ThemeDB.fallback_font, Vector2(-18, 65), player_id + " · PREVIEW", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("a7e8f7"))
	if attack_timer > 0.0:
		draw_string(ThemeDB.fallback_font, Vector2(-30, 84), "HAMMER", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("ffcf66"))

func _draw_hammer() -> void:
	var direction := facing
	var pivot := Vector2(20.0 * direction, -4.0)
	var head := Vector2(55.0 * direction, -28.0)
	draw_line(pivot, head, Color("d7e6ed"), 6.0)
	draw_rect(Rect2(head - Vector2(12.0, 8.0), Vector2(24.0, 16.0)), Color("ffcf66"), true)
	draw_rect(Rect2(head - Vector2(12.0, 8.0), Vector2(24.0, 16.0)), Color("fff0a6"), false, 2.0)
	draw_arc(Vector2(42.0 * direction, -26.0), 32.0, -1.15 if direction > 0 else 2.0, 1.15 if direction > 0 else 4.3, 18, Color(1.0, 0.81, 0.4, 0.75), 3.0)

func _draw_ellipse_custom(center: Vector2, radius: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for i in range(25):
		var angle := TAU * float(i) / 24.0
		points.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
	draw_colored_polygon(points, color)

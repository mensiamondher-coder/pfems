class_name Player
extends CharacterBody3D
## First-person player controller.
##
## Handles movement, gravity, and mouse look in a single script.
## All tunables are exposed as exports grouped by category for easy tweaking.

# ── Movement Stats ───────────────────────────────────────────────────────────

@export_group("Movement")
## Maximum ground speed in m/s.
@export var move_speed: float = 7.0
## How quickly the player reaches max speed (m/s²).
@export var acceleration: float = 50.0
## How quickly the player stops when no input is held (m/s²).
@export var friction: float = 40.0
## Gravity magnitude applied downward (m/s²).
@export var gravity: float = 20.0
## Jump impulse velocity (m/s).
@export var jump_force: float = 7.0

# ── Mouse Look Stats ────────────────────────────────────────────────────────

@export_group("Mouse Look")
## Sensitivity in degrees per pixel of mouse movement.
@export var mouse_sensitivity: float = 0.1
## Maximum vertical look angle (degrees).
@export var max_pitch: float = 89.0
## Minimum vertical look angle (degrees, negative = down).
@export var min_pitch: float = -89.0

# ── Node References ──────────────────────────────────────────────────────────

@onready var camera: Camera3D = $Camera3D


# ── Built-in Callbacks ──────────────────────────────────────────────────────

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	# Mouse look.
	if event is InputEventMouseMotion:
		_handle_mouse_look(event.relative)

	# Toggle mouse capture.
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_jump()
	_apply_movement(delta)
	move_and_slide()


# ── Gravity ──────────────────────────────────────────────────────────────────

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta


# ── Jump ─────────────────────────────────────────────────────────────────────

func _handle_jump() -> void:
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force


# ── Movement ─────────────────────────────────────────────────────────────────

func _apply_movement(delta: float) -> void:
	var direction := _get_input_direction()
	var flat_velocity := Vector2(velocity.x, velocity.z)

	if direction.length_squared() > 0.01:
		var target := Vector2(direction.x, direction.z) * move_speed
		flat_velocity = flat_velocity.move_toward(target, acceleration * delta)
	else:
		flat_velocity = flat_velocity.move_toward(Vector2.ZERO, friction * delta)

	velocity.x = flat_velocity.x
	velocity.z = flat_velocity.y


func _get_input_direction() -> Vector3:
	var input := Vector2.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_forward", "move_back")

	if input.length_squared() > 1.0:
		input = input.normalized()

	var forward := -global_transform.basis.z
	var right := global_transform.basis.x
	forward.y = 0.0
	right.y = 0.0
	forward = forward.normalized()
	right = right.normalized()

	return right * input.x + forward * -input.y


# ── Mouse Look ───────────────────────────────────────────────────────────────

func _handle_mouse_look(mouse_delta: Vector2) -> void:
	# Yaw — rotate the whole body.
	rotate_y(deg_to_rad(-mouse_delta.x * mouse_sensitivity))

	# Pitch — rotate only the camera, clamped.
	camera.rotate_x(deg_to_rad(-mouse_delta.y * mouse_sensitivity))
	camera.rotation.x = clampf(
		camera.rotation.x,
		deg_to_rad(min_pitch),
		deg_to_rad(max_pitch)
	)

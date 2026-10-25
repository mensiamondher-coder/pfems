extends CharacterBody3D


enum MoveMode { NONE, NAVIGATE }
enum LookMode { NONE, LOOK_AT_VELOCITY, LOOK_AT_PLAYER }

@export var speed: float = 4.0
@export var rotation_speed: float = 8.0 # Higher = faster turns but let's keep it at this value
@export var health: int = 20 # Made it an export so that I can test the death sequence in the BT
@export var target: Node3D


var current_move_mode: MoveMode = MoveMode.NONE
var current_look_mode: LookMode = LookMode.NONE

var direct_velocity_target: Vector3 = Vector3.ZERO
var player_reference: Node3D = null

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var wheel_anim: AnimationPlayer = $WheelAnimation
@onready var body_anim: AnimationPlayer = $BodyAnimation


func _ready() -> void:
	nav_agent.velocity_computed.connect(_on_navigation_agent_3d_velocity_computed)


func _physics_process(delta: float) -> void:
	match current_move_mode:
		MoveMode.NAVIGATE:
			if not nav_agent.is_navigation_finished():
				var next_path_pos = nav_agent.get_next_path_position()
				var new_velocity = global_position.direction_to(next_path_pos) * speed
				nav_agent.set_velocity(new_velocity)
			else:
				velocity = Vector3.ZERO
				move_and_slide()

		MoveMode.NONE:
			velocity = Vector3.ZERO
			move_and_slide()

	_handle_smooth_rotation(delta)


func _handle_smooth_rotation(delta: float) -> void:
	var target_direction: Vector3 = Vector3.ZERO

	match current_look_mode:
		LookMode.LOOK_AT_VELOCITY:
			if velocity.length_squared() > 0.01:
				target_direction = velocity.normalized()

		LookMode.LOOK_AT_PLAYER:
			if is_instance_valid(player_reference):
				target_direction = global_position.direction_to(player_reference.global_position)

	if target_direction != Vector3.ZERO:
		target_direction.y = 0
		target_direction = target_direction.normalized()
		
		if target_direction != Vector3.ZERO:
			var target_basis = Basis.looking_at(target_direction, Vector3.UP)
			var target_rotation = target_basis.get_rotation_quaternion()
			
			global_transform.basis = Basis(
				global_transform.basis.get_rotation_quaternion().slerp(target_rotation, rotation_speed * delta)
			)


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	if current_move_mode == MoveMode.NAVIGATE:
		velocity = safe_velocity
		move_and_slide()

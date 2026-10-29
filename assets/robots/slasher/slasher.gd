extends CharacterBody3D


enum MoveMode { NONE, NAVIGATE }
enum LookMode { NONE, LOOK_AT_VELOCITY, LOOK_AT_PLAYER }
enum AvoidanceMode { NONE, NORMAL, PRIORITY }

@export var speed: float = 4.0
@export var rotation_speed: float = 8.0 # Higher = faster turns but let's keep it at this value
@export var health: int = 20 # Made it an export so that I can test the death sequence in the BT
@export var target: Node3D

var current_move_mode: MoveMode = MoveMode.NONE
var current_look_mode: LookMode = LookMode.NONE
var current_avoidance_mode: AvoidanceMode = AvoidanceMode.NONE

var direct_velocity_target: Vector3 = Vector3.ZERO
var player_reference: Node3D = null

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var wheel_anim: AnimationPlayer = $WheelAnimation
@onready var body_anim: AnimationPlayer = $BodyAnimation
@onready var collision: CollisionShape3D = $CollisionShape3D

# Body parts (sus)
@onready var main_body: Node3D = $Root/MainBody
@onready var weapon: Node3D = $Root/MainBody/weapon
@onready var wheel_group: Node3D = $Root/WheelGroup


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


func set_avoidance_mode(MODE: AvoidanceMode):
	current_avoidance_mode = MODE
	match current_avoidance_mode:
		AvoidanceMode.NONE:
			nav_agent.avoidance_enabled = false
		
		AvoidanceMode.NORMAL:
			nav_agent.avoidance_enabled = true
			nav_agent.radius = 0.4
			nav_agent.avoidance_priority = 0.5
		
		AvoidanceMode.PRIORITY:
			nav_agent.avoidance_enabled = true
			nav_agent.radius = 0.2
			nav_agent.avoidance_priority = 1.0


func take_damage(amount: int):
	health -= amount


func destroy():
	for a in main_body.get_children():
		if a is RigidBody3D:
			a.freeze = false
	
	for b in weapon.get_children():
		if b is RigidBody3D:
			b.freeze = false
			
	for c in wheel_group.get_children():
		if c is RigidBody3D:
			c.freeze = false
	

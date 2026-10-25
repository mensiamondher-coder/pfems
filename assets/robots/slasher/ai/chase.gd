@tool
class_name Chase extends ActionLeaf


func before_run(actor: Node, _blackboard: Blackboard) -> void:
	actor.current_move_mode  = actor.MoveMode.NAVIGATE
	actor.current_look_mode = actor.LookMode.LOOK_AT_VELOCITY
	actor.wheel_anim.play("move_forward")
	actor.body_anim.play("lean_forward")


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.nav_agent.target_position = actor.player_reference.global_position
	return RUNNING

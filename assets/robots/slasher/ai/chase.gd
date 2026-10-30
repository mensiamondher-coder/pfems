@tool
class_name Chase extends ActionLeaf



func interrupt(actor: Node, _blackboard: Blackboard) -> void:
	actor.wheel_anim.stop()
	actor.move_sound.stop()


func before_run(actor: Node, _blackboard: Blackboard) -> void:
	actor.current_move_mode  = actor.MoveMode.NAVIGATE
	actor.current_look_mode = actor.LookMode.LOOK_AT_VELOCITY
	actor.set_avoidance_mode(actor.AvoidanceMode.NORMAL)
	actor.wheel_anim.play("move_forward")
	actor.body_anim.play("lean_forward")
	actor.move_sound.play()


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.nav_agent.target_position = actor.player_reference.global_position
	return RUNNING

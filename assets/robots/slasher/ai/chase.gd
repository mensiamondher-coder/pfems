@tool
class_name Chase extends ActionLeaf


func before_run(actor: Node, _blackboard: Blackboard) -> void:
	actor.current_move_mode  = actor.MoveMode.NAVIGATE
	actor.current_look_mode = actor.LookMode.LOOK_AT_VELOCITY
	actor.set_avoidance_mode(actor.AvoidanceMode.NORMAL)
	actor.wheel_anim.play("move_forward")
	actor.body_anim.play("lean_forward")


func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.nav_agent.target_position = actor.player_reference.global_position
	if not actor.nav_agent.navigation_finished.is_connected(print):
		actor.nav_agent.navigation_finished.connect(print.bind("I reached my target but I did not attack!"))
	return RUNNING

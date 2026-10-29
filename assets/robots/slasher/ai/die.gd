@tool
class_name Die extends ActionLeaf



func before_run(actor: Node, _blackboard: Blackboard) -> void:
	actor.current_look_mode = actor.LookMode.NONE
	actor.current_move_mode = actor.MoveMode.NONE
	actor.current_avoidance_mode = actor.AvoidanceMode.NONE
	actor.collision.disabled = true
	actor.destroy()



func tick(_actor: Node, _blackboard: Blackboard) -> int:
	return RUNNING

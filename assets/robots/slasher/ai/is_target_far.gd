@tool
class_name IsTargetFar extends ConditionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.global_position.distance_to(actor.player_reference.global_position) >= 1.0:
		return SUCCESS
	else:
		return FAILURE

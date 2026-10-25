@tool
class_name HasTarget extends ConditionLeaf



func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.target:
		actor.player_reference = actor.target
		return SUCCESS
	else:
		return FAILURE

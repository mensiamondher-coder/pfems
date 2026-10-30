@tool
class_name Die extends ActionLeaf

@onready var collapse: AudioStreamPlayer3D = $"../../../../Collapse"


func before_run(actor: Node, _blackboard: Blackboard) -> void:
	collapse.play()
	actor.current_look_mode = actor.LookMode.NONE
	actor.current_move_mode = actor.MoveMode.NONE
	actor.set_avoidance_mode(actor.AvoidanceMode.NONE)
	actor.collision.disabled = true
	actor.destroy()



func tick(_actor: Node, _blackboard: Blackboard) -> int:
	return RUNNING

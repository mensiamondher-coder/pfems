@tool
class_name Slash extends ActionLeaf


var animation_finished = false


func before_run(actor: Node, _blackboard: Blackboard) -> void:
	animation_finished = false
	actor.current_move_mode = actor.MoveMode.NONE
	actor.current_look_mode = actor.LookMode.LOOK_AT_PLAYER
	actor.wheel_anim.stop()
	actor.body_anim.play("attack")


func tick(_actor: Node, _blackboard: Blackboard) -> int:
	if animation_finished:
		return SUCCESS
	return RUNNING


func _on_body_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		animation_finished = true

extends GridContainer
@onready var player: Player = $"../../.."

@onready var staminabar_1: ProgressBar = $staminabar1
@onready var staminabar_2: ProgressBar = $staminabar2
@onready var staminabar_3: ProgressBar = $staminabar3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if staminabar_1.value == staminabar_1.max_value:
		staminabar_1.modulate = Color(0.0, 0.859, 0.839, 1.0)
	else:
		staminabar_1.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if staminabar_2.value == staminabar_1.max_value:
		staminabar_2.modulate = Color(0.0, 0.859, 0.839, 1.0)
	else:
		staminabar_2.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if staminabar_3.value == staminabar_1.max_value:
		staminabar_3.modulate = Color(0.0, 0.859, 0.839, 1.0)
	else:
		staminabar_3.modulate = Color(1.0, 1.0, 1.0, 1.0)

	staminabar_1.value = player.stamina * 100 / 3
	staminabar_2.value = (player.stamina * 100 / 3) - 33
	staminabar_3.value = (player.stamina * 100 / 3) - 66 
	pass

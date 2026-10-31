extends Control

@onready var player: Player = $"../.."
@onready var d_bar: AnimatedSprite2D = $DBar



func _process(_delta: float) -> void:
	d_bar.frame = player.incremental_stamina

extends Node

func _ready() -> void:
	get_child(0).linear_velocity.y = 0
	get_child(1).linear_velocity.y = 0

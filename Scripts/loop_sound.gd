extends Node2D

var player_idx: int = 0

func _on_timer_timeout() -> void:
	get_child(player_idx % 2).play()
	player_idx += 1

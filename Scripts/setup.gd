extends Node

func _ready() -> void:
	Data.add_listener("score_changed", 
		func(val: int) -> void:
			$UI/Score.text = "{0}".format([val])
	)
	
	Data.add_listener(&"game_over", _clean_platforms)

func _clean_platforms() -> void:
	for child: Node in get_tree().root.get_children():
		if child is Platform:
			pass

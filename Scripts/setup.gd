extends Node

func _ready() -> void:
	Data.add_listener("score_changed", 
		func(val: int) -> void:
			$UI/Score.text = "{0}".format([val])
	)

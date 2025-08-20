extends Node

func _ready() -> void:
	Data.add_listener("score_changed", func(val: int): $UI/Label.text = "{0}".format([val]))

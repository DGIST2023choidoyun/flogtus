extends Node

func _ready() -> void:
	Data.add_listener("score_changed", 
		func(val: int) -> void:
			$UI/Score.text = "{0}".format([val])
	)

func _on_screen_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if not event.pressed:
			$FloatingGenerator.start_generation()
			$UI/Screen.hide()

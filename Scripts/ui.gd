extends CanvasLayer

signal game_start()

func _ready() -> void:
	if Data.is_first:
		$Screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$Screen.position.y -= Utility.world_y
		
		var y_tween: Tween = create_tween()
		y_tween.tween_property($Screen, "position:y", 0, 3).set_trans(Tween.TRANS_LINEAR)
		y_tween.tween_callback(
			func() -> void:
				Data.is_first = false
				$Screen.mouse_filter = Control.MOUSE_FILTER_STOP
		)
		

func _on_screen_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if not event.pressed:
			$Score.show()
			$Screen.hide()
			game_start.emit()

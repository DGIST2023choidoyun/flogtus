extends CanvasLayer

signal game_start()

func _ready() -> void:
	Data.add_listener(&"game_over", _show_result)
	Data.add_listener(&"game_set", _initialize)

func _initialize() -> void:
	$ResultModal.position.x = -Utility.world_x
	
	$Screen.position.y = -Utility.world_y
	
	await _flow_title()
	
	$Screen.mouse_filter = Control.MOUSE_FILTER_STOP

func _on_screen_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if not event.pressed:
			$Screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
			game_start.emit()
			await _flow_title()
			$Score.show()

func _show_result(score: int) -> void:
	$Score.hide()
	
	$ResultModal.show_result(score)

func _flow_title() -> void:
	var y_tween: Tween = create_tween()
	y_tween.tween_property($Screen, "position:y", $Screen.position.y + Utility.world_y, 2).set_trans(Tween.TRANS_LINEAR)
	
	await y_tween.finished

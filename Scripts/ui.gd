extends CanvasLayer

func _ready() -> void:
	#if Data.is_first:
		#$Screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
		#$Screen.position.y -= Utility.world_y
		#
		#var y_tween: Tween = create_tween()
		#y_tween.tween_property($Screen, "position:y", 0, 3).set_trans(Tween.TRANS_LINEAR)
		#y_tween.tween_callback(
			#func() -> void:
				#Data.is_first = false
				#$Screen.mouse_filter = Control.MOUSE_FILTER_STOP
		#)
	Data.add_listener("score_changed", 
		func(val: int) -> void:
			$Score.text = str(val)
	)

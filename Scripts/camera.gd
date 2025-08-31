extends Camera2D

signal zoomed_out()

func initialize() -> void:
	self.zoom = Vector2(3.6, 3.6)

func zoom_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"zoom", Vector2.ONE, 1.5).set_trans(Tween.TRANS_CIRC) # TODO
	tween.tween_callback(
		func() -> void:
			zoomed_out.emit()
	)

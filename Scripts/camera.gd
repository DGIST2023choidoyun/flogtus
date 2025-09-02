extends Camera2D

signal zoomed_out()

const _init_zoom: float = 5

func initialize() -> void:
	self.zoom = Vector2.ONE * _init_zoom

func zoom_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"zoom", Vector2.ONE, 1.5).set_trans(Tween.TRANS_ELASTIC) # TODO
	tween.tween_callback(
		func() -> void:
			zoomed_out.emit()
	)

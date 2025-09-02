extends Camera2D

'''
오프닝: 돌아가는 연잎에 카메라 고정 -> 줌 아웃 & 위치 원래대로
'''

signal zoomed_out()

const _init_zoom: float = 2.4

func initialize() -> void:
	self.zoom = Vector2.ONE * _init_zoom
	reparent(Frog.instance)

func zoom_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"zoom", Vector2.ONE, 1.5).set_trans(Tween.TRANS_ELASTIC) # TODO
	tween.tween_callback(
		func() -> void:
			zoomed_out.emit()
	)
	var retrieve_tween: Tween = create_tween()
	retrieve_tween.parallel().tween_property(self, ^"position", Utility.world_center, 0.3)
	retrieve_tween.parallel().tween_property(self, ^"rotation", 0, 1.0)
	
	reparent(get_tree().current_scene)

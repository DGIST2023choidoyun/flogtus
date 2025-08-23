extends Control

func _ready() -> void:
	Data.add_listener(&"init", _initialize)

func _initialize() -> void:
	$Base.position = Vector2(Utility.world_x / 2, Utility.world_y / 2 - 32)
	$Base.frame = 0

func show_result(score: int) -> void:
	await _move_right()
	
	$Base.play()
	$Base/Info/Score.text = "{0}".format([score])
	await $Base.animation_finished
	$Base/Info.show()
	$Base/Info/Croak.play()
	
	await get_tree().create_timer(6.0).timeout
	await _move_right()
	
	Data.restart_game()

func _move_right() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"position:x", self.position.x + Utility.world_x, 1.5).set_trans(Tween.TRANS_BACK)
	
	await tween.finished

class_name LotusFlower extends Lotus

const size: int = 15

func _ready() -> void:
	super()
	$Sprite.frame = 0

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	var half_time: float = Utility.time_of_damped(Utility.world_y / 2)
	$Timer.wait_time = randf() * half_time / 2 + half_time
	$Timer.start()

func _on_timer_timeout() -> void:
	$Sprite.play(&"default")

func _on_sprite_frame_changed() -> void:
	if $Sprite.animation == &"default":
		var frame: int = $Sprite.frame
		match frame:
			1:
				($Shape.shape as CircleShape2D).radius = 12
			2:
				($Shape.shape as CircleShape2D).radius = 8
			3:
				collapse.emit()
		state_changed.emit()

class_name LotusFlower extends Lotus

const size: int = 15

var unbloom_y: float

func _ready() -> void:
	super()
	$Sprite.frame = 0

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	var half_screen: float = Utility.world_y / 2
	unbloom_y = half_screen + half_screen / 2 * randf()
	$Timer.start()

func _on_timer_timeout() -> void:
	if self.position.y > unbloom_y:
		$Sprite.play(&"default")
		$Timer.stop()

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

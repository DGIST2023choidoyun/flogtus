extends Floating

var avel: float = 0.0

func _ready() -> void:
	$Sprite.frame = 0
	
	if randi() & 2:
		avel = 1
	else:
		avel = -1
	self.angular_velocity = avel

func _on_body_entered(_body: Node) -> void:
	self.angular_velocity = avel

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$Timer.wait_time = randf() * 7.0 + 3.0 # TODO: Parameterize
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
				#($Shape.shape as CircleShape2D).radius = 4
				#self.add_collision_exception_with(Frog.instance)
				collapse.emit()
		state_changed.emit()

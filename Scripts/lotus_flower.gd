extends Floating

var avel: float = 0.0

func _ready() -> void:
	$Sprite.frame = 0
	
	if randi() & 2:
		avel = 1
	else:
		avel = -1
	self.angular_velocity = avel
	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group(&"WaterFall"):
		queue_free()
	else:
		self.angular_velocity = avel
		

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$Timer.wait_time = randf() * 7.0 + 3.0
	$Timer.start()

func _on_timer_timeout() -> void:
	$Sprite.play(&"default")

# 26 -> 20 -> 12 -> 0
func _on_sprite_frame_changed() -> void:
	if $Sprite.animation == &"default":
		match $Sprite.frame:
			1:
				($Shape.shape as CircleShape2D).radius = 12
			2:
				($Shape.shape as CircleShape2D).radius = 8
			3:
				$Shape.hide()

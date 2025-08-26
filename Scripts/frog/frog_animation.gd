extends AnimatedSprite2D

var walk_frame = 0

func _on_frame_changed() -> void:
	if self.animation == &"idle" and self.frame == 4:
		%CroakSound.play()

func _on_animation_finished() -> void:
	match self.animation:
		#&"jump":
			#landed.emit()
		&"drown":
			Frog.instance.queue_free()
		&"land":
			self.play(&"idle")
		&"walk":
			self.scale.x = 1
			self.play(&"idle")

func animate(type: String, speed: float = 1.0) -> void:
	self.speed_scale = speed
	match type:
		"jump":
			if %LandPoint.is_real_jump:
				self.play(&"jump")
				%JumpSound.play()
		"drown":
			get_parent().rotation = 0
			get_parent().z_index = -1
			self.play(&"drown")
			
			%SplashSound.play()
		"ready":
			if self.animation == &"idle":
				self.play(&"ready")
		"land":
			self.play(&"land")
		"walk":
			self.play(&"walk")
			self.scale.x = 1 if walk_frame % 2 == 0 else -1
			walk_frame += 1



func _on_animation_changed() -> void:
	prints("anim", self.animation)

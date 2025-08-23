extends AnimatedSprite2D
signal landed()

func _on_frame_changed() -> void:
	if self.animation == &"idle" and self.frame == 4:
		%CroakSound.play()

func _on_animation_finished() -> void:
	self.speed_scale = 1.0
	if self.animation == &"jump":
		
		landed.emit()
		
		# 애니메이션 트리 하드코딩
		if self.animation == &"jump": # 착지 후에도 애니메이션 변화 없으면
			self.play(&"idle")
	elif self.animation == &"drown":
		Frog.instance.queue_free()

func jump_animate(speed: float) -> void:
	self.play(&"jump")
	self.speed_scale = speed
	
	%JumpSound.play()

func drown_animate() -> void:
	get_parent().rotation = 0
	get_parent().z_index = -1
	self.play(&"drown")
	
	%SplashSound.play()

func ready_animate() -> void:
	if self.animation == &"idle":
		self.play(&"ready")

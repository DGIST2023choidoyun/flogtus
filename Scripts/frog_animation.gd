extends AnimatedSprite2D

func _on_frame_changed() -> void:
	if self.animation == &"idle" and self.frame == 0:
		%CroakSound.play()

func _on_animation_finished() -> void:
	if self.animation == &"jump":
		# 애니메이션 트리 하드코딩
		self.play(&"idle")
		self.speed_scale = 1.0

func jump_animate(speed: float) -> void:
	self.play(&"jump")
	self.speed_scale = speed
	
	%JumpSound.play()

func drown_animate() -> void:
	self.speed_scale = 1.0
	
	get_parent().rotation = 0
	get_parent().z_index = -1
	self.play(&"drown")
	
	%SplashSound.play()

func ready_animate() -> void:
	if self.animation == &"idle":
		while self.frame <= 2:
			await self.frame_changed
		
		self.play(&"ready")

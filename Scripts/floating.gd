class_name Floating extends RigidBody2D

func float_along_fall() -> void:
	var rand_vel: int = randi() % 8 + 7
	if self.position.x < Utility.world_x * 0.5:
		self.linear_velocity.x = rand_vel
	elif self.position.x > Utility.world_x * 0.5:
		self.linear_velocity.x = -rand_vel

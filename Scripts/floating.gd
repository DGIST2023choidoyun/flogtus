class_name Floating extends RigidBody2D

func float_along_fall() -> void:
	if self.position.x < Utility.world_x * 0.5:
		self.linear_velocity.x = randi() % 10 + 5
	elif self.position.x > Utility.world_x * 0.5:
		self.linear_velocity.x = -1 * (randi() % 10) - 5

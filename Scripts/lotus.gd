class_name Lotus extends Floating

var avel: float = 0.0

func _ready() -> void:
	if randi() & 2:
		avel = 2
	else:
		avel = -2
	self.angular_velocity = avel

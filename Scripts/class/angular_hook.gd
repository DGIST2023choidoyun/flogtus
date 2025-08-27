class_name AngularHook extends Object

func _init(target: RigidBody2D) -> void:
	var avel: float
	if randi() & 2:
		avel = 2
	else:
		avel = -2
	target.angular_velocity = avel

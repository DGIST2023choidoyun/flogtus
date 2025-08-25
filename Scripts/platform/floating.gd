class_name Floating extends Platform

enum { LOTUS_LEAF, LOTUS_FLOWER }

static func count() -> int:
	return Counter.how_many(&"Floating")
	
func _float_along_fall(flow_speed: float = River.flow_speed, damp: float = River.damp) -> void:
	self.gravity_scale = flow_speed
	self.linear_damp = damp
	self.linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE

func _enter_tree() -> void:
	_float_along_fall()
	self.rotation = randf() * TAU

func _exit_tree() -> void:
	for child in get_children():
		if child is Frog:
			child.drown()
			break
	

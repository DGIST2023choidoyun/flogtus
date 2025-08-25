class_name Platform extends RigidBody2D

enum { FLOATING }

static func count() -> int:
	return Counter.how_many(&"Platform")

signal state_changed() # frog to land
signal collapse() # frog to drown

var has_state: bool = true
var can_collapse: bool = true

func get_space_radius() -> float:
	return 0.0

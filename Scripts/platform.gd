class_name Platform extends RigidBody2D

signal state_changed()
signal collapse()

var has_state: bool = true
var can_collapse: bool = true

func landed(frog: Frog) -> void: # 개구리와 자연스러운 연결
	if has_state and state_changed.get_connections().find(frog.land) == -1:
		state_changed.connect(frog.land)
	if can_collapse and collapse.get_connections().find(frog.drown) == -1:
		collapse.connect(frog.drown)

func takeoff(frog: Frog) -> void:
	if has_state and state_changed.get_connections().find(frog.land) != -1:
		state_changed.disconnect(frog.land)
	if can_collapse and collapse.get_connections().find(frog.drown) != -1:
		collapse.disconnect(frog.drown)

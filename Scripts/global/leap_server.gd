extends Node

var frog: Frog
func connect_frog(real_frog: Frog) -> void:
	frog = real_frog
	frog.body_entered.connect(landed)
	frog.body_exited.connect(takeoff)

func landed(platform: Node2D) -> void: # 개구리와 자연스러운 연결
	if platform is Lotus:
		var lotus: Lotus = platform as Lotus
		if lotus.has_state and not lotus.state_changed.is_connected(frog.land):
			lotus.state_changed.connect(frog.land)
		if lotus.can_collapse and not lotus.collapse.is_connected(frog.drown):
			lotus.collapse.connect(frog.drown)

func takeoff(platform: Node2D) -> void:
	if platform is Lotus:
		var lotus: Lotus = platform as Lotus
		if lotus.has_state and lotus.state_changed.is_connected(frog.land):
			lotus.state_changed.disconnect(frog.land)
		if lotus.can_collapse and lotus.collapse.is_connected(frog.drown):
			lotus.collapse.disconnect(frog.drown)

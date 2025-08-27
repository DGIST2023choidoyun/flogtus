extends Node

var frog: Frog
func connect_frog(real_frog: Frog) -> void:
	frog = real_frog
	frog.body_entered.connect(landed)
	frog.body_exited.connect(takeoff)

func landed(platform: Platform) -> void: # 개구리와 자연스러운 연결
	if platform.has_state and not platform.state_changed.is_connected(frog.step):
		platform.state_changed.connect(frog.step)
	if platform.can_collapse and not platform.collapse.is_connected(frog.drown):
		platform.collapse.connect(frog.drown)
	
	platform.landed(frog)

func takeoff(platform: Platform) -> void:
	if platform.has_state and platform.state_changed.is_connected(frog.step):
		platform.state_changed.disconnect(frog.step)
	if platform.can_collapse and platform.collapse.is_connected(frog.drown):
		platform.collapse.disconnect(frog.drown)
	
	platform.takeoff(frog)

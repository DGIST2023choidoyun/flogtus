extends Node

var frog: Frog
func connect_frog(real_frog: Frog) -> void:
	frog = real_frog

func landed(platform: Platform) -> void: # 개구리와 자연스러운 연결
	if platform is Lotus:
		var lotus: Lotus = platform as Lotus
		if lotus.has_state and not lotus.state_changed.is_connected(frog.land):
			lotus.state_changed.connect(frog.land)
		if lotus.can_collapse and not lotus.collapse.is_connected(frog.drown):
			lotus.collapse.connect(frog.drown)
	
		var wave: Node2D = load("res://objects/wave.tscn").instantiate()
		get_tree().root.add_child(wave)
		wave.position = platform.position
		wave.show()
		
		print("asd")
	

func takeoff(platform: Platform) -> void:
	if platform is Lotus:
		var lotus: Lotus = platform as Lotus
		if lotus.has_state and lotus.state_changed.is_connected(frog.land):
			lotus.state_changed.disconnect(frog.land)
		if lotus.can_collapse and lotus.collapse.is_connected(frog.drown):
			lotus.collapse.disconnect(frog.drown)

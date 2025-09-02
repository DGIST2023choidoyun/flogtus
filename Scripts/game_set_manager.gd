class_name GameSetManager extends Node2D

signal game_inited()
signal game_started()

var main_floating: Floating

func _ready() -> void:
	Data.add_listener(&"game_init", initialize)
	initialize()

func initialize() -> void:
	var frog: Frog = Frog.instance
	
	Floating.freeze()
	
	# first floating
	main_floating = await %FloatingGenerator.generate_one_with_frog_centered(Floating.LOTUS_LEAF, LotusLeaf.SIZE.LARGE, Utility.world_center + Vector2.UP * 6, PI)
	
	frog.rotation = 0
	
	game_inited.emit()
	
	# other floatings
	var hard_seed: Array[Dock] = [Dock.new(Vector2(0, Utility.world_y + 20), 0.0, null)]
	var restrain: Array[Dock] = [Dock.make_from(main_floating)]
	
	%FloatingGenerator.generate(hard_seed, restrain, true, Rect2(0, -1000, Utility.world_x, Utility.world_y + 1010))

func game_start() -> void:
	#main_floating.flow()
	Floating.unfreeze()
	
	Frog.instance.wake_up()
	
	game_started.emit()
	
	await %CameraManager.camera.zoomed_out
	
	Frog.instance.make_controllable()

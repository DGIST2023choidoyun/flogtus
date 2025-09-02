class_name GameSetManager extends Node2D

signal game_inited()
signal game_started()

var main_floating: Floating

func _ready() -> void:
	Data.add_listener(&"game_init", initialize)
	initialize()

func initialize() -> void:
	Floating.freeze()
	
	main_floating = load("res://objects/lotus_leaf.tscn").instantiate()
	var frog: Frog = load("res://objects/frog.tscn").instantiate()
	main_floating.no_slosh = true
	
	await get_tree().process_frame
	
	get_tree().root.add_child(main_floating)
	main_floating.add_child(frog)
	
	main_floating.assign_size(LotusLeaf.SIZE.LARGE)
	main_floating.angular_velocity = 0
	main_floating.rotation = 0
	main_floating.global_position = Utility.world_center + Vector2.UP * 6
	
	frog.position = Vector2.ZERO + Vector2.DOWN * 3
	frog.rotation = PI
	
	game_inited.emit()
	
	var hard_seed: Array[Dock] = [Dock.new(Vector2(0, Utility.world_y + 20), 0.0, null)]
	var restrain: Array[Dock] = [Dock.make_from(main_floating)]
	
	
	%FloatingGenerator.generate(hard_seed, restrain, true, Rect2(0, -1000, Utility.world_x, Utility.world_y + 1010))

func game_start() -> void:
	AngularHook.assign_avel(main_floating)
	#main_floating.flow()
	Floating.unfreeze()
	
	Frog.instance.wake_up()
	
	game_started.emit()
	
	await %Camera.zoomed_out
	
	Frog.instance.make_controllable()

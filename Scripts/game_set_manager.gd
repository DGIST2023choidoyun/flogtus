class_name GameSetManager extends Node2D

signal game_inited()
signal game_started()

var main_floating: Floating

func _ready() -> void:
	Data.add_listener(&"game_init", initialize)
	initialize()

func initialize() -> void:
	main_floating = load("res://objects/lotus_leaf.tscn").instantiate() as LotusLeaf
	var frog: Frog = load("res://objects/frog.tscn").instantiate()
	
	await get_tree().process_frame
	
	get_tree().root.add_child(main_floating)
	main_floating.add_child(frog)
	
	main_floating.assign_size(LotusLeaf.SIZE.LARGE)
	main_floating.angular_velocity = 0
	main_floating.linear_velocity.y = 0
	main_floating.rotation = 0
	main_floating.global_position = Utility.world_center + Vector2.UP * 6
	
	frog.position = Vector2.ZERO
	
	game_inited.emit()

func game_start() -> void:
	AngularHook.assign_avel(main_floating)
	game_started.emit()
	
	await %Camera.zoomed_out
	
	main_floating.flow()
	Frog.instance.make_controllable()

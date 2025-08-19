extends Node2D

var lotus_leaf: PackedScene = preload("res://Objects/lotus_leaf.tscn")
var lotus_flower: PackedScene = preload("res://Objects/lotus_flower.tscn")

func _ready() -> void:
	self.position = Vector2.ZERO

func start_generation() -> void:
	$Timer.start()
	$Timer.wait_time = random_time()

func generate() -> void:
	$Timer.wait_time = random_time()
	
	var ratio: float = randf()
	var pos_ratio: float = randf()
	var pad: Floating
	
	%SpawnPoint.progress_ratio = pos_ratio
	
	if ratio > 0.00:
		pad = lotus_leaf.instantiate()
	else:
		pad = lotus_flower.instantiate()
	
	get_tree().root.add_child(pad)
	pad.position = %SpawnPoint.position
	pad.float_along_fall()

func random_time() -> float:
	return Utility.rand_normal(0.5, 0.075) * 1.0 + 0.2

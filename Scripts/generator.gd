extends Node2D

var lotus_leaf: PackedScene = preload("res://Objects/lotus_leaf.tscn")
var lotus_flower: PackedScene = preload("res://Objects/lotus_flower.tscn")

var flow_speed: float = 0.005 # == gravity

func _ready() -> void:
	self.position = Vector2.ZERO

func start_generation() -> void:
	$Timer.start()
	$Timer.wait_time = random_time()

func generate() -> void:
	# 로직 수정 필요: 랜덤 -> 알고리즘 적용
	var ratio: float = randf()
	var pad: Floating
	var pos_ratio: float = -1
	
	while pos_ratio == -1 or %Range.get_overlapping_bodies().size() > 0:
		pos_ratio = randf()
		
		%SpawnPoint.progress_ratio = pos_ratio
		
		await get_tree().physics_frame
	
	$Timer.wait_time = random_time()
	
	if ratio > 0.10:
		pad = lotus_leaf.instantiate()
	else:
		pad = lotus_flower.instantiate()
	
	pad.gravity_scale = flow_speed
	get_tree().root.add_child(pad)
	pad.position = %SpawnPoint.position
	pad.float_along_fall()

func random_time() -> float:
	return Utility.rand_normal(0.5, 0.075) * 1.0 + 0.2

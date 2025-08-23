class_name LotusLeaf extends Lotus

enum SIZE { TINI = 10, SMALL = 15, MEDIUM = 20, BIG = 25, LARGE = 30 }

var shape_size: int = 0

func _ready() -> void:
	super()
	
	$Shape.shape.radius = shape_size
	
	match shape_size:
		SIZE.TINI:
			$Sprite.texture = load("res://textures/lotus_leaf_tini.png")
		SIZE.SMALL:
			$Sprite.texture = load("res://textures/lotus_leaf_small.png")
		SIZE.MEDIUM:
			$Sprite.texture = load("res://textures/lotus_leaf_medium.png")
		SIZE.BIG:
			$Sprite.texture = load("res://textures/lotus_leaf_big.png")
		SIZE.LARGE:
			$Sprite.texture = load("res://textures/lotus_leaf_large.png")
	
	has_state = false
	can_collapse = false

static func rand_size() -> SIZE:
	var ratio: float = randf()
	
	if ratio > 0.65: # 35%
		return SIZE.LARGE
	elif ratio > 0.35: # 30%
		return SIZE.BIG
	elif ratio > 0.15: # 20%
		return SIZE.MEDIUM
	elif ratio > 0.05: # 10%
		return SIZE.SMALL
	else: # 5%
		return SIZE.TINI

func set_size(size: int) -> void:
	shape_size = size
	

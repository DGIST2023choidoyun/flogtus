extends Floating

enum SIZE { TINI = 10, SMALL = 15, MEDIUM = 20, BIG = 25, LARGE = 30 }

var avel: float = 0.0

func _ready() -> void:
	var size: int = _rand_size()
	($Shape.shape as CircleShape2D).radius = size # 약간의 패딩을 줌
	
	if randi() & 2:
		avel = 1
	else:
		avel = -1
	self.angular_velocity = avel
	
	match size:
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

func _rand_size() -> SIZE:
	var ratio: float = randf()
	
	if ratio > 0.70:
		return SIZE.LARGE
	elif ratio > 0.50:
		return SIZE.BIG
	elif ratio > 0.30:
		return SIZE.MEDIUM
	elif ratio > 0.10:
		return SIZE.SMALL
	else:
		return SIZE.TINI

func _on_body_entered(_body: Node) -> void:
	self.angular_velocity = avel

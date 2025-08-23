extends Sprite2D

@onready var sprite_radius: float = self.texture.get_size().x / 2
const wave_speed: float = 50.0
static var half_screen_diag: float = sqrt(Utility.world_x ** 2 + Utility.world_y ** 2)
static var screen_middle: Vector2 = Vector2(Utility.world_x / 2, Utility.world_y / 2)

func _ready() -> void:
	self.scale = Vector2.ZERO
	set_process(false)
	self.hide()
	

func _process(delta: float) -> void:
	self.scale += Vector2.ONE * delta * (wave_speed / sprite_radius)
	if self.scale.x * sprite_radius - 20.0 > half_screen_diag + (self.position - screen_middle).length(): # padding = 20
		queue_free()

func _draw() -> void:
	set_process(true)

func splash() -> void:
	reparent(get_tree().root)
	self.show()

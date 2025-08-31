extends AnimatedSprite2D

func _ready() -> void:
	OrderingHook.assign_order(self, OrderingHook.WATER_FALL)

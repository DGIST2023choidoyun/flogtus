class_name Lotus extends Floating

static func count() -> int:
	return Counter.how_many(&"Lotus")
	
var avel: float = 0.0 # 각속도

func _ready() -> void:
	if randi() & 2:
		avel = 2
	else:
		avel = -2
	self.angular_velocity = avel

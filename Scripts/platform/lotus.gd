class_name Lotus extends Floating

static func count() -> int:
	return Counter.how_many(&"Lotus")
	
var avel: float = 0.0 # 각속도

func _ready() -> void:
	AngularHook.new(self)

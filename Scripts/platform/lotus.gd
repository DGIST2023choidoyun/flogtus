class_name Lotus extends Floating

static func count() -> int:
	return Counter.how_many(&"Lotus")
	
var avel: float = 0.0 # 각속도

func _ready() -> void:
	AngularHook.new(self)

func landed(_frog: Frog) -> void:
	var tween := create_tween()
	var dur:= 2.0

	tween.tween_method(_slosh, 0.0, 1.0, dur
	).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(
		func():
			$Sprite.scale = Vector2.ONE
			$Sprite.position = Vector2.ZERO
	)

func _slosh(t: float) -> void:
	var k := 8.0
	var freq := 2.0
	
	var slosh: float = 0.2 * exp(-k * t) * -sin(TAU * freq * t)
	
	$Sprite.scale = Vector2(1 + slosh, 1 + slosh)

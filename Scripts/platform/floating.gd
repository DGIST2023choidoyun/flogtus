class_name Floating extends Platform

var no_slosh: bool = false

enum { LOTUS_LEAF, LOTUS_FLOWER }

static func count() -> int:
	return Counter.how_many(&"Floating")
	
func flow() -> void:
	self.gravity_scale = 0.0
	self.linear_damp = 0.0
	self.linear_velocity.y = River.flow_speed

func _ready() -> void:
	AngularHook.assign_avel(self)

func _enter_tree() -> void:
	super()
	flow()
	self.rotation = randf() * TAU

	'''화면에서 벗어나면 삭제, notifier가 회전효과로 엉뚱하게 감지되지 않게 처리'''
	var remote: RemoteTransform2D = RemoteTransform2D.new()
	var notifier: VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()
	
	add_child(remote)
	add_child(notifier)
	
	remote.remote_path = notifier.get_path()
	remote.update_rotation = false
	notifier.top_level = true
	notifier.rect = Rect2(-40, -40, 80, 80)
	notifier.screen_exited.connect(_clean_up)
	

func _clean_up() -> void:
	for child in get_children():
		if child is Frog:
			child.drown()
			break
	

func landed(_frog: Frog) -> void:
	if no_slosh:
		return
	
	var tween := create_tween()
	var dur:= 2.0

	tween.tween_method(
		func(t: float) -> void:
			var k := 8.0
			var freq := 2.0
			
			var slosh: float = 0.2 * exp(-k * t) * -sin(TAU * freq * t)
			
			$Sprite.scale = Vector2(1 + slosh, 1 + slosh), 0.0, 1.0, dur
	).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(
		func() -> void:
			$Sprite.scale = Vector2.ONE
			$Sprite.position = Vector2.ZERO
	)

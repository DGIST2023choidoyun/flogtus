extends Area2D

const max_dist: float = 100.0
const charge_full: float = 1.0

var on_floor: bool = true
#var charging: bool = false

var pad_name: String = ""

func _ready() -> void:
	$Timer.wait_time = charge_full

func _process(_delta: float) -> void:
	var charged: float = charge_full - $Timer.time_left
	var dest: Vector2 = Vector2.UP * charged / charge_full * max_dist
	
	$LandPoint.position = dest

func _input(_event: InputEvent) -> void:
	if not on_floor:
		return
	elif Input.is_action_just_pressed(&"Jump"):
		$Timer.start()
		set_process(true)
		$LandPoint.show()
		
		$Sprite.ready_animate()
		
	elif Input.is_action_just_released(&"Jump"):
		var charged: float = charge_full - $Timer.time_left
		var pos_tween: Tween = create_tween()
		var tween_time: float = charged * 0.4
		
		# 이동
		self.reparent(get_tree().root) # 점프 도중에는 자유로움
		pos_tween.tween_property(self, "global_position", $LandPoint.global_position, tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
		$LandPoint.hide()
		set_process(false)
		
		# 타이머 초기화
		$Timer.wait_time = charge_full
		
		# 애니메이션 설정
		$Sprite.jump_animate(1.0 / tween_time)
		
		#플래그 설정
		on_floor = false

func land() -> void:
	var floating: Node2D = self.get_overlapping_bodies().pop_back()
	
	if floating == null:
		game_over()
		
		$Sprite.drown_animate()
		return
	
	var local_pos: Vector2 = floating.to_local(self.global_position)
	var glob_rot: float = self.global_rotation
	
	self.reparent(floating, false)
	await get_tree().physics_frame
	await get_tree().physics_frame
	self.position = local_pos
	self.global_rotation = glob_rot
	on_floor = true
	
	if pad_name != floating.name:
		Data.earn_score(floating)
		pad_name = floating.name

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	game_over()

func game_over() -> void:
	print("game over")

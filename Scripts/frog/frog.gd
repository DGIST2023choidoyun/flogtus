class_name Frog extends Area2D

enum STATE { NONE = -1, LANDED, JUMPED, DROWNED, CNT }
var state: STATE = STATE.NONE

const max_dist: float = 100.0
const charge_full: float = 1.0

const over_air_coef: float = 0.4 # 채공시간 계수

var platform: Platform = null

var is_ready: bool = false

static var instance: Frog = null # singleton

func _state(value: STATE) -> void:
	match value:
		STATE.LANDED:
			'''바닥 체크 후 처리'''
			if state != STATE.NONE and state != STATE.JUMPED and state != STATE.LANDED:
				return
			var pad: Platform = _check_floor()
			if pad == null:
				drown.call_deferred()
			else:
				if self.platform != pad: # 바닥 같으면 처리 안 함
					var local_pos: Vector2 = pad.to_local(self.global_position)
					var glob_rot: float = self.global_rotation

					self.reparent(pad, false)
					self.position = local_pos
					self.global_rotation = glob_rot
					
					if self.platform != null:
						Data.earn_score(pad)
				
					self.platform = pad
					
					self.monitoring = true
					
					$Sprite.animate("land")
				if not %LandPoint.is_real_jump:
					$Sprite.animate("walk")
		STATE.JUMPED:
			'''점프 애니메이션 설정'''
			if state != STATE.LANDED and not is_ready:
				return
			var charged: float = charge_full - $ChargeTimer.time_left
			var pos_tween: Tween = create_tween()
			var tween_time: float = charged * over_air_coef
			
			# 이동
			pos_tween.tween_property(self, "global_position", $LandPoint.global_position, tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			pos_tween.finished.connect(land)
			
			$LandPoint.hide()
			set_process(false)
			
			# 타이머 초기화
			$ChargeTimer.wait_time = charge_full
			
			# 애니메이션 설정
			$Sprite.animate("jump", 0.6 / tween_time)
			
			self.monitoring = false
		STATE.DROWNED:
			if state != STATE.LANDED:
				return
			self.reparent(get_tree().current_scene)
			$Sprite.animate("drown")
			$LandPoint.hide()
			game_over()
			
		STATE.CNT:
			return
	state = value

func _ready() -> void:
	$ChargeTimer.wait_time = charge_full
	LeapServer.connect_frog(self)
	
	if instance != null:
		queue_free()
	else:
		instance = self
	
	await get_tree().physics_frame
	land()

func _input(_event: InputEvent) -> void:
	if state != STATE.LANDED:
		return
	elif Input.is_action_just_pressed(&"Jump"):
		'''점프 타이머 & 착지 지점 설정'''
		$ChargeTimer.start()
		$LandPoint.show()
		
		is_ready = true
		
		await get_tree().create_timer(0.1).timeout
		if is_ready:
			$Sprite.animate("ready")
	elif Input.is_action_just_released(&"Jump"):
		_state(STATE.JUMPED)
		
		is_ready = false

func land() -> void:
	_state(STATE.LANDED)

func drown() -> void:
	_state(STATE.DROWNED)

func _check_floor() -> Platform:
	var dss: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var qp: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	qp.shape = $Shape.shape
	qp.transform = self.global_transform
	qp.collision_mask = self.collision_mask
	var hits: Array[Dictionary] = dss.intersect_shape(qp)
	
	if hits.size() > 0:
		return hits[0].collider
	else:
		return null

func game_over() -> void:
	$Wave.splash()
	#Data.frog_die()

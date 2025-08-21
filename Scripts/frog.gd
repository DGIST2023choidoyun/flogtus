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
			var platform: Platform = check_floor()
			if platform == null:
				drown.call_deferred()
			else:
				if self.platform != platform: # 바닥 같으면 처리 안 함
					var local_pos: Vector2 = platform.to_local(self.global_position)
					var glob_rot: float = self.global_rotation
					# TODO
					self.reparent(platform, false)
					await get_tree().physics_frame
					await get_tree().physics_frame
					self.position = local_pos
					self.global_rotation = glob_rot
					
					if self.platform != null:
						self.platform.takeoff(self)
						Data.earn_score(platform)
					platform.landed(self)
				
				
			self.platform = platform
		STATE.JUMPED:
			'''점프 애니메이션 설정'''
			if state != STATE.LANDED and not is_ready:
				return
			var charged: float = charge_full - $ChargeTimer.time_left
			var pos_tween: Tween = create_tween()
			var tween_time: float = charged * over_air_coef
			
			# 이동
			pos_tween.tween_property(self, "global_position", $LandPoint.global_position, tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			
			$LandPoint.hide()
			set_process(false)
			
			# 타이머 초기화
			$ChargeTimer.wait_time = charge_full
			
			# 애니메이션 설정
			$Sprite.jump_animate(1.0 / tween_time)
		STATE.DROWNED:
			if state != STATE.LANDED:
				return
			self.reparent(get_tree().root)
			$Sprite.drown_animate()
			game_over()
			
			if self.platform != null:
				self.platform.takeoff(self)
		STATE.CNT:
			return
	state = value

func _ready() -> void:
	$ChargeTimer.wait_time = charge_full
	
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
		$Sprite.ready_animate()
		
		is_ready = true
	elif Input.is_action_just_released(&"Jump"):
		_state(STATE.JUMPED)
		
		is_ready = false

func land() -> void:
	_state(STATE.LANDED)

func drown() -> void:
	_state(STATE.DROWNED)

func check_floor() -> Platform:
	'''단순 체크, 물리 정보를 기반으로 하나만 반환'''
	#TODO: 체크 방식 변경?
	var platform: Platform = self.get_overlapping_bodies().pop_back()
	return platform

func game_over() -> void:
	print("game over")

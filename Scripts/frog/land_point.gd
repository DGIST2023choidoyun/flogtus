extends Marker2D

const jump_thres: float = 15.0
const init_scale: float = 0.6

var is_real_jump: bool = false

func _ready() -> void:
	self.scale = Vector2.ONE * init_scale
	self.hide()
	set_physics_process(false)

func _process(_delta: float) -> void:
	var charged: float = Frog.charge_full - %ChargeTimer.time_left
	var ratio: float = charged / Frog.charge_full
	var target_pos: Vector2 = Vector2.UP * Frog.max_dist * ratio
	var dest: float = target_pos.length()
	
	if not is_real_jump and dest >= jump_thres:
		is_real_jump = true
	self.position = target_pos
	self.scale = Vector2.ONE * ((1.0 - init_scale) * ratio + init_scale)
	
	$Trajectory.region_rect.size.y = dest * 0.92

func _physics_process(_delta: float) -> void:
	$Tracker.position = self.global_position
	
	if self.global_position.x < 0:
		$Tracker.rotation = 0
		$Tracker.position.x = 0
	elif self.global_position.x > Utility.world_x:
		$Tracker.rotation = PI
		$Tracker.position.x = Utility.world_x
	
	if self.global_position.y < 0:
		$Tracker.rotation = PI / 2
		$Tracker.position.y = 0
	elif self.global_position.y > Utility.world_y:
		$Tracker.rotation = -PI / 2
		$Tracker.position.y = Utility.world_y

func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		if visible:
			set_process(true)
			is_real_jump = false
			
			_show_tracker()
		else:
			set_process(false)
			set_deferred(&"position", Vector2.ZERO)

func _show_tracker() -> void:
	# TODO: main에서 첫 로드 후 tracker가 바로 보임.
	if Utility.world_rect.has_point(self.global_position):
		return
	$Tracker.show()
	set_physics_process(true)

func _hide_tracker() -> void:
	if Utility.world_rect.has_point(self.global_position):
		return
	$Tracker.hide()
	set_physics_process(false)

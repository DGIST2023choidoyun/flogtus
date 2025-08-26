extends Marker2D

const jump_thres: float = 15.0

var is_real_jump: bool = false

func _ready() -> void:
	self.hide()

func _process(_delta: float) -> void:
	var charged: float = Frog.charge_full - %ChargeTimer.time_left
	var dest: Vector2 = Vector2.UP * charged / Frog.charge_full * Frog.max_dist
	
	if not is_real_jump and dest.length() >= jump_thres:
		is_real_jump = true
	self.position = dest

func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		if visible:
			set_process(true)
			is_real_jump = false
		else:
			set_process(false)
			set_deferred(&"position", Vector2.ZERO)

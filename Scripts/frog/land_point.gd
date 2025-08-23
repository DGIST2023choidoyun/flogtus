extends Marker2D

func _process(_delta: float) -> void:
	var charged: float = Frog.charge_full - %ChargeTimer.time_left
	var dest: Vector2 = Vector2.UP * charged / Frog.charge_full * Frog.max_dist
	
	if dest.length() >= 12.0:
		$Sprite2D.show()
	self.position = dest

func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		if visible:
			set_process(true)
		else:
			set_process(false)
			self.position = Vector2.ZERO
			$Sprite2D.hide()

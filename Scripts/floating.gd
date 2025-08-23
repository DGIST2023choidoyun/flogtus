class_name Floating extends Platform

func float_along_fall(flow_speed: float = River.flow_speed, damp: float = River.damp) -> void:
	self.gravity_scale = flow_speed
	self.linear_damp = damp
	self.linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE

func _enter_tree() -> void:
	'''화면에서 벗어나면 삭제, notifier가 회전효과로 엉뚱하게 감지되지 않게 처리'''
	var remote: RemoteTransform2D = RemoteTransform2D.new()
	var notifier: VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()
	
	add_child(remote)
	add_child(notifier)
	
	remote.remote_path = notifier.get_path()
	remote.update_rotation = false
	notifier.top_level = true
	notifier.rect = Rect2(-40, -40, 80, 80)
	notifier.screen_exited.connect(
		func() -> void:
			FloatingGenerator.floating_cnt -= 1
			for child in get_children():
				if child is Frog:
					child.drown()
					break
			queue_free())
	
	FloatingGenerator.floating_cnt += 1

extends Node

var frog: Frog
func connect_frog(real_frog: Frog) -> void:
	frog = real_frog
	frog.body_entered.connect(landed)
	frog.body_exited.connect(takeoff)

func landed(platform: Platform) -> void: # 개구리와 자연스러운 연결
	if platform.has_state and not platform.state_changed.is_connected(frog.land):
		platform.state_changed.connect(frog.land)
	if platform.can_collapse and not platform.collapse.is_connected(frog.drown):
		platform.collapse.connect(frog.drown)
		
	# TODO
	var tw := create_tween()
	var k := 4.0              # 감쇠 (클수록 빨리 잦아듦)
	var freq := 3.5           # 진동수(헤르츠 개념 아님; 아래 w와 곱해짐)
	var w := TAU * freq
	var dur:= 0.25

	tw.tween_method(
		func(t):
			var e := exp(-k * t)
			var c := -sin(w * t)

			# 스쿼시&스트레치: x는 +, y는 - 로 역상
			var squash := 0.2 * e * c
			platform.get_child(0).scale = Vector2(1 + squash, 1 - squash)

	, 0.0, 1.0, dur
	).set_ease(Tween.EASE_IN_OUT)
	
	tw.finished.connect(func():
		platform.get_child(0).scale = Vector2.ONE
		platform.get_child(0).position = Vector2.ZERO
	)

func takeoff(platform: Platform) -> void:
	if platform.has_state and platform.state_changed.is_connected(frog.land):
		platform.state_changed.disconnect(frog.land)
	if platform.can_collapse and platform.collapse.is_connected(frog.drown):
		platform.collapse.disconnect(frog.drown)

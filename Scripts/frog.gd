extends Area2D

const dist: float = 100.0
const charge_full: float = 1.0

func _ready() -> void:
	$Timer.wait_time = charge_full

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Jump"):
		$Sprite.frame = 1
		$Timer.start()
	elif Input.is_action_just_released("Jump"):
		var charged: float = charge_full - $Timer.time_left
		$Timer.wait_time = charge_full
		

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	# game over
	

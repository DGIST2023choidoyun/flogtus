extends Control

var showing: bool = false
var skip: bool = false

var score: int = 0

func _ready() -> void:
	Data.add_listener(&"init", _initialize)

func _initialize() -> void:
	$Base.position = Vector2(Utility.world_x / 2, Utility.world_y / 2 - 32)
	$Base.frame = 0
	skip = false

func show_result(last_score: int) -> void:
	score = last_score
	await _move_right()
	showing = true
	
	if not skip:
		$Base.play()
	_set_score_text()
	await $Base.animation_finished
	
	if not skip:
		$Base/Info/Croak.play()
	
	await get_tree().create_timer(6.0).timeout
	
	if not skip:
		await _go_away()

func _go_away() -> void:
	await _move_right()
	Data.restart_game()
	
	showing = false

func _set_score_text() -> void:
	$Base/Info/Score.text = "{0}".format([score])

func _move_right() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"position:x", self.position.x + Utility.world_x, 1.5).set_trans(Tween.TRANS_BACK)
	
	await tween.finished


func _screen_touched() -> void:
	if showing and not skip:
		skip = true
		_set_score_text()
		$Base.stop()
		$Base.frame = 5
		await _go_away()

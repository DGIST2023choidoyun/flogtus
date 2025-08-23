extends Node
signal score_changed(value: int)
signal game_over(score: int)
signal init()
signal game_set()

var score: int = 0:
	set(v):
		if v < 0:
			v = 0
		score = v;
		score_changed.emit(v)

func add_listener(signal_name: StringName, callable: Callable) -> void:
	if has_signal(signal_name):
		connect(signal_name, callable)

func earn_score(floating: Platform) -> void:
	if floating != null and floating.is_in_group(&"Flower"):
		score += 2 # 꽃은 2점
	else:
		score += 1

func frog_die() -> void:
	game_over.emit(score)
	init.emit()
	score = 0 # 점수 초기화

func restart_game() -> void:
	game_set.emit()

extends Node
signal score_changed(value: int)

var is_first: bool = true
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
	if floating != null and floating.is_in_group(&"LotusFlower"):
		score += 2 # 꽃은 2점
	else:
		score += 1

class_name FloatingGenerator extends Generator

@export var max_cnt: int = 20 # 지속적인 소환으로 느껴질 수 있는 개수여야 함.
@export var _cnt_per_tick: int = 5 # 이번 틱의 앵커가 두 틱 전의 앵커와 충돌하지 않을 정도의 개수를 소환해야 함. 단, 적절히 restrait 되는 개수로 설정해야 함.
@export var _ratio: Array[float] = [0.95, 0.05]

const _30_deg: float = PI / 6
const _floating_scenes: Array[PackedScene] = [
	preload("res://objects/lotus_leaf.tscn"),
	preload("res://objects/lotus_flower.tscn")
]
var _lowest_anchor: Anchor = Anchor.new(Vector2.DOWN * Utility.world_y, 0.0, null)
const _zero_vel: float = 25.0

var min_gap: float = 20.0
var max_gap: float = Frog.max_dist - 20.0

var _gen_prob: Array[float] = []
var _seeds: Array[Anchor] = []

func _ready() -> void:
	SingletonHook.new(self)

	for i in _ratio.size(): # 누적 확률
		_gen_prob.append(_ratio[i] + (_gen_prob[i - 1] if i > 0 else 0.0))
	
	#Data.add_listener(&"init", _initialize)
	_initialize() # 보류

func _initialize() -> void:
	_seeds.clear()
	$Tick.stop()
	
func start_generation() -> void:
	$Tick.start()

func generate() -> void:
	var test_msec = Time.get_ticks_msec()
	if Floating.count() >= max_cnt:
		return
	if _seeds.is_empty():
		_seeds.append(Anchor.new(Vector2(randf() * Utility.world_x, -screen_padding), 0, null))
	else:
		_update_seeds()
		prints("seed aft", _seeds.map(func(seed): return "{0}: {1} / ".format([seed.platform.name, seed.disk.pos.y])))
		prints("seed aft ==================")
	var active_list: Array[Anchor] = [_seeds[0]] # 생성 기준점이 될 수 있는 앵커 집합, 처음에는 가장 상위의 앵커만
	var restrain_list: Array[Anchor] = _seeds.duplicate() # 거리 조건 검사를 위한 앵커 집합
	var highest_anchor: Anchor = _lowest_anchor

	#if _seeds[0].platform == null:
		#_seeds.pop_front()
	_seeds.clear()
	var test_color = Color(randf(), randf(), randf())
	var test_name = str(randi())
	prints("test", test_color)
	for _i in _cnt_per_tick: # 한 틱에 생성 개수 고정
		var new_floating: Floating = _gen_floating()
		var new_size: float = new_floating.get_space_radius()
		if new_floating == null:
			continue
		
		new_floating.name = test_name
		new_floating.modulate = test_color
		while true: # 위치 탐색
			var norm: Anchor = active_list.pick_random()
			var dir: Vector2 = Vector2.RIGHT.rotated(randf_range(-_30_deg, 0) + (_30_deg + PI) * (randi() % 2))
			var candidate_pos: Vector2 = norm.disk.pos + dir * (norm.disk.radius + new_size + randf_range(min_gap, max_gap))

			if candidate_pos.y + new_size > 0 or candidate_pos.x < 0 or candidate_pos.x > Utility.world_x:
				continue # 화면 안쪽 또는 화면 가로 밖이면 다시 시도

			var is_valid: bool = true
			var candidate_disk: Disk = Disk.new(candidate_pos, new_size) # 거리 비교 위한 디스크 생성

			for anchor: Anchor in restrain_list:
				if Disk.gap(candidate_disk, anchor.disk) < min_gap:
					is_valid = false
					continue
			
			if is_valid:
				var new_anchor: Anchor = Anchor.new(candidate_pos, new_size, new_floating)
				active_list.append(new_anchor)
				restrain_list.append(new_anchor)
				
				if highest_anchor.disk.pos.y - highest_anchor.disk.radius > new_anchor.disk.pos.y - new_anchor.disk.radius:
					highest_anchor = new_anchor
					_seeds.push_front(new_anchor) # 결국 가장 위에 있는 앵커가 0 index임.
				else:
					_seeds.push_back(new_anchor)

				# floating 활성화
				new_floating.position = candidate_pos
				new_floating.show()
				new_floating.linear_velocity.y = sqrt(_zero_vel ** 2 - 2 * River.flow_speed * new_floating.position.y)
				prints("vel", sqrt(_zero_vel ** 2 - 2 * River.flow_speed * new_floating.position.y))
				break
	
	prints("seed bef ==================")
	prints("seed bef", _seeds.map(func(seed): return "{0}: {1} / ".format([seed.platform.name, seed.disk.pos.y])))
	
	prints("time", Time.get_ticks_msec() - test_msec)

func _rand_type() -> int:
	var r: float = randf()
	for i in _gen_prob.size():
		if r < _gen_prob[i]:
			return i
	return _gen_prob.size() - 1

func _gen_floating() -> Floating:
	var type: int = _rand_type()
	var floating: Floating = _floating_scenes[type].instantiate() as Floating

	floating.hide()
	get_tree().current_scene.add_child(floating)

	# 씬에 추가만 한 뒤 반환, 위치 확정 이후 활성화
	return floating

func _update_seeds() -> void:
	for anchor in _seeds:
		anchor.update()

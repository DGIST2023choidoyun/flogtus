class_name FloatingGenerator extends Node2D

class Disk:
	var pos: Vector2
	var radius: int
	
	func _init(new_pos: Vector2, new_radius: int) -> void:
		pos = new_pos
		radius = new_radius
	
	static func gap(disk1: Disk, disk2: Disk) -> float:
		return (disk1.pos - disk2.pos).length() - disk1.radius - disk2.radius

static var instance: FloatingGenerator = null
static var floating_cnt: int = 0:
	set(v):
		if v < 0:
			v = 0
		floating_cnt = v

const lotus_leaf: PackedScene = preload("res://Objects/lotus_leaf.tscn")
const lotus_flower: PackedScene = preload("res://Objects/lotus_flower.tscn")

const gen_pos_padding: float = 40.0
const max_floating_cnt: int = 40
const max_try: int = 30
const latest_floating_cnt: int = 12
const flower_ratio: float = 0.05

var min_gap: float = 20.0
var max_gap: float = Frog.max_dist - 20.0

var seed_floatings: Array[Floating] = [] # 0 index => most highest floating

func _ready() -> void:
	if instance != null:
		queue_free()
		return
	instance = self
	
func start_generation() -> void:
	generate()
	$Timer.start()

func generate() -> void:
	if floating_cnt >= max_floating_cnt:
		return
	var active_disk: Array[Disk] = []
	var placed_disk_leaf: Array[Disk] = []
	var placed_disk_flower: Array[Disk] = []
	var nearest_seed: Disk
	var max_y: float # 최대 y 조건
	var highest_disk: Disk = Disk.new(Vector2(0, 1000), 0)
	
	for floating: Floating in seed_floatings:
		active_disk.append(_convert_floating_to_disk(floating))
	if active_disk.is_empty():
		var dummy_disk: Disk = Disk.new(Vector2(randf() * Utility.world_x, -gen_pos_padding), 0)
		active_disk.append(dummy_disk) # 더미 Disk 삽입
		nearest_seed = dummy_disk
		max_y = -gen_pos_padding
	else:
		nearest_seed = active_disk[0]
		max_y = nearest_seed.pos.y - nearest_seed.radius + max_gap - min_gap # important: radius 뒷 항에 따라 청크당 간격이 좌우됨.
	
	while floating_cnt + placed_disk_leaf.size() + placed_disk_flower.size() < max_floating_cnt and not active_disk.is_empty():
		var norm: Disk = active_disk.pick_random()
		var candidate_found: bool = false
		for _i in max_try:
			var is_flower: bool = false
			var new_size: int
			if randf() <= flower_ratio:
				new_size = LotusFlower.size
				is_flower = true
			else:
				new_size = LotusLeaf.rand_size()
			
			var dist: float = randf_range(min_gap, max_gap)
			var direction: Vector2 = Vector2.RIGHT.rotated(randf_range(-45.0 * PI / 180.0, 225.0 * PI / 180.0)) # UP으로 30도 간격까지 허용
			var candidate_pos: Vector2 = norm.pos + direction * (dist + new_size + norm.radius)
			
			if candidate_pos.y + new_size > max_y or candidate_pos.x < 0 or candidate_pos.x > Utility.world_x:
				continue # 범위 밖이면 다시 시도
			
			var is_valid: bool = true
			var new_disk: Disk = Disk.new(candidate_pos, new_size)
			var placed_disk_lotus: Array[Disk] = placed_disk_leaf.duplicate()
			placed_disk_lotus.append_array(placed_disk_flower)
			
			for disk in placed_disk_lotus: # 꽃, 잎을 전체 검증
				if disk.pos == norm.pos:
					continue
					
				var gap: float = Disk.gap(disk, new_disk)
				if gap < min_gap:
					is_valid = false
					break

			if is_valid: # 검증 성공
				active_disk.append(new_disk)
				if is_flower:
					placed_disk_flower.append(new_disk)
				else:
					placed_disk_leaf.append(new_disk)
				candidate_found = true
				
				if highest_disk.pos.y - highest_disk.radius > new_disk.pos.y - new_disk.radius:
					highest_disk = new_disk
				break
		if not candidate_found:
			active_disk.erase(norm) # 활성 점에서 후보를 찾지 못했으므로 제거
	
	seed_floatings.clear()
	
	for disk in placed_disk_leaf:
		var leaf: LotusLeaf = lotus_leaf.instantiate()
		leaf.set_size(disk.radius)
		
		_arrange_lotus(leaf, disk.pos)
		
		_plant_seed(disk, highest_disk, leaf)
	for disk in placed_disk_flower:
		var flower: LotusFlower = lotus_flower.instantiate()
		
		_arrange_lotus(flower, disk.pos)
		
		_plant_seed(disk, highest_disk, flower)

func _plant_seed(disk: Disk, highest_disk: Disk, floating: Floating) -> void:
	if disk.pos == highest_disk.pos:
		seed_floatings.push_front(floating)
	elif disk.pos.y - disk.radius - max_gap < highest_disk.pos.y - highest_disk.radius:
		seed_floatings.push_back(floating)

func _arrange_lotus(lotus: Lotus, pos: Vector2) -> void:
	get_tree().root.add_child(lotus)
	lotus.position = pos + self.position
	lotus.rotation = randf() * TAU
	lotus.float_along_fall()
	
	if Frog.instance == null: #TODO: 게임 오버 조건 추가
		var frog: Frog = load("res://objects/frog.tscn").instantiate()
		lotus.add_child(frog)
		frog.position = Vector2.ZERO # center of lotus

func _convert_floating_to_disk(floating: Floating) -> Disk:
	var collision_shape: Node = floating.get_node("./Shape")
	if collision_shape is not CollisionShape2D:
		return Disk.new(Vector2.ZERO, 0)
	elif (collision_shape as CollisionShape2D).shape is not CircleShape2D:
		return Disk.new(Vector2.ZERO, 0)
	return Disk.new(floating.position, collision_shape.shape.radius)

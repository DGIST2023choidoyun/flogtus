class_name Generator extends Node

class Disk:
	var pos: Vector2
	var radius: float
	
	func _init(new_pos: Vector2, new_radius: float) -> void:
		pos = new_pos
		radius = new_radius
	
	static func gap(disk1: Disk, disk2: Disk) -> float:
		return (disk1.pos - disk2.pos).length() - disk1.radius - disk2.radius

class Anchor:
	var disk: Disk
	var platform: Platform

	func _init(new_pos: Vector2, new_radius: float, new_platform: Platform) -> void:
		disk = Disk.new(new_pos, new_radius)
		platform = new_platform
	
	func update() -> void:
		disk.pos = platform.position
		disk.radius = platform.get_space_radius()
	
const screen_padding: float = 40.0

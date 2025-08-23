class_name Generator extends Node

class Disk:
	var pos: Vector2
	var radius: int
	
	func _init(new_pos: Vector2, new_radius: int) -> void:
		pos = new_pos
		radius = new_radius
	
	static func gap(disk1: Disk, disk2: Disk) -> float:
		return (disk1.pos - disk2.pos).length() - disk1.radius - disk2.radius


const screen_padding: float = 40.0

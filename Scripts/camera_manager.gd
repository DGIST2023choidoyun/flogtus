extends Node2D

const _zero_band_deno = 12
@onready var camera: Camera2D = $Camera

func wait_camera_rot() -> void:
	var lower: float = PI / _zero_band_deno
	while not (camera.global_rotation <= lower and camera.global_rotation >= -lower):
		await get_tree().physics_frame

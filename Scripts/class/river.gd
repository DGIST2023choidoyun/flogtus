class_name River extends Node

const damp_default: float = 0.2
const flow_speed_default: float = 4.0

static var damp: float = damp_default
static var flow_speed: float = flow_speed_default # == gravity

func init_game() -> void:
	damp = damp_default
	flow_speed = flow_speed_default

class_name Platform extends RigidBody2D

signal state_changed() # direct to frog land
signal collapse() # direct to frog drown

var has_state: bool = true
var can_collapse: bool = true

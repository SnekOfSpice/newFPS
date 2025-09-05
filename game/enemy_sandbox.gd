extends Node3D


func _ready() -> void:
	$Enemy.set_movement_target($Target.global_position)

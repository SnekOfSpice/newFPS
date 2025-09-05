extends Node3D
class_name  Room


signal player_entered(
	room : Room
)

@export var room_enter_area : Area3D


func _ready() -> void:
	room_enter_area.body_entered.connect(on_body_entered_room_enter_area)

func get_entry_point() -> Node3D:
	return find_child("Entry")
func get_exit_point() -> Node3D:
	return find_child("Exit")

func on_body_entered_room_enter_area(body:Node3D):
	if body is Player:
		emit_signal("player_entered", self)

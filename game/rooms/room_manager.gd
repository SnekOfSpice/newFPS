extends Node3D

var last_room : Room

func _ready() -> void:
	add_room("room_1")


var room_path : String
func add_room(room_id:String):
	
	
	room_path = "res://game/rooms/%s/%s.tscn" % [room_id, room_id]
	ResourceLoader.load_threaded_request(room_path)

func _process(delta: float) -> void:
	if room_path.is_empty():
		return
	var room_status := ResourceLoader.load_threaded_get_status(room_path)
	if room_status == ResourceLoader.THREAD_LOAD_LOADED:
		var target_position : Vector3
		if last_room:
			target_position = last_room.get_exit_point().global_position
		else:
			target_position = Vector3.ZERO
		
		var room_scene = ResourceLoader.load_threaded_get(room_path)
		var new_room : Room = room_scene.instantiate()
		add_child(new_room)
		new_room.global_position = target_position - new_room.get_entry_point().global_position
		new_room.player_entered.connect(on_player_entered_room)
		last_room = new_room
		room_path = ""

func on_player_entered_room(room:Room):
	if room != last_room:
		return
	add_room("room_1")

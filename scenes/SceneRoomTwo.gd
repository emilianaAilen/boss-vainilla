extends SceneRoomBase

func _ready():
	set_scene_data_name()

func set_scene_data_name():
	if (GameState.visited_rooms.size() < 2):
		dialog.scene_name = "room_2_B"
	## en tercer lugar y no dejo en vigilancia al conductor = room_2_C
	## en primer y segunda = room_2_B
	## en cuarto = room_2_A

extends SceneRoomBase

func _ready():
	pass
	#set_scene_data_name()

func set_scene_data_name():
	if (GameState.visited_rooms.size() < 2):
		GameState.scene_name_data = "room_2_A"
	## en tercer lugar y no dejo en vigilancia al conductor = room_2_C
	## en primer y segunda = room_2_B
	## en cuarto = room_2_A


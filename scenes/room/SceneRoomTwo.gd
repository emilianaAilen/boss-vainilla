extends SceneRoomBase


func _on_ready():
	set_scene_data_name()
	._on_ready()

func set_scene_data_name():
	print(GameState.visited_rooms)
	if (GameState.visited_rooms.size() == 4 && ! GameState.vigilance):
		dialog.scene_name = "room_2_C"
	elif (GameState.visited_rooms.size() == 3 && ! GameState.vigilance ):
		dialog.scene_name = "room_2_B"
	else:
		dialog.scene_name = "room_2_A"




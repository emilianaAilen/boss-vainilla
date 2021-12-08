extends SceneRoomBase


func _on_ready():
	set_scene_data_name()
	._on_ready()

func set_scene_data_name():
	if (GameState.visited_rooms.size() == 4 && ! GameState.vigilance):
		dialog.scene_name = "room_2_C"
	elif (GameState.visited_rooms.size() == 3 && ! GameState.vigilance ):
		dialog.scene_name = "room_2_B"
	else:
		dialog.scene_name = "room_2_A"

func play_animation(type_animation):
	GameState.next_scene = "end"
	AudioManager._play_transition("door_in")


extends SceneRoomBase

func _on_ready():
	set_scene_data_name()
	._on_ready()

func set_scene_data_name():
	if (GameState.visited_rooms.size() <= 2):
		dialog.scene_name = "room_4_A"
	else:
		dialog.scene_name = "room_4_B"


func play_animation(type_animation):
	if (type_animation == "security"):
		GameState.vigilance = true

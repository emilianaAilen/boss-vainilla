extends SceneRoomBase

onready var remoteControl: TextureButton = $RemoteControl
onready var timer: Timer = $EnableTimer

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
	if type_animation=="end":
		GameState.next_scene = "end"
		AudioManager._play_transition("door_out")
	elif type_animation == "tv_clickeable":
		remoteControl.disabled = false
		dialog.disable_next()

func _on_RemoteControl_pressed():
	dialog.hide()
	remoteControl.disabled = true
	AudioManager.play_back("news_room_SP")
	timer.start()


func _on_EnableTimer_timeout():
	# este metodo solo se ejecutara una vez, pasados 20seg de reproducido el audio room_news
	timer.stop()
	dialog.enable_next()
	dialog._play_phase()
	dialog.show()

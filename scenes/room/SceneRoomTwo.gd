extends SceneRoomBase

onready var remote_control: TextureButton = $RemoteControl
onready var tv_light: Light2D = $Light2D
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
		remote_control.disabled = false
		dialog.disable_next()

func _on_RemoteControl_pressed():
	if !listeded_news: # si no se ha ejecutado/stopeado el timer
		listeded_news = true
		dialog.hide()
		AudioManager.play_back("news_room_SP") # solo se le pedira play una vez
		turn_off_on_tv()
		remote_control.disabled = true
		tv_on = true
		timer.start()
	else:
		turn_off_on_tv()

var tv_on: bool = false 
var listeded_news: bool = false

func turn_off_on_tv():
	if tv_on:
		tv_light.hide()
		AudioManager.mute_back()
	else:
		tv_light.show()
		AudioManager.unmute_back()
	tv_on = !tv_on

func _on_EnableTimer_timeout():
	# este metodo solo se ejecutara una vez, pasados 20seg de reproducido el audio room_news
	remote_control.disabled = false
	timer.stop()
	dialog.enable_next()
	dialog._play_phase()
	dialog.show()

extends BaseScene
class_name SceneRoomBase

onready var light = $Light2D
onready var is_on: bool = true


func _ready():
	GameState.current_scene = self
	AudioManager.play_back("room_foley")

func _run_next_scene():
	if GameState.visited_rooms.size()==4 && (GameState.visited_rooms[-1]=="1" || GameState.visited_rooms[-1]=="3"):
		GameState.next_scene = "end"
		if GameState.vigilance:
			GameState.final_message = "Felicitaciones por un exitoso día de trabajo."
		else:
			GameState.final_message = "Realizaste un buen trabajo. Pero algo se te escapó de las manos..."
	else:
		GameState.next_scene = "scene_2"
	_play_transition()

func _play_transition():
	begin_transition_out()
	AudioManager._play_transition("door_out")
	dialog.hide()

func turn_on():
	light.visible = true

func turn_off():
	light.visible = false


func _on_RemoteControl_pressed():
	if(is_on):
		turn_off()
	else:
		turn_on()
	is_on = !is_on

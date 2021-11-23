extends Node

onready var music: AudioStreamPlayer = $Music
onready var menu_back = $MenuBackground

func _on_Spanish_pressed():
	fade_out(music)
	menu_back.hide()
	get_tree().call_group("Dialog", "on_spanish")


func _on_English_pressed():
	fade_out(music)
	menu_back.hide()
	get_tree().call_group("Dialog", "on_english")

onready var tween_out = $Tween

export var transition_duration = 2.0
export var transition_type = 1 # TRANS_SINE

func fade_out(stream_player):
	# tween music volume down to 0
	tween_out.interpolate_property(stream_player, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
	# when the tween ends, the music will be stopped


func _on_Tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
	object.stop()
	object.volume_db = 0 # reset volume

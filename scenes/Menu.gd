extends Node

onready var music: AudioStreamPlayer = $Music
onready var menu_back = $MenuBackground

func _on_Spanish_pressed():
	menu_back.hide()
	get_tree().call_group("Dialog", "on_spanish")
	music.stop() # que se stopee despacio ?


func _on_English_pressed():
	menu_back.hide()
	get_tree().call_group("Dialog", "on_english")
	music.stop()

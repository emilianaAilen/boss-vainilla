extends Node

onready var music: AudioStreamPlayer = $Music
onready var menu_back = $MenuBackground

func _initialize_with_(language: String):
	menu_back.hide()
	GameState.language = language
	get_parent().run_first_escene()
	music.stop()

func _on_Spanish_pressed():
	_initialize_with_("spanish")

func _on_English_pressed():
	_initialize_with_("english") 

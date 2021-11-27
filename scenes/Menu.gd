extends Node

onready var music: AudioStreamPlayer = $Music
onready var menu_back = $MenuBackground

func _on_Spanish_pressed():
	menu_back.hide()
	GameState.language = "res://data/game_data_spanish.json"
	get_parent().run_first_escene()
	music.stop()


func _on_English_pressed():
	menu_back.hide()
	GameState.language = "res://data/game_data_english.json"
	get_parent().run_first_escene()
	music.stop()

extends Node

onready var music: AudioStreamPlayer = $Music
onready var menu_back = $Logo/MenuBackground


func _initialize_with_(language: String):
	menu_back.hide()
	GameState.language = language
	GameState.gameDataPath =  "res://data/game_data_" + language + ".json"
	music.stop()
	ScenesManager.add_scene("scene_1")
	get_parent().remove_child(self)
	queue_free()

func _on_Spanish_pressed():
	_initialize_with_("spanish")

func _on_English_pressed():
	pass
	#_initialize_with_("english") 

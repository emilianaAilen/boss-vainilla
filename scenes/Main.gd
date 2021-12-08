extends Node

onready var menu = $Menu
export (PackedScene) onready var first_scene:PackedScene
export (PackedScene) onready var end_scene:PackedScene

func run_first_escene():
	ScenesManager.add_scene("scene_1")


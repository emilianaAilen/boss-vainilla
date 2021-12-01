extends Node

export (PackedScene) onready var first_scene:PackedScene
export (PackedScene) onready var end_scene:PackedScene

var scenes

func _ready():
	scenes = {
		"scene_1": first_scene,
		"scene_3": end_scene
	}

func run_first_escene():
	add_scene("scene_1")

func add_scene(id_scene):
	GameState.current_scene_id = id_scene
	var sc = scenes[id_scene]
	add_child(sc.instance())


extends Control


export (PackedScene) onready var first_scene:PackedScene
export (PackedScene) onready var end_scene:PackedScene
export (PackedScene) onready var second_scene:PackedScene


onready var scenes = {
		"scene_1": first_scene,
		"scene_3": end_scene,
		"scene_2": second_scene
	}
	
func add_scene(id_scene):
	GameState.current_scene_id = id_scene
	var sc = scenes[id_scene]
	add_child(sc.instance())
	
func remove_scene(scene):
	remove_child(scene)

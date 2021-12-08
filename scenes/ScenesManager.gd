extends Control


export (PackedScene) onready var first_scene:PackedScene
export (PackedScene) onready var end_scene:PackedScene
export (PackedScene) onready var second_scene:PackedScene
export (PackedScene) onready var room_1:PackedScene
export (PackedScene) onready var room_2:PackedScene


onready var scenes = {
		"scene_1": first_scene,
		"scene_3": end_scene,
		"scene_2": second_scene,
		"scene_room_1": room_1,
		"scene_room_2": room_2
	}
	
func add_scene(id_scene):
	GameState.current_scene_id = id_scene
	var sc = scenes[id_scene]
	add_child(sc.instance())
	
func remove_scene(scene):
	remove_child(scene)

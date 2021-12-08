extends Control


export (PackedScene) onready var first_scene:PackedScene
export (PackedScene) onready var end_scene:PackedScene
export (PackedScene) onready var second_scene:PackedScene
export (PackedScene) onready var room_1:PackedScene
export (PackedScene) onready var room_2:PackedScene
export (PackedScene) onready var room_3:PackedScene
export (PackedScene) onready var room_4:PackedScene
export (PackedScene) onready var end_scene1:PackedScene


onready var scenes = {
		"scene_1": first_scene,
		"scene_3": end_scene,
		"scene_2": second_scene,
		"scene_room_1": room_1,
		"scene_room_2": room_2,
		"scene_room_3": room_3,
		"scene_room_4": room_4,
		"end": end_scene1
	}
	
func add_scene(id_scene):
	GameState.current_scene_id = id_scene
	var sc = scenes[id_scene]
	var inst = sc.instance()
	add_child(inst)
	
func remove_scene(scene):
	remove_child(scene)
	scene.queue_free()

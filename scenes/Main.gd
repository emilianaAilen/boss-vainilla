extends Node

export (PackedScene) var first_scene:PackedScene

		
func run_first_escene():
	add_child(first_scene.instance())


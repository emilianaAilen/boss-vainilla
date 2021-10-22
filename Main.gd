extends Node2D

onready var start_button = $HUD/StartButton
export (PackedScene) var dialog_scene:PackedScene

var dialog_instance

func _on_StartButton_pressed():
	start_button.visible = false
	dialog_instance = dialog_scene.instance()
	add_child(dialog_instance)
	#pass # Replace with function body.

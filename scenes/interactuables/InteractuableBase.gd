extends Control
class_name InteractuableAbstract

signal clicked


func _on_Area_gui_input(event):
	if event is InputEventMouse && event.is_pressed():
		emit_signal("clicked")

extends InteractuableAbstract

onready var is_on: bool = true
onready var light = $Light2D


func _on_Area_gui_input(event):
	if event is InputEventMouse && event.is_pressed():
		if(is_on):
			turn_off()
		else:
			turn_on()
		is_on = !is_on


func turn_on():
	light.visible = true
	AudioManager.unmute_back()

func turn_off():
#	light.energy = 0
	light.visible = false
	AudioManager.mute_back()

extends NinePatchRect

signal clicked(slot)

onready var _Button = $Button

var slot

# Callback Methods

func _on_Button_pressed():
	emit_signal("clicked", slot)
	
# Public Methods

func set_text(new_text : String):
	_Button.text = new_text
<<<<<<< HEAD
=======


>>>>>>> 1bcec11475c638a3401f9335f7604a33d4441392

extends InteractuableAbstract

onready var phone_animation = $Animation
onready var area = $Area

func init_animation():
	area.visible = true
	phone_animation.play("phone")

func stop_animation():
	phone_animation.stop()
	area.visible = false

extends InteractuableAbstract

onready var phone_animation = $Animation

func _ready():
	set_mouse_filter(Control.MOUSE_FILTER_IGNORE)

func init_animation():
	phone_animation.play("phone")

func stop_animation():
	set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	phone_animation.stop()

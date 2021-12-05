extends InteractuableAbstract

onready var phone_animation = $Animation


func init_animation():
	phone_animation.play("phone")


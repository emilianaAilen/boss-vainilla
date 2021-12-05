extends Control
class_name BaseScene

export (float) var animation_duration:float = 2

onready var fade = $Fade
onready var fade_background: ColorRect =  $FadeBackground

func _ready():
	fade.set_base_node_with_modulate(fade_background)

func init_with_animation(duration:float):
	fade.set_fade_duration(duration)
	fade.fade_out()

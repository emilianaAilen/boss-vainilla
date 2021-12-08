extends Control
class_name BaseScene

export (float) var animation_duration:float = 2

onready var fade: Fade_Color = $Fade
onready var fade_background: ColorRect =  $FadeBackground
onready var dialog = $Dialog

func _ready():
	begin_transition_in()
	_on_ready()

func _on_ready():
	dialog._set_idiom_and_init()

func play_animation(type_animation):
	pass
	
func _run_next_scene():
	pass
	
func begin_transition_out():
	fade_background.hide()
	fade.set_base_node_with_modulate(fade_background)
	fade.set_fade_duration(3)
	fade.initiate_fade_in()
	fade_background.show()

func begin_transition_in():
	fade.set_base_node_with_modulate(fade_background)
	fade_background.show()
	fade.set_fade_duration(3)
	fade.initiate_fade_out()

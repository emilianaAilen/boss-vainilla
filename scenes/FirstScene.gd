extends Control

signal phone_rings

onready var dialog = $Dialog
onready var old_phone: Control = $Interact/PhoneInteractuable
onready var timer = $Timer
onready var black = $Background2
onready var transition_sound = $Background2/TransitionSound
onready var principalBackground = $Background

# Called when the node enters the scene tree for the first time.
func _ready():
	dialog._set_idiom_and_init()
	GameState.next_scene = "scene_2"

func _add_phone_interaction():
	# cosas que suceden en la scene cuando suena el telefono
	enable_old_phone_button()
	GameState.space_enable = false
	timer.start()
		
func play_animation(type_animation):
	if (type_animation == "phone"):
		old_phone.init_animation()
		_add_phone_interaction()
	
func enable_old_phone_button():
#	old_phone.set_mouse_filter(Control.MOUSE_FILTER_PASS) # deberia habilitar clickeo, pero nunca se deshabilita
	dialog.hide()

func _on_oldPhone_pressed():
	# when emited signal clicked
	old_phone.stop_animation()
	timer.stop()
	GameState.space_enable = true
	dialog.show()
	dialog._play_phase_if_not_tween()

func _run_next_scene():
	black.visible = true
	GameState.space_enable = false
	AudioManager.stop_back()
	AudioManager._play_transition("car_starting")
	##AudioManager.play_sfx("car_starting")
	##AudioManager.fade_out_sfx(3, 2) ## delay + duration de transicion = total 
	dialog.hide()
	principalBackground.hide()


func _on_timeout():
	print('timeout')
	timer.stop()
	_remove("scene_3")

func _remove(scene):
	ScenesManager.add_scene(scene)
	ScenesManager.remove_child(self)
	AudioManager.stop_all()
	queue_free()

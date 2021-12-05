extends Control

signal phone_rings

onready var background_sound = $BackgroundSound
onready var _dialog_sfx = $DialogSfx
onready var dialog = $Dialog
onready var old_phone = $Interact/PhoneInteractuable
onready var timer = $Timer
onready var black = $Background2
onready var transition_sound = $Background2/TransitionSound
onready var principalBackground = $Background

var sounds

##sounds
export (AudioStream) var phone
export (AudioStream) var pressnext
export (AudioStream) var news


# Called when the node enters the scene tree for the first time.
func _ready():
	sounds = _get_sounds()
	dialog._set_idiom_and_init()

func _get_sounds():
	return {
		"phone": phone,
		"next": pressnext,
		"news": news
	}

func _play_back(sound_name):
	background_sound.stream = sounds[sound_name]
	if !background_sound.playing:
		background_sound.play()
		
func _play_sfx(sound_name):
	if sounds.has(sound_name):
		_add_phone_interaction(sound_name)
		_dialog_sfx.stream = sounds[sound_name]
		_dialog_sfx.play()

func _add_phone_interaction(sound_name):
	if (sound_name == "phone"):
		enable_old_phone_button()
		GameState.space_enable = false
		timer.start()


func _stop_control_animation_sound():
	#stops animation & sounds
	_stop_sound_if_playing()
	_stop_current_animation()

func _stop_sound_if_playing():
	if _dialog_sfx.playing:
		_dialog_sfx.stop()

func _stop_sound_background_if_playing():
	if background_sound.playing:
		background_sound.stop()

func _stop_current_animation():
	pass
#	if animation.is_playing():
#		animation.stop()
		
func play_animation(type):
	old_phone.init_animation()
	
func enable_old_phone_button():
	old_phone.disabled = false
	dialog.hide()

func _on_oldPhone_pressed():
	timer.stop()
	GameState.space_enable = true
	dialog.show()
	dialog._play_phase_if_not_tween()

func _run_next_scene():
	black.visible = true
	GameState.space_enable = false
	_stop_sound_background_if_playing()
	transition_sound.play()
	dialog.hide()
	principalBackground.hide()
	

func _on_timeout():
	timer.stop()
	_remove()

func _remove():
	visible = false
	get_parent().add_scene("scene_3")
	get_parent().remove_child(self)
	queue_free()


func _on_TransitionSound_finished():
	_remove()



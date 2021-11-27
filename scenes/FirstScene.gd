extends Control

onready var background_sound = $BackgroundSound
onready var _dialog_sfx = $DialogSfx
onready var dialog = $Dialog
onready var animation = $Animation
onready var old_phone = $oldPhone

var sounds

##sounds
export (AudioStream) var phone
export (AudioStream) var pressnext
export (AudioStream) var news


# Called when the node enters the scene tree for the first time.
func _ready():
	sounds = _get_sounds()
	dialog._load_Json_and_exec()

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
		
func _stop_sound_if_playing():
	if _dialog_sfx.playing:
		_dialog_sfx.stop()
		
func _stop_current_animation():
	if animation.is_playing():
		animation.stop()
		
func play_animation(type):
	animation.play(type)
	
func enable_old_phone_button():
	old_phone.disabled = false
	dialog.hide()

func _on_oldPhone_pressed():
		dialog._play_next()
		dialog.show()

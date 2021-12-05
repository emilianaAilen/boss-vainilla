extends Control

##sounds
export (AudioStream) var phone
export (AudioStream) var pressnext
export (AudioStream) var news

onready var background = $BackgroundPlayer
onready var sfx = $SfxPlayer

onready var sounds = _get_sounds()

func _get_sounds():
	return {
		"phone": phone,
		"next": pressnext,
		"news": news
	}

func play_back(sound_name: String):
	if sounds.has(sound_name):
		background.stream = sounds[sound_name]
		background.play()

func play_sfx(sound_name: String):
	if sounds.has(sound_name):
		sfx.stream = sounds[sound_name]
		sfx.play()

func mute_back():
	background.set_volume_db(-80)

func unmute_back():
	background.set_volume_db(0)


func stop_all():
	stop_sfx()
	stop_back()

func stop_back():
	background.stop()

func stop_sfx():
	sfx.stop()

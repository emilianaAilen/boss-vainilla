extends Control

##sounds
export (AudioStream) var phone
export (AudioStream) var pressnext
export (AudioStream) var news
export (AudioStream) var car_starting
export (AudioStream) var door_in
export (AudioStream) var room_foley
export (AudioStream) var hallway_foley

onready var background_player = $BackgroundPlayer
onready var sfx_player = $SfxPlayer
onready var tween_fade: Tween = $SoundFadeTween
onready var transition = $Transition

onready var sounds = _get_sounds()

func _get_sounds():
	return {
		"phone": phone,
		"next": pressnext,
		"news": news,
		"car_starting": car_starting,
		"door_in": door_in,
		"room_foley": room_foley,
		"hallway_foley": hallway_foley
	}

## sounds managment
func play_back(sound_name: String):
	if sounds.has(sound_name):
		background_player.stop()
		background_player.stream = sounds[sound_name]
		background_player.play()

func play_sfx(sound_name: String):
	if sounds.has(sound_name):
		sfx_player.stream = sounds[sound_name]
		sfx_player.play()

func mute_back():
	background_player.set_volume_db(-80)

func unmute_back():
	background_player.set_volume_db(0)


func stop_all():
	stop_sfx()
	stop_back()

func stop_back():
	background_player.stop()

func stop_sfx():
	sfx_player.stop()


## sound tween fade out
var transition_duration = 2.0
var transition_type = 1 # TRANS_SINE

func fade_out_background(delay: float, duration: float):
	_fade_out(background_player, duration, delay)

func fade_out_sfx(delay: float, duration: float):
	transition_duration = duration
	_fade_out(sfx_player, duration, delay)

func _fade_out(stream_player, duration, delay):
	# tween music volume down to 0
	tween_fade.interpolate_property(stream_player, "volume_db", 0, -80, duration, transition_type, Tween.EASE_IN, delay)
	tween_fade.start()

func _on_Tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
	object.stop()
	object.volume_db = 0 # reset volume

func _play_transition(stream):
	transition.stream = sounds[stream]
	var stream_transition = transition.stream as AudioStreamOGGVorbis
	stream_transition.set_loop(false)
	transition.play()

func _on_AudioStreamPlayer2D_finished():
	ScenesManager.remove_scene(GameState.current_scene)
	ScenesManager.add_scene(GameState.next_scene)

extends Node
export(float) var textSpeed = 0.05

var gameDataPath:String
var game_data
var sounds
var phaseId = "001"
var finished = false

onready var _Text_Body = $DialogBox/Body/TextContainer/TextLabel
onready var _Dialog_Box = $DialogBox
onready var _Option_List = $DialogBox/Body/OptionList
onready var _Action_Description = $DialogBox/Body/ActionBox/ActionLabel
onready var _Speaker_Text = $DialogBox/Body/Speaker/SpeakerLabel
onready var _dialog_sfx = $DialogSfx
onready var _action_button = $DialogBox/Body/ActionBox


onready var speaker_texture = $DialogBox/Body/SpeakerImage/SpeakerTexture
onready var speaker_container = $DialogBox/Body/SpeakerImage
onready var background = $Background
onready var background_sound = $BackgroundSound
onready var tween = $DialogBox/Body/TextContainer/Tween

onready var _Option_Button_Scene = load("res://scenes/Option.tscn")

##sounds
export (AudioStream) var phone
export (AudioStream) var pressnext
export (AudioStream) var news

func _ready():
	background.hide()
	_Dialog_Box.hide()
	
func initialize():
	game_data = _getDialog()
	assert(game_data, "data not found")
	sounds = _get_sounds()
	_play_phase()

func on_spanish():
	_Dialog_Box.show()
	background.show()
	gameDataPath = "res://data/gameData.json"
	initialize()

func on_english():
	_Dialog_Box.visible = true
#	gameDataPath = "res://data/gameData.json"
#	initialize()


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") && ! (phaseId == ""):
		_play_phase_if_not_tween()

func _play_phase_if_not_tween():
	if !tween.is_active():
		 _play_phase()
		

func _getDialog() -> Array:
	var f = File.new()
	assert(f.file_exists(gameDataPath), "File path does not exist")
	f.open(gameDataPath, File.READ)
	var json = f.get_as_text()
	var output = parse_json(json)
	return output

func _get_sounds():
	return {
		"phone": phone,
		"next": pressnext,
		"news": news
	}
	
func _play_phase():
	_stop_sound_if_playing()	
	if phaseId!= "001":
		_play_sfx("next")
	var currentPhase = game_data[phaseId]
	if currentPhase.has("image") && currentPhase.image != '':
		var img_url = "res://assets/textures/"+currentPhase.image
		loadSpeakerTexture(img_url)
	else:
		 speaker_container.hide()
	if currentPhase.has("sound"):
		_play_sfx(currentPhase.sound)
	if currentPhase.has("type_sound_back"):
		_play_back(currentPhase.type_sound_back)
	if currentPhase.has("choices"):
		_Action_Description.text = "Select choice"
		_show_options(currentPhase.choices)
	_Speaker_Text.text = currentPhase.name
	_Text_Body.text = currentPhase.text
	_action_button.hide()
	tween.interpolate_property(_Text_Body, "percent_visible", 0, 1,  currentPhase.text.length() * 0.03 ,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) 
	tween.start()
	if currentPhase.has("next"):
		phaseId = currentPhase.next

func _stop_sound_if_playing():
	if _dialog_sfx.playing:
		_dialog_sfx.stop()
		
func _show_options(choices):
	if !_options_already_loaded(choices):
		for choice in choices:
			var slot = choice.branch_next
			var new_option_button = _Option_Button_Scene.instance()
			_Option_List.add_child(new_option_button)
			new_option_button.slot = slot
			new_option_button.set_text(choice.text)
			new_option_button.connect("clicked", self, "_on_Option_clicked")
		
func _options_already_loaded(choices):
	var visibleChoices = 0
	var children = _Option_List.get_children()
	for child in children:
		if child.visible:
			visibleChoices = visibleChoices + 1
			
	return visibleChoices == choices.size()

		
func _on_Option_clicked(slot):
	_Action_Description.text = "Press space bar"
	_Option_List.visible = false
	phaseId = slot
	_clear_options()
	_play_phase()
		
func _clear_options():
	var children = _Option_List.get_children()
	for child in children:
		_Option_List.remove_child(child)
		child.queue_free()
		
func _play_sfx(sound_name):
	if sounds.has(sound_name):
		_dialog_sfx.stream = sounds[sound_name]
		_dialog_sfx.play()
		
func _play_back(sound_name):
	background_sound.stream = sounds[sound_name]
	if !background_sound.playing:
		background_sound.play()


func _on_ActionNext_pressed():
	if ( !(phaseId == "") ):
		_play_phase()

func loadSpeakerTexture(texture_url: String):
	speaker_texture.texture = load(texture_url)


func _on_Tween_tween_completed(object, key):
	_action_button.show()

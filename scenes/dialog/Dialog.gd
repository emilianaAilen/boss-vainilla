extends Node
export(float) var textSpeed = 0.05
export(String) var scene_name
export (NodePath) var level_path


var gameDataPath:String = GameState.gameDataPath
var game_data
var phaseId = "001"

onready var _Text_Body = $DialogBox/Body/TextContainer/TextLabel
onready var _Option_List = $DialogBox/Body/OptionList
onready var _Action_Description = $DialogBox/Body/ActionBox/ActionLabel
onready var _Speaker_Text = $DialogBox/Body/Speaker/SpeakerLabel
onready var _Speaker_Image = $DialogBox/Body/SpeakerImage
onready var _Speaker_Image_Face = $DialogBox/Body/SpeakerImage/Sprite
onready var _action_button = $DialogBox/Body/ActionBox
onready var tween = $DialogBox/Body/TextContainer/Tween
onready var level = get_node(level_path)

##constants fields in json
const IMAGE = "image"
const SOUND = "sound"
const NEXT = "next"
const CHOICES = "choices"
const ANIMATION = "type_animation"
const SOUND_BACK = "type_sound_back"
const FINAL_MESSAGE = "final_message"

onready var _Option_Button_Scene = load("res://scenes/dialog/Option.tscn")

#messages for action button
var select_choice: String
var press_button: String

var currentPhase

signal back_sound

func _set_idiom_and_init():
	initialize()
	set_idiom()

func set_idiom():
	var language = GameState.language
	var actions_by_language = GameState.actions_by_language
	select_choice = actions_by_language[language].select
	press_button = actions_by_language[language].press
	_Action_Description.text = actions_by_language[language].press

func initialize():
	game_data = _getDialog()["scene_" + scene_name]
	assert(game_data, "data not found")
	GameState.space_enable = true
	_play_phase()
	
func _input(event):
	if event.is_action_pressed("ui_accept") && GameState.space_enable:
		_play_phase_if_not_tween()

func _play_phase_if_not_tween():
	if _action_button.visible:
		 _play_phase()
	else:
		tween.stop_all()
		_Text_Body.percent_visible = 1
		_action_button.show()
		_show_options_if_it_has()
		
		 
func _getDialog() -> Array:
	var f = File.new()
	assert(f.file_exists(gameDataPath), "File path does not exist")
	f.open(gameDataPath, File.READ)
	var json = f.get_as_text()
	var output = parse_json(json)
	return output
	
func _play_phase():
	if(phaseId != ""):
		currentPhase = game_data[phaseId] 
		_play_next_sound_if_not_first()
		_add_speaker_texture_if_it_exists()
		_play_sfx_if_it_exists()
		_play_back_sound_if_it_exists()
		_set_final_message_if_it_exists()
		_play_animation_if_it_exists()
		_Speaker_Text.text = currentPhase.name
		_Text_Body.text = currentPhase.text
		_action_button.hide()
		tween.interpolate_property(_Text_Body, "percent_visible", 0, 1,  currentPhase.text.length() * 0.03 ,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) 
		tween.start()
		_next_id()
		
	elif (!currentPhase.has(CHOICES)):
		GameState.space_enable = false
		level._run_next_scene()
		
func _next_id():
	if currentPhase.has(NEXT):
		phaseId = currentPhase.next
	else:
		phaseId = ""
		

func _show_options(choices):
	if !_options_already_loaded(choices):
		for choice in choices:
			var slot = choice.branch_next
			var new_option_button = _Option_Button_Scene.instance()
			_Option_List.add_child(new_option_button)
			new_option_button.slot = slot
			new_option_button.set_text(choice.text)
			new_option_button.connect("clicked", self, "_on_Option_clicked")
			new_option_button.set_mouse_filter(Control.MOUSE_FILTER_PASS)
		
func _options_already_loaded(choices):
	var visibleChoices = 0
	var children = _Option_List.get_children()
	for child in children:
		if child.visible:
			visibleChoices = visibleChoices + 1
	return visibleChoices >= choices.size()


func _on_Option_clicked(slot):
	_Action_Description.text = press_button
	phaseId = slot
	_clear_options()
	_play_phase()
	enable_next()

# disable/enable press next action
func disable_next():
	GameState.space_enable = false
	_action_button.disabled = true
func enable_next():
	GameState.space_enable = true
	_action_button.disabled = false


func _clear_options():
	var children = _Option_List.get_children()
	for child in children:
		_Option_List.remove_child(child)
		child.queue_free()


func _add_speaker_texture_if_it_exists():
	if currentPhase.has(IMAGE) && currentPhase.image != '':
		var img_url = "res://assets/textures/characters/"+currentPhase.image+".png"
		loadSpeakerTexture(img_url)
	else:
		_Speaker_Image.texture = null



func _play_sfx_if_it_exists():
	if currentPhase.has(SOUND):
		AudioManager.play_sfx(currentPhase[SOUND])
		
		
func _play_back_sound_if_it_exists():
	if currentPhase.has(SOUND_BACK):
		AudioManager.play_back(currentPhase[SOUND_BACK])

func _play_animation_if_it_exists():
	if currentPhase.has(ANIMATION):
		level.play_animation(currentPhase.type_animation)

func _set_final_message_if_it_exists():
	if currentPhase.has(FINAL_MESSAGE):
		GameState.final_message = currentPhase.final_message
#	else:
#		GameState.final_message = ""

func _show_options_if_it_has():
	if currentPhase.has(CHOICES):
		_Action_Description.text = select_choice
		_show_options(currentPhase.choices)
		disable_next()


func _play_next_sound_if_not_first():
	if phaseId!= "001":
		AudioManager.play_sfx(NEXT)


func _on_ActionNext_pressed():
	 _play_phase()


func loadSpeakerTexture(texture_url: String):
	_Speaker_Image.texture = load(texture_url)


func _on_Tween_tween_completed(object, key):
	_action_button.show()
	_show_options_if_it_has()
	

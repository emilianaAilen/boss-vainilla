extends Node
export(float) var textSpeed = 0.05
export(String) var scene_name 

var gameDataPath:String = GameState.gameDataPath
var game_data
var sounds
var phaseId = "001"
var finished = false

onready var _Text_Body = $DialogBox/Body/TextContainer/TextLabel
onready var _Dialog_Box = $DialogBox
onready var _Option_List = $DialogBox/Body/OptionList
onready var _Action_Description = $DialogBox/Body/ActionBox/ActionLabel
onready var _Speaker_Text = $DialogBox/Body/Speaker/SpeakerLabel
onready var _action_button = $DialogBox/Body/ActionBox


onready var speaker_texture = $DialogBox/Body/SpeakerImage/SpeakerTexture
onready var speaker_container = $DialogBox/Body/SpeakerImage
onready var tween = $DialogBox/Body/TextContainer/Tween

onready var _Option_Button_Scene = load("res://scenes/Option.tscn")

var select_choice: String
var press_button: String

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
	if event.is_action_pressed("ui_accept") && ! (phaseId == "") && GameState.space_enable:
		_play_phase_if_not_tween()

func _play_phase_if_not_tween():
	if !tween.is_active():
		 _play_phase()
	else:
		tween.stop_all()
		_Text_Body.percent_visible = 1
		_action_button.show()
		
		
func _getDialog() -> Array:
	var f = File.new()
	assert(f.file_exists(gameDataPath), "File path does not exist")
	f.open(gameDataPath, File.READ)
	var json = f.get_as_text()
	var output = parse_json(json)
	return output
	
func _play_phase():
	var currentPhase = game_data[phaseId]
	get_parent()._stop_control_animation_sound()
	_play_next_sound_if_not_first()
	_add_speaker_texture_if_it_exists(currentPhase)
	_play_sfx_if_it_exists(currentPhase)
	_play_back_sound_if_it_exists(currentPhase)
	_show_options_if_it_has(currentPhase)
	_play_animation_if_it_exists(currentPhase)
	_Speaker_Text.text = currentPhase.name
	_Text_Body.text = currentPhase.text
	_action_button.hide()
	tween.interpolate_property(_Text_Body, "percent_visible", 0, 1,  currentPhase.text.length() * 0.03 ,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) 
	tween.start()
	if currentPhase.has("next"):
		phaseId = currentPhase.next
	else:
		phaseId = ""
	##elif (!currentPhase.has("choices")):
		##get_parent()._run_next_scene()		
		

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
	print(slot)
	_Action_Description.text = press_button
	_Option_List.visible = false
	phaseId = slot
	_clear_options()
	_play_phase()
		
		
func _clear_options():
	var children = _Option_List.get_children()
	for child in children:
		_Option_List.remove_child(child)
		child.queue_free()
		
		
func _add_speaker_texture_if_it_exists(currentPhase):
	if currentPhase.has("image") && currentPhase.image != '':
		var img_url = "res://assets/textures/"+currentPhase.image
		loadSpeakerTexture(img_url)
	else:
		 speaker_container.hide()
		
		
func _play_sfx_if_it_exists(currentPhase):
	if currentPhase.has("sound"):
		get_parent()._play_sfx(currentPhase.sound)
		
		
func _play_back_sound_if_it_exists(currentPhase):
	if currentPhase.has("type_sound_back"):
		get_parent()._play_back(currentPhase.type_sound_back)

		
func _play_animation_if_it_exists(currentPhase):
	if currentPhase.has("type_animation"):
		get_parent().play_animation(currentPhase.type_animation)
		
		
func _show_options_if_it_has(currentPhase):
	if currentPhase.has("choices"):
		_Action_Description.text = select_choice
		_show_options(currentPhase.choices)


func _play_next_sound_if_not_first():
	if phaseId!= "001":
		get_parent()._play_sfx("next")

func _on_ActionNext_pressed():
	if (phaseId != ""):
		var currentPhase = game_data[phaseId]
		_play_phase()
	else:
		get_parent()._run_next_scene()


func loadSpeakerTexture(texture_url: String):
	speaker_texture.texture = load(texture_url)


func _on_Tween_tween_completed(object, key):
	_action_button.show()
	if (phaseId != ""):
		var currentPhase = game_data[phaseId]
		_show_options_if_it_has(currentPhase)
	

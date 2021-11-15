extends Node
export var gameDataPath = "res://data/gameData.json"
export(float) var textSpeed = 0.05

var game_data
var sounds
var phaseId = "001"
var finished = false

onready var _Text_Body = find_node("TextLabel")
onready var _Dialog_Box = find_node("Dialog_Box")
onready var _Option_List = find_node("OptionList")
onready var _Action_Description = find_node("ActionLabel")
onready var _Speaker_Text = find_node("SpeakerLabel")
onready var _dialog_sfx = $DialogSfx

onready var _Option_Button_Scene = load("res://scenes/Option.tscn")

##sounds
export (AudioStream) var phone
export (AudioStream) var pressnext


func _ready():
	game_data = _getDialog()
	assert(game_data, "data not found")
	sounds = _get_sounds()
	_play_phase()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") && ! (phaseId == ""):
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
		"next": pressnext
	}
	
func _play_phase():
	if phaseId!= "001":
		_stop_sound_if_playing()
		_play_sfx("next")
	var currentPhase = game_data[phaseId]
	if currentPhase.has("sound"):
		_play_sfx(currentPhase.sound)
	if currentPhase.has("choices"):
		_Action_Description.text = "Select choice"
		_show_options(currentPhase.choices)
	_Speaker_Text.text = currentPhase.name
	_Text_Body.text = currentPhase.text
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


func _on_ActionNext_pressed():
	if ( !(phaseId == "") ):
		_play_phase()

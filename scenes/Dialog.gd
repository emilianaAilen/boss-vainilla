extends Node
export var dialogPath = "res://data/gameData.json"
export(float) var textSpeed = 0.05

var game_data

var phaseId = "001"
var finished = false

onready var _Text_Body = find_node("TextLabel")
onready var _Dialog_Box = find_node("Dialog_Box")
onready var _Option_List = find_node("OptionList")
onready var _Action_Description = find_node("SpaceBarLabel")
onready var _Speaker_Text = find_node("SpeakerLabel")

onready var _Option_Button_Scene = load("res://scenes/Option.tscn")

func _ready():
	game_data = getDialog()
	assert(game_data, "Dialog not found")
	_play_phase()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		_play_phase()
		
func getDialog() -> Array:
	var f = File.new()
	assert(f.file_exists(dialogPath), "File path does not exist")
	f.open(dialogPath, File.READ)
	var json = f.get_as_text()
	var output = parse_json(json)
	return output
	
func _play_phase():
	var currentPhase = game_data[phaseId]
	if currentPhase.has("choices"):
		_Action_Description.text = "Select choice"
		_show_options(currentPhase.choices)
	_Speaker_Text.text = currentPhase.name
	_Text_Body.text = currentPhase.text
	if currentPhase.has("next"):
		phaseId = currentPhase.next
		
func _show_options(choices):
	for choice in choices:
		var slot = choice.branch_next
		var new_option_button = _Option_Button_Scene.instance()
		_Option_List.add_child(new_option_button)
		new_option_button.slot = slot
		new_option_button.set_text(choice.text)
		new_option_button.connect("clicked", self, "_on_Option_clicked")
		
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

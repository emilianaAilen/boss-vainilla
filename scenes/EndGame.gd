extends Control

onready var title = $Title
onready var message = $Message
onready var fade: Fade_Color = $Fade
onready var fade_background: ColorRect =  $FadeBackground

var data_scene

func _ready():
	AudioManager.stop_all()
	begin_transition_in()
	initialize_end()
	GameState.current_scene = self
	title.text = data_scene.title
	message.text = GameState.final_message

func initialize_end():
	var data = _get_file()
	data_scene = data["scene_end"]
	assert(data_scene, "data not found")
	
func _get_file() -> Array:
	var f = File.new()
	assert(f.file_exists(GameState.gameDataPath), "File path does not exist")
	f.open(GameState.gameDataPath, File.READ)
	var json = f.get_as_text()
	var output = parse_json(json)
	return output


func _on_ResetButton_pressed():
	ScenesManager.add_scene("menu")
	GameState.reset()

func begin_transition_in():
	fade.set_base_node_with_modulate(fade_background)
	fade_background.show()
	fade.set_fade_duration(5)
	fade.initiate_fade_out()

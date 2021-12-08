extends Control

onready var title = $Title
onready var message = $Message

var data_scene

func _ready():
	initialize_end()
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

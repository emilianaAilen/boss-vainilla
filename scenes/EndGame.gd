extends Control

onready var title = $Title
onready var message = $Message
onready var result = $Result

var data_scene

func _ready():
	var file_data = _get_file()
	data_scene = data_scene.scene_end
	
func _get_file() -> Array:
	var f = File.new()
	assert(f.file_exists(GameState.gameDataPath), "File path does not exist")
	f.open(GameState.gameDataPath, File.READ)
	var json = f.get_as_text()
	var output = parse_json(json)
	return output

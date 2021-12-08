extends Node

var language: String

var current_scene_id: String

var space_enable: bool = false

var actions_by_language = {
	"english": {
		"select": "Select choice",
		"press": "Press spacebar"
	},
	"spanish": {
		"select": "Elegí una opción",
		"press": "Presiona espacio"
	}
}

var next_scene: String

var gameDataPath: String

var result: int = 0

var final_message: String

var current_scene

var available_rooms = ["1","2","3","4"]

var visited_rooms = []

var vigilance = false
var pacient_diappears = false

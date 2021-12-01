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

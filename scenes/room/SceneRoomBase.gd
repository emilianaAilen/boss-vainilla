extends BaseScene
class_name SceneRoomBase

func _ready():
	GameState.current_scene = self

func _run_next_scene():
	GameState.next_scene = "scene_2"
	_play_transition()

func _play_transition():
	begin_transition_out()
	AudioManager._play_transition("car_starting")

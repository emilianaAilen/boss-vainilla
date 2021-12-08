extends BaseScene

onready var message = $Message

func _on_ready():
	AudioManager.stop_back()
	GameState.current_scene = self
	dialog.hide()
	._on_ready()

func _ready():
	message.text = GameState.final_message

func play_animation(type_animation):
	GameState.space_enable = false

func _on_ResetButton_pressed():
	pass # Replace with function body.

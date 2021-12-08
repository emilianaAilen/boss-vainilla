extends BaseScene

onready var room_1 = $ChoiceRoom/room_1
onready var room_2 = $ChoiceRoom/room_2
onready var room_3 = $ChoiceRoom/room_3
onready var room_4 = $ChoiceRoom/room_4

var rooms_obj

func _ready():
	GameState.current_scene = self
	rooms_obj = {
		"1": room_1,
		"2": room_2,
		"3": room_3,
		"4": room_4
	}

func play_animation(type):
	dialog.hide()
	show_available_rooms()
	
func _play_transition():
	begin_transition_in()
	AudioManager._play_transition("car_starting")

func remove_room_from_available(room):
	GameState.available_rooms.erase(room)
	
func add_room_to_visited(room): 
	GameState.visited_rooms.append(room)

func show_available_rooms():
	var rooms = GameState.available_rooms
	for room in rooms:
		rooms_obj[room].show()
		
func manage_room_info(room):
	remove_room_from_available(room)
	add_room_to_visited(room)
	
	
func _on_room_1_pressed():
	manage_room_info("1")
	_play_transition()
	GameState.next_scene = "scene_room_1"


func _on_room_2_pressed():
	manage_room_info("2")
	_play_transition()
	GameState.next_scene = "scene_room_2"
	GameState.scene_name_data = "room_2_A"


func _on_room_4_pressed():
	pass # Replace with function body.


func _on_room_3_pressed():
	pass # Replace with function body.

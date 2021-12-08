extends BaseScene

onready var room_1 = $ChoiceRoom/room_1
onready var room_2 = $ChoiceRoom/room_2
onready var room_3 = $ChoiceRoom/room_3
onready var room_4 = $ChoiceRoom/room_4

var rooms_obj


func _on_ready():
	GameState.current_scene = self
	set_scene_data_name()
	._on_ready()


func set_scene_data_name():
	if(GameState.visited_rooms.size()==4 && GameState.visited_rooms[-1]=="4"):
		dialog.scene_name = "2_D"
	elif(GameState.visited_rooms.size()>2 && GameState.visited_rooms[-1]=="4"):
		dialog.scene_name = "2_B"
	elif GameState.visited_rooms.size()>0:
		dialog.scene_name = "2_C"
	else:
		dialog.scene_name = "2_A"

func play_animation(type):
	if type == "end":
		GameState.space_enable = false
		GameState.next_scene = type
		AudioManager._play_transition("door_in")
	else:
		dialog.hide()
		show_available_rooms()
	
func _play_transition():
	.begin_transition_out()
	AudioManager._play_transition("door_in")

func remove_room_from_available(room):
	GameState.available_rooms.erase(room)
	
func add_room_to_visited(room): 
	if !(GameState.visited_rooms.has(room)):
		GameState.visited_rooms.append(room)

func show_available_rooms():
	rooms_obj = {
		"1": $ChoiceRoom/room_1,
		"2": $ChoiceRoom/room_2,
		"3": $ChoiceRoom/room_3,
		"4": $ChoiceRoom/room_4
	}
	var rooms = GameState.available_rooms
	for room in rooms:
		rooms_obj[room].show()
		


func _on_room_1_pressed():
	_play_room("1")

func _on_room_2_pressed():
	_play_room("2")

func _on_room_4_pressed():
	_play_room("4")

func _on_room_3_pressed():
	_play_room("3")


func _play_room(room):
	rooms_obj[room].disabled = true
	remove_room_from_available(room)
	add_room_to_visited(room)
	_play_transition()
	GameState.next_scene = "scene_room_"+room

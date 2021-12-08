extends Node

signal fade_out_completed

export(float) var fade_duration

var base_modulate
var base_modulate_faded_out
var node_with_modulate

onready var tween_fade_in : Tween = $TweenFadeIn
onready var tween_fade_out : Tween = $TweenFadeOut

func set_base_node_with_modulate(base_node_with_modulate):
	base_modulate = base_node_with_modulate.get_modulate()
	base_modulate_faded_out = base_modulate
	base_modulate_faded_out.a = 0
	node_with_modulate = base_node_with_modulate

func set_fade_duration(new_duration):
	fade_duration = new_duration

func initiate_fade_out():
	fade_out()

func fade_out():
	tween_fade_out.interpolate_property(
		node_with_modulate,
		"modulate",
		node_with_modulate.modulate,
		base_modulate_faded_out,
		fade_duration,
		Tween.TRANS_LINEAR
	)
	tween_fade_out.start()

func initiate_fade_in():
	fade_in()

func fade_in():
	node_with_modulate.modulate.a = 0
	tween_fade_in.interpolate_property(
		node_with_modulate,
		"modulate",
		node_with_modulate.modulate,
		base_modulate,
		fade_duration,
		Tween.TRANS_LINEAR
	)
	tween_fade_in.start()

func reset():
	tween_fade_in.remove_all()
	tween_fade_out.remove_all()
	node_with_modulate.modulate = base_modulate

func _on_TweenFadeOut_tween_all_completed():
	emit_signal("fade_out_completed")

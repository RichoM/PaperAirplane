extends Node

var scenes = []
var next_scene = null

func register_current_scene():
	scenes.append(get_tree().current_scene.filename)
	
func change_scene(path):
	get_tree().change_scene(path)
	
func back():
	var path = scenes.pop_back()
	if path == get_tree().current_scene.filename:
		back()
	elif path != null:
		get_tree().change_scene(path)

func next():
	if next_scene != null:
		change_scene(next_scene)
		next_scene = null

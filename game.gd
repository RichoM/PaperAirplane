extends Spatial

func _on_airplane_game_over():
	yield(get_tree().create_timer(1.0), "timeout")
	$Camera.follow_player = false
	$GUI_layer.queue_free()
	var end_scene = preload("res://end.tscn").instance()
	add_child(end_scene)
	

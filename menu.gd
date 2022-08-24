extends Spatial

func _on_new_game_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_leaderboard_pressed():
	get_tree().change_scene("res://Leaderboard.tscn")

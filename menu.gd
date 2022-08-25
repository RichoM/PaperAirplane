extends Spatial

func _ready():
	SceneManager.register_current_scene()

func _on_new_game_pressed():
	if Globals.user_name == "":
		SceneManager.next_scene = "res://game.tscn"
		SceneManager.change_scene("res://enter_name.tscn")
	else:
		SceneManager.change_scene("res://game.tscn")

func _on_leaderboard_pressed():
	SceneManager.change_scene("res://leaderboard.tscn")

func _on_change_name_pressed():
	SceneManager.next_scene = "res://menu.tscn"
	SceneManager.change_scene("res://enter_name.tscn")

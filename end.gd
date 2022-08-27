extends Control

export var loading_path : NodePath
export var indices_path : NodePath
export var players_path : NodePath
export var scores_path : NodePath
export var message_path : NodePath

func _ready():
	if Globals.score > Globals.max_score:
		Globals.leaderboard = null # Reset leaderboard to force update
		Globals.set_max_score(Globals.score)
		get_node(message_path).text = "NEW HIGHSCORE: " + str(Globals.score)
		$AnimationPlayer.play("highscore")
		$sfx.play()
	else:
		get_node(message_path).text = "GAME OVER: " + str(Globals.score)
	
	Globals.connect("leaderboard_ready", self, "_on_leaderboard_ready")
	Globals.submit_score_to_leaderboard()
	if Globals.leaderboard:
		_on_leaderboard_ready(Globals.leaderboard)

func _on_leaderboard_ready(leaderboard):
	remove_loading_sign()
	var indices_node = get_node(indices_path)
	var players_node = get_node(players_path)
	var scores_node = get_node(scores_path)
	for i in range(min(10, len(leaderboard))):
		var user_name = leaderboard[i]["name"]
		players_node.get_child(i).text = user_name.substr(0, 24)
		scores_node.get_child(i).text = str(leaderboard[i]["score"])
		
		var font_color = Color.white
		if leaderboard[i]["me?"]:
			font_color = Color.red
			
		indices_node.get_child(i).add_color_override("font_color", font_color)
		players_node.get_child(i).add_color_override("font_color", font_color)
		scores_node.get_child(i).add_color_override("font_color", font_color)
			
func remove_loading_sign():
	var loading_sign = get_node(loading_path)
	if loading_sign == null: return
	loading_sign.queue_free()

func _process(delta):
	if Input.is_action_just_released("movement_up"):
		get_tree().reload_current_scene()
		

func _on_back_button_pressed():
	SceneManager.back()
	

extends Control

export var indices_path : NodePath
export var players_path : NodePath
export var scores_path : NodePath
export var message_path : NodePath

func _ready():
	if Globals.score > Globals.max_score:
		Globals.set_max_score(Globals.score)
		get_node(message_path).text = "NEW HIGHSCORE: " + str(Globals.score)
		$AnimationPlayer.play("highscore")
		$sfx.play()
	else:
		get_node(message_path).text = "GAME OVER: " + str(Globals.score)
	
	var http_request = Globals.submit_score_to_leaderboard()
	http_request.connect("request_completed", self, "_on_update_scores_request_completed")


func _process(delta):
	if Input.is_action_just_released("movement_up"):
		get_tree().reload_current_scene()
		

func _on_back_button_pressed():
	SceneManager.back()

func _on_update_scores_request_completed(result, response_code, headers, body):
	$Leaderboard/Loading.queue_free()
	if response_code != 200:
		return
	
	var json = JSON.parse(body.get_string_from_utf8())
	if json.error != OK:
		return
	
	var leaderboard = json.result["dreamlo"]["leaderboard"]
	if leaderboard == null: # The leaderboard is empty
		return
		
	leaderboard = leaderboard["entry"]
	
	# HACK(Richo): It seems if only one score is submitted we don't get an array
	if typeof(leaderboard) != TYPE_ARRAY:
		leaderboard = [leaderboard]
		
	var indices_node = get_node(indices_path)
	var players_node = get_node(players_path)
	var scores_node = get_node(scores_path)
	for i in range(min(10, len(leaderboard))):
		var full_name = leaderboard[i]["name"]
		var name_parts = full_name.split("@", true, 1)
		var pc_id = ""
		var user_name = ""
		if len(name_parts) == 1:
			user_name = name_parts[0]
		else:
			pc_id = name_parts[0]
			user_name = name_parts[1]
			
		players_node.get_child(i).text = user_name.substr(0, 24)
		scores_node.get_child(i).text = str(leaderboard[i]["score"])
		
		if Globals.pc_id == pc_id and Globals.user_name == user_name:
			indices_node.get_child(i).add_color_override("font_color", Color(1,0,0))
			players_node.get_child(i).add_color_override("font_color", Color(1,0,0))
			scores_node.get_child(i).add_color_override("font_color", Color(1,0,0))
			


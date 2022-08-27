extends Spatial

export var indices_path : NodePath
export var players_path : NodePath
export var scores_path : NodePath
export var loading_path : NodePath

func _ready():
	$fetch_scores.request(Globals.LEADERBOARD_URL)

func _on_fetch_scores_request_completed(result, response_code, headers, body):
	get_node(loading_path).queue_free()
	
	if response_code != 200:
		back_to_menu()
		return
	
	var json = JSON.parse(body.get_string_from_utf8())
	if json.error != OK:
		back_to_menu()
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
			

func _process(delta):
	if Input.is_action_just_pressed("movement_up"):
		back_to_menu()

func back_to_menu():
	SceneManager.back()

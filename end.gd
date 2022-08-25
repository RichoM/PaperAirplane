extends Spatial

export var indices_path : NodePath
export var players_path : NodePath
export var scores_path : NodePath
export var message_path : NodePath

func _ready():
	get_node(message_path).text = "GAME OVER: " + str(Globals.score)
	
	var query = JSON.print({"player": Globals.user_name, "score": Globals.score})
	var headers = ["Content-Type: application/json"]
	var url = Globals.LEADERBOARD_URL
	
	# TODO(Richo): Instead of always making a request, change it to only submit a new
	# score if we got a new highscore. Also, make sure to fetch the leaderboard while
	# the user is playing and store it in globals so that we can update the GUI without
	# waiting for the request. 
	$update_scores.request(url, headers, true, HTTPClient.METHOD_POST, query)


func _process(delta):
	if Input.is_action_just_pressed("movement_up"):
		SceneManager.back()

func _on_update_scores_request_completed(result, response_code, headers, body):
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
		players_node.get_child(i).text = leaderboard[i]["name"].substr(0, 24)
		scores_node.get_child(i).text = str(leaderboard[i]["score"])
	
		if Globals.user_name == leaderboard[i]["name"]:
			indices_node.get_child(i).add_color_override("font_color", Color(1,0,0))
			players_node.get_child(i).add_color_override("font_color", Color(1,0,0))
			scores_node.get_child(i).add_color_override("font_color", Color(1,0,0))
			

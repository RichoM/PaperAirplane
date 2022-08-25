extends Spatial

export var players_path : NodePath
export var scores_path : NodePath

func _ready():
	$fetch_scores.request("https://sum-richo.herokuapp.com/leaderboard/63062a5d8f40bba6d06f60be*KQQwDhbyYkW3wOtnkzx_2glfPQcl4Z0kCNAX0oG-kb7g")

func _on_fetch_scores_request_completed(result, response_code, headers, body):
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
		
	var players_node = get_node(players_path)
	var scores_node = get_node(scores_path)
	for i in range(min(10, len(leaderboard))):
		players_node.get_child(i).text = leaderboard[i]["name"].substr(0, 24)
		scores_node.get_child(i).text = str(leaderboard[i]["score"])
	

func _process(delta):
	if Input.is_action_just_pressed("movement_up"):
		back_to_menu()

func back_to_menu():
	get_tree().change_scene("res://Menu.tscn")

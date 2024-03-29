extends Node

const LEADERBOARD_ID = "63062a5d8f40bba6d06f60be*KQQwDhbyYkW3wOtnkzx_2glfPQcl4Z0kCNAX0oG-kb7g"

const PC_ID_FILE_PATH = "user://uuid.paperairplane.bin"
const USER_NAME_FILE_PATH = "user://user_name.paperairplane.bin"
const SCORE_FILE_PATH = "user://max_score.paperairplane.bin"

var pc_id
var user_name = ""
var max_score = 0

var score = 0
var leaderboard = null

var server_url

signal leaderboard_ready(leaderboard)

const uuid = preload("res://uuid.gd")

func _ready():
	read_pc_id()
	if pc_id == null:
		set_pc_id(uuid.v4())
	read_user_name()
	read_max_score()
	fetch_leaderboard()

func read_pc_id():
	var file = File.new()
	var error = file.open(PC_ID_FILE_PATH, File.READ)
	if error == OK:
		pc_id = file.get_as_text()
	file.close()
	
func set_pc_id(id):
	pc_id = id
	var file = File.new()
	file.open(PC_ID_FILE_PATH, File.WRITE)
	file.store_string(pc_id)
	file.close()
	
func read_user_name():
	var file = File.new()
	var error = file.open(USER_NAME_FILE_PATH, File.READ)
	if error == OK:
		user_name = file.get_as_text()
	file.close()
	
func set_user_name(s):
	user_name = s
	var file = File.new()
	file.open(USER_NAME_FILE_PATH, File.WRITE)
	file.store_string(user_name)
	file.close()

func read_max_score():
	var score_file = File.new()
	var error = score_file.open(SCORE_FILE_PATH, File.READ)
	if error == OK:
		max_score = score_file.get_64()
	score_file.close()

func set_max_score(score):
	max_score = score
	var score_file = File.new()
	score_file.open(SCORE_FILE_PATH, File.WRITE)
	score_file.store_64(max_score)
	score_file.close()

func fetch_leaderboard():
	if server_url == null:
		var http_request = HTTPRequest.new()
		add_child(http_request) # Is it necessary?
		http_request.request("https://richom.github.io/sum.txt")
		var result = yield(http_request, "request_completed")
		var response_code = result[1]
		var body = result[3]
		if response_code != 200: return
		var data = body.get_string_from_utf8()
		server_url = data.strip_edges().trim_suffix("/") + "/leaderboard/"
		print(server_url)
		http_request.queue_free()
		fetch_leaderboard() # Now we can actually fetch the leaderboard
	else:
		var http_request = HTTPRequest.new()
		add_child(http_request)
		http_request.connect("request_completed", self, "_on_leaderboard_ready")
		http_request.request(server_url + LEADERBOARD_ID)
		yield(http_request, "request_completed")
		http_request.queue_free()
	
func submit_score_to_leaderboard():
	if server_url == null: return # We better already have the server url!
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var player = pc_id + "@" + user_name.replace("*", "__ASTERISK__")
	var query = JSON.print({"player": player, "score": score})
	var headers = ["Content-Type: application/json"]
	var url = server_url + LEADERBOARD_ID
	
	http_request.connect("request_completed", self, "_on_leaderboard_ready")
	http_request.request(url, headers, true, HTTPClient.METHOD_POST, query)
	yield(http_request, "request_completed")
	http_request.queue_free()


func _on_leaderboard_ready(result, response_code, headers, body):
	if response_code != 200: return
	
	var json = JSON.parse(body.get_string_from_utf8())
	if json.error != OK: return
	
	leaderboard = json.result["dreamlo"]["leaderboard"]
	if leaderboard == null: # The leaderboard is empty
		leaderboard = []
	else:
		leaderboard = leaderboard["entry"]
		
		# HACK(Richo): It seems if only one score is submitted we don't get an array
		if typeof(leaderboard) != TYPE_ARRAY:
			leaderboard = [leaderboard]
			
		for i in range(len(leaderboard)):
			var full_name = leaderboard[i]["name"]
			var name_parts = full_name.split("@", true, 1)
			var id = ""
			var name = ""
			if len(name_parts) == 1:
				name = name_parts[0]
			else:
				id = name_parts[0]
				name = name_parts[1]
			name = name.replace("__ASTERISK__", "*")
				
			var score = leaderboard[i]["score"]
			var is_me = pc_id == id and user_name == name
			leaderboard[i] = {"name": name, "score": score, "me?": is_me}
		
	emit_signal("leaderboard_ready", leaderboard)

extends Node

const SERVER_URL = "https://sum-richo.herokuapp.com/leaderboard/"
const LEADERBOARD_ID = "63062a5d8f40bba6d06f60be*KQQwDhbyYkW3wOtnkzx_2glfPQcl4Z0kCNAX0oG-kb7g"
const LEADERBOARD_URL = SERVER_URL + LEADERBOARD_ID

const USER_NAME_FILE_PATH = "user://user_name.paperairplane.bin"
const SCORE_FILE_PATH = "user://max_score.paperairplane.bin"

var user_name
var max_score

var score = 0

func _ready():
	read_user_name()
	read_max_score()
	
func read_user_name():
	var file = File.new()
	var error = file.open(USER_NAME_FILE_PATH, File.READ)	
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
	max_score = score_file.get_64()
	score_file.close()

func set_max_score(score):
	max_score = score
	var score_file = File.new()
	score_file.open(SCORE_FILE_PATH, File.WRITE)
	score_file.store_64(max_score)
	score_file.close()
	
func submit_score_to_leaderboard():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var query = JSON.print({"player": user_name, "score": score})
	var headers = ["Content-Type: application/json"]
	var url = Globals.LEADERBOARD_URL
	
	http_request.request(url, headers, true, HTTPClient.METHOD_POST, query)
	return http_request


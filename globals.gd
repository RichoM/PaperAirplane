extends Node

const SERVER_URL = "https://sum-richo.herokuapp.com/leaderboard/"
const LEADERBOARD_ID = "63062a5d8f40bba6d06f60be*KQQwDhbyYkW3wOtnkzx_2glfPQcl4Z0kCNAX0oG-kb7g"
const LEADERBOARD_URL = SERVER_URL + LEADERBOARD_ID

const USER_NAME_FILE_PATH = "user://user_name.paperairplane.bin"

var user_name

func _ready():
	read_user_name()
	
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

extends Control

export(Array, String) var exclamation_messages

var msg_counter = 0
var game_over = false

func _ready():
	Globals.score = 0
	Globals.read_max_score()
	$timer.connect("timeout", self, "update")
	$timer.start(0.1)

func update():
	if msg_counter == 0:
		$msg.text = ""
	elif msg_counter > 0:
		msg_counter -= 1
		
	if not game_over:
		update_score(10)

func update_score(s = 100):
	Globals.score += s
	$score_list/score.text = str(Globals.score)
	$score_list/max_score.text = str(Globals.max_score)
	if Globals.score > Globals.max_score:
		$score_list/score.set("custom_colors/font_color", Color.red)
	
func _input(event):
	if Input.is_action_just_released("reset_max_score"):
		Globals.set_max_score(0)

func _on_airplane_game_over():
	game_over = true

func _on_airplane_bullet_time_score(score):
	if game_over: return
	if score < 2000: return
	msg_counter = 10
	var msg := "+" + str(score)
	if score >= 5000:
		var exclamation = exclamation_messages[randi() % exclamation_messages.size()]
		msg = exclamation + "\n" + msg
	$msg.text = msg
	update_score(score)


func _on_back_button_pressed():
	SceneManager.back()

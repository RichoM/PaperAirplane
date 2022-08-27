extends Spatial

export var player_name_path : NodePath
onready var player_name : LineEdit = get_node(player_name_path)

func _ready():
	if Globals.user_name != "":
		player_name.placeholder_text = Globals.user_name
	else:
		player_name.placeholder_text = "Anon" + str(randi() % 9000 + 1000)
	
func _on_accept_button_pressed():
	accept()

func _on_player_name_text_entered(new_text):
	accept()
		
func accept():
	var name = player_name.text.strip_edges()
	if name != "":
		Globals.set_user_name(name)
	else:
		Globals.set_user_name(player_name.placeholder_text)
	
	SceneManager.next()


func _on_back_button_pressed():
	SceneManager.back()


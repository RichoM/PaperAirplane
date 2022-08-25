extends Spatial

export var player_name_path : NodePath
onready var player_name : LineEdit = get_node(player_name_path)

func _ready():
	if Globals.user_name != "":
		player_name.placeholder_text = Globals.user_name

func _on_accept_button_pressed():
	if player_name.text != "":
		Globals.set_user_name(player_name.text)
	else:
		Globals.set_user_name(player_name.placeholder_text)
	
	SceneManager.next()


func _on_back_button_pressed():
	SceneManager.back()

extends Spatial

export var player_name_path : NodePath
onready var player_name : LineEdit = get_node(player_name_path)

func create_fantasy_name():
	var fantasy_names = ["Nebulancer", "Stardancer", "Galactic", "Solarwind", "Starseeker", "Skyglider", "Startrail", "Celestial", "Astrospark", "Nebulaflare", "Solarstorm", "Lunarwave", "Intergalactic", "Spacehawk", "Hypernova", "Starcrafter", "Cosmicpilot", "Celestiadream", "Planetshaper", "Starstream", "Sunspark", "Starfrost", "Moonshifter", "Gravityglider", "Cosmoquest", "Astromancer", "Interstellar", "Solarflare", "Warpwing", "Rocketrunner", "Starlighter", "Starcruiser", "Meteorfall", "Cosmicdust", "Voidvoyager", "Planetary", "Galaxyhawk", "Cosmosail", "Lunarlight", "Astroblade", "Starwatcher", "Nebulight", "Galaxysailor", "Cosmicrider", "Planetscape", "Astrocaster", "Meteorite", "Rocketeer", "Spacewanderer", "Nebulon", "Nebulush", "Astrovoyage", "Astronomer", "Spacestrider", "Astrofrost", "Novastrider", "Starquest", "Starblaze"]
	randomize()
	var random_name = fantasy_names[randi() % fantasy_names.size()]
	var random_number = randi() % 900 + 100
	return random_name + "-" + str(random_number)

func _ready():
	if Globals.user_name != "":
		player_name.placeholder_text = Globals.user_name
	else:
		player_name.placeholder_text = create_fantasy_name()
	
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


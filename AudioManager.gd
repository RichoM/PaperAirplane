extends Spatial

var background_scores = [preload("res://music/Danyah Rays - Can't Stop The Ocean.mp3"), 
						preload("res://music/Danyah Rays - Overt Indecision.mp3"),
						preload("res://music/John Neysmith - The Last Mannerisms.mp3")]
const LAST_BACKGROUND_PATH = "user://last_background_music.bin"

var explosions = [preload("res://sfx/explosion (1).wav"),
				preload("res://sfx/explosion (2).wav"),
				preload("res://sfx/explosion (3).wav"),]
var losers = [preload("res://sfx/loser (1).wav"),
			preload("res://sfx/loser (2).wav"),
			preload("res://sfx/loser (3).wav"),
			preload("res://sfx/loser (4).wav"),]

onready var music_player = $music
onready var sfx_players = [$sfx1, $sfx2]

var game_over = false

func _ready():
	music_player.stream = choose_next_score()
	music_player.pitch_scale = rand_range(0.85, 1.07)
	music_player.play()
	
func choose_next_score():
	var last = get_last_index_played()
	var next = last
	while next == last:
		next = randi() % background_scores.size()
	store_last_index_played(next)
	return background_scores[next]

func get_last_index_played():
	var file = File.new()
	file.open(LAST_BACKGROUND_PATH, File.READ)
	var last = file.get_8()
	file.close()
	return last
	
func store_last_index_played(last):
	var file = File.new()
	file.open(LAST_BACKGROUND_PATH, File.WRITE)
	file.store_8(last)
	file.close()


func _on_airplane_game_over():
	game_over = true
	music_player.stop()
	sfx_players[0].stream = explosions[randi() % explosions.size()]
	sfx_players[1].stream = losers[randi() % losers.size()]
	sfx_players[0].play()
	sfx_players[1].play()
	
func _on_airplane_bullet_time_score(score):
	if game_over: return
	if score > 2000:
		sfx_players[0].stream = preload("res://sfx/sound (1).wav")
		sfx_players[1].stream = preload("res://sfx/sound (2).wav")
		sfx_players[0].play()
		sfx_players[1].play()

extends AudioStreamPlayer

var scores = [preload("res://music/Danyah Rays - Can't Stop The Ocean.mp3"), 
			preload("res://music/Danyah Rays - Overt Indecision.mp3"),
			preload("res://music/John Neysmith - The Last Mannerisms.mp3")]
			
const LAST_FILE_PATH = "user://last_audio_stream.txt"

func _ready():
	var index = choose_next_score()
	print(index)
	var score = scores[index]
	self.stream = score
	self.pitch_scale = rand_range(0.85, 1.07)
	self.play()
	
func choose_next_score():
	var last = get_last_index_played()
	var next = last
	while next == last:
		next = randi() % scores.size()
	store_last_index_played(next)
	return next

func get_last_index_played():
	var file = File.new()
	file.open(LAST_FILE_PATH, File.READ)
	var last = file.get_8()
	file.close()
	return last
	
func store_last_index_played(last):
	var file = File.new()
	file.open(LAST_FILE_PATH, File.WRITE)
	file.store_8(last)
	file.close()

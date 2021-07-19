extends Spatial

export var root : NodePath
export var camera : NodePath
export var max_asteroids = 5

var asteroids = [preload("res://asteroid_0.tscn"), preload("res://asteroid_1.tscn")]
var spawned = []

func _ready():
	var timer = $timer
	timer.connect("timeout", self, "spawn_new_asteroid")
	timer.start()
	call_deferred("spawn_new_asteroid")

func spawn_new_asteroid():
	var counter = spawned.size()
	if counter >= max_asteroids:
		for asteroid in spawned:
			(asteroid as Asteroid).remove_flag = true
		spawned.clear()
		
	print(OS.get_time())
	var index = posmod(counter, asteroids.size())
	var asteroid = asteroids[index].instance() as Asteroid
	spawned.push_back(asteroid)
	asteroid.camera = get_node(camera).get_path()
	get_node(root).add_child(asteroid)
	asteroid.global_transform.origin = global_transform.origin

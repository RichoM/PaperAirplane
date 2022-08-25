extends Camera

export var player_path : NodePath
onready var player = get_node(player_path)

export var light_path : NodePath
onready var light : DirectionalLight = get_node(light_path)

var offset := Vector2()
var bullet_time := false
var bullet_time_begin := 0

func _ready():
	offset.x = player.global_transform.origin.x - global_transform.origin.x
	offset.y = player.global_transform.origin.y - global_transform.origin.y

func _process(delta):
	global_transform.origin.x = player.global_transform.origin.x - offset.x
	global_transform.origin.y = player.global_transform.origin.y - offset.y
	var light_energy = light.light_energy
	if bullet_time and OS.get_ticks_msec() - bullet_time_begin > 250:
		size -= delta * 0.25
		light_energy += delta * 5
	else:
		size += delta * 0.25
		light_energy -= delta * 3
	size = clamp(size, 0.9, 1)
	light.light_energy = clamp(light_energy, 1, 5)

func _on_airplane_bullet_time_begin():
	bullet_time_begin = OS.get_ticks_msec()
	bullet_time = true
	#$Animation.play("zoom", -1, 1)

func _on_airplane_bullet_time_end():
	bullet_time = false
	#$Animation.play("zoom", -1, -1)

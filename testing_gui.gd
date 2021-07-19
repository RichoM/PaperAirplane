extends Control

var bullet_time_ms = 0

var bullet_time : Label
var time_scale : Label

func _ready():
	bullet_time = find_node("BulletTime") as Label
	time_scale = find_node("TimeScale") as Label
	
func _process(delta):
	bullet_time_ms += delta*1000
	bullet_time.text = str(bullet_time_ms)
	
	time_scale.text = str(lerp(1.0, 0.5, clamp(bullet_time_ms/1000, 0, 1)))

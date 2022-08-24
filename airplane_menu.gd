extends MeshInstance

var t = 0
onready var y = translation.y

func _process(delta):
	t += delta
	rotation.x = cos(t) / 5
	translation.y = y + sin(t * 3) / 200

extends KinematicBody

export var camera : NodePath
export var speed = 1.0

func _process(delta):
	teleport()
	$mesh.rotate_z(delta)
	
func _physics_process(delta):
	move_and_slide(Vector3.LEFT * delta  * speed)

func teleport():
	var cam : Camera = get_node(camera)
	var z_depth = cam.global_transform.origin.z
	var cam_size = cam.get_viewport().size
	var cam_tl = cam.project_position(cam_size * -0.1, z_depth)
	var cam_br = cam.project_position(cam_size * 1.1, z_depth)
	var cam_top = cam_tl.y
	var cam_left = cam_tl.x
	var cam_bottom = cam_br.y
	var cam_right = cam_br.x
	
	var aabb = $mesh.get_transformed_aabb()
	var self_top = aabb.end.y
	var self_bottom = aabb.position.y
	var self_left = aabb.position.x
	var self_right = aabb.end.x
	
	if self_right < cam_left:
		global_transform.origin.x = cam_right + aabb.size.x/2
		global_transform.origin.y = rand_range(cam_bottom, cam_top)
	elif self_top < cam_bottom:
		global_transform.origin.x = rand_range(cam_left, cam_right)
		global_transform.origin.y = cam_top + aabb.size.y/2
	elif self_bottom > cam_top:
		global_transform.origin.x = rand_range(cam_left, cam_right)
		global_transform.origin.y = cam_bottom - aabb.size.y/2

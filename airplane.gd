extends Spatial

const GRAVITY = -1
const MIN_SPEED = deg2rad(-75)
const MAX_SPEED = deg2rad(75)

var time = 0
var vel = Vector2(0.25, 0.5)

var colliding = false
var proximity_counter = 0
var max_proximity_counter = 0
var bullet_time_ms = 0

signal game_over
signal bullet_time_begin
signal bullet_time_end
signal bullet_time_score

func _ready():
	randomize()

func _process(delta):
	if colliding:
		gameover(delta)
	else:
		control(delta)
		
func gameover(delta):
	vel.y += GRAVITY * delta
	$rotation.rotation.z -= delta * 2
	$rotation/mesh.rotation.x += delta * 3
	translate_object_local(Vector3.RIGHT * vel.x * delta + Vector3.UP * vel.y * delta)
		
func control(delta):
	if Input.is_action_pressed("movement_up"):
		vel.y -= GRAVITY * 2.5 * delta
	else:
		vel.y += GRAVITY * delta
		
	vel.y = clamp(vel.y, MIN_SPEED, MAX_SPEED)
	vel.x += 0.0025 * delta
	vel.x = clamp(vel.x, 0, 0.85)
	
	var rot_z = (vel.y / (MAX_SPEED - MIN_SPEED) * 2)
	$rotation.rotation.z = rot_z * 1.25
	
	time += delta
	$rotation/mesh.rotation.x = sin(time * 5) * abs(vel.y) * 0.4
	
	translate_object_local(Vector3.RIGHT * vel.x * delta + Vector3.UP * vel.y * delta)
	
	if proximity_counter > 0:
		bullet_time_ms += round(delta*1000)
		Engine.time_scale = lerp(1.0, 0.35, clamp(bullet_time_ms/300, 0, 1))

func _physics_process(delta):
	if colliding: return
	var bodies = $rotation/area.get_overlapping_bodies()
	if bodies.size() > 0:
		colliding = true
		var signs = (global_transform.origin - bodies[0].global_transform.origin).sign()
		vel = Vector2(0.5 * signs.x, 0.5 * signs.y)
		translate_object_local(Vector3.FORWARD * -0.25)
		emit_signal("game_over")


func _on_proximity_sensor_body_entered(body):
	proximity_counter += 1
	if proximity_counter > max_proximity_counter:
		max_proximity_counter = proximity_counter
	if proximity_counter == 1:
		bullet_time_ms = 0
		emit_signal("bullet_time_begin")


func _on_proximity_sensor_body_exited(body):
	proximity_counter -= 1
	if proximity_counter == 0:
		Engine.time_scale = 1
		emit_signal("bullet_time_end")
		emit_signal("bullet_time_score", round(bullet_time_ms * 10 / 1000) * 1000)
		max_proximity_counter = 0

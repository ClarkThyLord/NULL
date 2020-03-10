extends KinematicBody

var velocity = Vector3()
var camera
var gravity = -9.8 * 3
export (float) var SPEED
export (float) var RUN_SPEED
export (float) var DE_ACCELERATION
export (float) var ACCELERATION
export (float) var jump_height


# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_viewport().get_camera().get_global_transform()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	walk(delta)
	if(Input.is_action_pressed("attack")):
		get_node("Hit").get_node("Hitbox").disabled = false
	else:
		get_node("Hit").get_node("Hitbox").disabled = true


		
func walk(delta):
	var dir = Vector3()
	
	if(Input.is_action_pressed("move_fw")):
		dir.z -= 1
	if(Input.is_action_pressed("move_bw")):
		dir.z += 1
	if(Input.is_action_pressed("move_lf")):
		dir.x -= 1
	if(Input.is_action_pressed("move_rg")):
		dir.x += 1
	dir = dir.normalized()
	
	velocity.y += gravity * delta
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	var speed = SPEED
	if(Input.is_action_pressed("action_shift")):
		speed = RUN_SPEED
	var target = dir * speed
	
	var accel = DE_ACCELERATION
	if(dir.dot(temp_velocity)>0):
		accel = ACCELERATION
	temp_velocity = temp_velocity.linear_interpolate(target, DE_ACCELERATION * delta)
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	velocity = move_and_slide(velocity, Vector3(0,1,0))

	if abs(velocity.x) >= 1 or abs(velocity.z) >= 1:
		var rot = get_rotation()
		rot.y = atan2(-temp_velocity.x,-temp_velocity.z)
		set_rotation(rot)
	
	if is_on_floor() and Input.is_action_pressed("action_space"):
		velocity.y = jump_height

func _on_Hit_body_entered(body):
	print("hit")

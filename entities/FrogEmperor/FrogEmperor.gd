extends KinematicBody
class_name FrogEmperor



# Declarations
var velocity = Vector3()
var camera
var gravity = -9.8 * 3
export (float) var SPEED
export (float) var RUN_SPEED
export (float) var DE_ACCELERATION
export (float) var ACCELERATION
export (float) var jump_height



# Core
func _ready():
	add_to_group("players", true)
	#Get the scene's camera
	camera = get_viewport().get_camera().get_global_transform()


func attack():
	#Enable collision box when input attack is done and disable it when not
	if(Input.is_action_pressed("attack")):
		get_node("Hit").get_node("Hitbox").disabled = false
	else:
		get_node("Hit").get_node("Hitbox").disabled = true

func movement(delta):
	#Declare the vector that will tell the direction the player wants to move
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
	
	#Make gravity change y position of player
	velocity.y += gravity * delta
	
	#Declare a temporal variable for velocity so that the y vector doesnt get change
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	#See if player wants the character to run and with that get the new position of the object
	var speed = SPEED
	if(Input.is_action_pressed("action_shift")):
		speed = RUN_SPEED
	var target = dir * speed
	
	#deaccelerate when player is changing direction or stopping
	var accel = DE_ACCELERATION
	if(dir.dot(temp_velocity)>0):
		accel = ACCELERATION
	
	#Call the linear_interpolate to make move_and_slide movement with the acceleration given 
	temp_velocity = temp_velocity.linear_interpolate(target, accel * delta)
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	velocity = move_and_slide(velocity, Vector3(0,1,0))

	#Rotate the player towards where its moving, "if" dectects if player is moving
	if abs(velocity.x) >= 1 or abs(velocity.z) >= 1:
		var rot = get_rotation()
		rot.y = atan2(-temp_velocity.x,-temp_velocity.z)
		set_rotation(rot)
	
	#Jumping when player its on floor and inpus space is done
	if is_on_floor() and Input.is_action_pressed("action_space"):
		velocity.y = jump_height


func _process(delta):
	#Call all the action the player can do
	movement(delta)
	attack()


#Attack hit
func _on_Hit_body_entered(body):
	print("hit")

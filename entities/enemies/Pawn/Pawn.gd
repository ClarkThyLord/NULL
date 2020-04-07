extends Enemy
class_name Pawn
export (int) var speed
export (int) var hitRate

var hitFrames = 0
# Core
func _ready():
	add_to_group("pawns", true)

func set_health(health : int) -> void:
	get_node("Viewport").get_node("Health").value = health
	.set_health(health)

func _process(delta):
	hitFrames = (hitFrames + 1) % hitRate
	if hitFrames == 0:
		attack()
	else:
		get_node("HitArea").get_node("HitBox").disabled = true
	
	var global_direction = Vector3(0,0,1)
	var local_direction = global_direction.rotated(Vector3(0,1,0), rotation.y)
	var velocity = - local_direction * speed
	move_and_slide(velocity)
	print(Health)
	

func attack():
	get_node("HitArea").get_node("HitBox").disabled = false
	
func _on_HitArea_body_entered(body):
	if body is Entity:
		body.hurt({
			"damage": 10
		})

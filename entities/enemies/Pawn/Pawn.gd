extends "res://entities/enemies/Enemy.gd"
class_name Pawn



# Refrences
onready var HealthBar := get_node("HealthBar")



# Declarations
func set_health(health : int) -> void:
	.set_health(health)
	HealthBar.progress = Health

export (int) var speed

var hitFrames = 0
export (int) var hitRate



# Core
func _ready():
	add_to_group("pawns", true)


func attack():
	get_node("HitArea").get_node("HitBox").disabled = false


func _process(delta):
	hitFrames = (hitFrames + 1) % hitRate
	if hitFrames == 0: attack()
	else: get_node("HitArea").get_node("HitBox").disabled = true
	
	var global_direction = Vector3(0,0,1)
	var local_direction = global_direction.rotated(Vector3(0,1,0), rotation.y)
	var velocity = - local_direction * speed
	move_and_slide(velocity)


func _on_HitArea_body_entered(body):
	if body.is_in_group('entities'):
		body.hurt({
			"damage": 10
		})

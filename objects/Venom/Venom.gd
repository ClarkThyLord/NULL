extends Area

# Refrences
onready var HitArea := get_node("HitArea")

export (float) var Speed := .7
export(int, 0, 100) var MinDamage := 30
export(int, 0, 100) var MaxDamage := 50

var myViper : KinematicBody
var canShoot = false
var velocityY = Vector3()

func _physics_process(delta):
	if canShoot:
		translation.y += velocityY 
		translation += Vector3.FORWARD.rotated(Vector3.UP, rotation.y) * Speed
		for body in get_overlapping_bodies():
			if !body.is_in_group("enemies"):
				for body in get_node("explotion").get_overlapping_bodies():
					if body.is_in_group("players"):
						myViper.hit(body, MinDamage + randi() % MaxDamage)
				canShoot = false
				visible = false
				translation = myViper.translation
				translation.y = 7
		
		print(canShoot)


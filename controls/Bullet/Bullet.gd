extends Area

# Refrences
onready var HitArea := get_node("HitArea")

export (float) var Speed := 2
export(int, 0, 100) var MinDamage := 10
export(int, 0, 100) var MaxDamage := 20

var myArcher : KinematicBody
var canShoot = false

func _ready():
	pass

func _physics_process(delta):
	if canShoot:
		translation += Vector3.FORWARD.rotated(Vector3.UP, rotation.y) * Speed
		for body in get_overlapping_bodies():
			if body.is_in_group("players"):
				myArcher.hit(body, MinDamage + randi() % MaxDamage)
				canShoot = false
				visible = false


extends KinematicBody

onready var colision := get_node("AreaColision")

func _ready():
	pass 

func _process(delta):
	move_and_slide(Vector3.DOWN * 8, Vector3.UP)
	for body in colision.get_overlapping_bodies():
			if body.is_in_group("players"):
				dropFunc(body)

func dropFunc(body):
	queue_free()

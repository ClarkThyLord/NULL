extends Enemy
class_name Pawn



# Core
func _ready():
	add_to_group("pawns", true)


func _on_HitArea_body_entered(body):
	if body is Entity:
		body.hurt({
			"damage": 10
		})

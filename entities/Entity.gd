extends KinematicBody



# Declarations
export(int, 0, 100, 1) var Health := 100 setget set_health
func set_health(health : int) -> void:
	Health = clamp(health, 0, 100)
	if Health <= 0: die()



# Core
func _ready():
	add_to_group("entities", true)


# Hit Schema -> {
#	'damage' : float
# }
func hurt(hit : Dictionary) -> void:
	set_health(Health - hit["damage"])

func die() -> void:
	queue_free()

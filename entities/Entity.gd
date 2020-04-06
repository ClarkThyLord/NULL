extends KinematicBody
class_name Entity



# Declarations
export(int, 0, 100, 1) var Health := 100 setget set_health
func set_health(health : int) -> void:
	Health = health
	if Health <= 0: die()

export(int, 0, 100, 1) var Stamina := 100 setget set_stamina
func set_stamina(stamina : int) -> void:
	Stamina = clamp(stamina, 0, 100)



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

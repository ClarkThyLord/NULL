extends KinematicBody



# Declarations
export(int, 0, 100, 1) var Health := 100 setget set_health
func set_health(health : int) -> void:
	Health = clamp(health, 0, 100)
	if Health <= 0: die()



# Core
func _ready():
	add_to_group("entities", true)



func hit(target : KinematicBody, damage : int) -> void:	
	target.hurt({
		"damage": damage,
		"direction": (target.translation - translation).normalized()
	})

# Hit Schema -> {
#	"damage" : float,
#	"direction": Vector3
# }
func hurt(hit : Dictionary) -> void:
	set_health(Health - hit["damage"])

func die() -> void:
	queue_free()

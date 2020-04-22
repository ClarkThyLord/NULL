extends KinematicBody



# Declarations
signal died

export(float, 0.0, 100.0, 1) var Health := 100.0 setget set_health
func set_health(health : float) -> void:
	Health = clamp(health, 0, 100)
	if Health <= 0: die()


export(int, 0, 100, 1) var Gravity := 10
export(int, 0, 1000000000) var Knockback := 250
export(int, 0.0, 1.0, 0.01) var KnockbackAmplifier := 0.0



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
	if Knockback > 0:
		move_and_slide(hit["direction"] * Knockback * clamp(hit["damage"] / 100.0 + KnockbackAmplifier, 0, 1))
	set_health(Health - hit["damage"])

func die() -> void:
	emit_signal("died")
	queue_free()


func _process(delta):
	if translation.y <= -10: die()

func _physics_process(delta):
	move_and_slide(Vector3.DOWN * Gravity, Vector3.UP)


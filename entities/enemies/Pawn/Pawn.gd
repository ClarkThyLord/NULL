extends "res://entities/enemies/Enemy.gd"



# Refrences
onready var HealthBar := get_node("HealthBar")

onready var HitArea := get_node("HitArea")



# Declarations
func set_health(health : int) -> void:
	.set_health(health)
	HealthBar.Progress = Health

export(int, 0, 100) var Speed := 10

var hit_frames = 0
export(int, 1, 1000) var HitRate := 100

export(int, 0, 100) var MinDamage := 0
export(int, 0, 100) var MaxDamage := 10



# Core
func _ready():
	add_to_group("pawns", true)


func attack():
	for body in HitArea.get_overlapping_bodies():
		if body.is_in_group("entities"):
			hit(body, MinDamage + randi() % MaxDamage)


func _process(delta):
	hit_frames = (hit_frames + 1) % HitRate
	if hit_frames == 0: attack()
	
	move_and_slide(Vector3.FORWARD.rotated(Vector3.UP, rotation.y) * Speed)

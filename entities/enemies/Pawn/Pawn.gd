extends "res://entities/enemies/Enemy.gd"


# Refrences
onready var animation := get_node("AnimationPlayer")
onready var HitArea := get_node("HitArea")



# Declarations
export(int, 0, 100) var Speed := 10

var hit_frames = 0
export(int, 1, 1000) var HitRate := 100

export(int, 0, 100) var MinDamage := 0
export(int, 0, 100) var MaxDamage := 10



# Core
func _ready():
	add_to_group("pawns", true)


func attack():
	animation.play("attack")
	for body in HitArea.get_overlapping_bodies():
		if body.is_in_group("players"):
			hit(body, MinDamage + randi() % MaxDamage)


func _physics_process(delta):
	hit_frames = (hit_frames + 1) % HitRate
	if hit_frames == 0 and not animation.current_animation == "attack":
		attack()
	
	move_and_slide(Vector3.FORWARD.rotated(Vector3.UP, rotation.y) * Speed)
	if animation.current_animation == "idle": animation.play("moving")
	._physics_process(delta)

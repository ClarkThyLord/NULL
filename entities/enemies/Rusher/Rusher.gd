extends "res://entities/enemies/Enemy.gd"

# Refrences
onready var HitArea := get_node("HitArea")
onready var animation := get_node("AnimationPlayer")

# Declarations
export(int, 0, 100) var Speed := 10

var hit_frames = 0
export(int, 1, 1000) var HitRate := 100
var attack_frames = 0
export(int, 1, 1000) var AttackReach := 25

export(int, 0, 100) var MinDamage := 30
export(int, 0, 100) var MaxDamage := 40

var attack = false

# Core
func _ready():
	pass
	
func _physics_process(delta):
	hit_frames = hit_frames + 1
	if !attack:
		if hit_frames > HitRate:
			animation.play("moving")
			if translation.distance_to(Target.translation) > 25:
				move_and_slide(Vector3.FORWARD.rotated(Vector3.UP, rotation.y) * Speed)
			else:
				attack = true
				look_at_player = false
		else:
			animation.play("idle")
	else:
		animation.play("attack")
		move_and_slide(Vector3.FORWARD.rotated(Vector3.UP, rotation.y) * 70)
		for body in HitArea.get_overlapping_bodies():
			if body.is_in_group("players"):
				hit(body, MinDamage + randi() % MaxDamage)
				attack = false
				look_at_player = true
				hit_frames = 0
				attack_frames = 0
		attack_frames += 1
		if attack_frames >= AttackReach:
			attack = false
			look_at_player = true
			hit_frames = 0
			attack_frames = 0
	._physics_process(delta)

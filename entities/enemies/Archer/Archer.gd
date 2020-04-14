extends "res://entities/enemies/Enemy.gd"


# Declarations
export(int, 0, 100) var Speed := 10

var hit_frames = 0
export(int, 1, 1000) var HitRate := 100

export(int, 0, 100) var MinDamage := 0
export(int, 0, 100) var MaxDamage := 10


var bullet = preload("res://controls/Bullet/Bullet.tscn").instance()
# Core
func _ready():
	Pointage = 10
	add_to_group("archers", true)
	get_node("/root").get_child(0).call_deferred("add_child", bullet)
	bullet.visible = false
	bullet.myArcher = self

func attack():
	bullet.translation = translation
	bullet.rotation = rotation
	bullet.visible = true
	bullet.canShoot = true

func _physics_process(delta):
	hit_frames = (hit_frames + 1) % HitRate
	if hit_frames == 0: attack()
	if translation.distance_to(Target.translation) > 25:
		move_and_slide(Vector3.FORWARD.rotated(Vector3.UP, rotation.y) * Speed)
	._physics_process(delta)

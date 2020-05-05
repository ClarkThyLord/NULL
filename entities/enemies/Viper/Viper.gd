extends "res://entities/enemies/Enemy.gd"

var hit_frames = 0
export(int, 1, 1000) var HitRate := 200

export(int, 0, 100) var MinDamage := 0
export(int, 0, 100) var MaxDamage := 10


var venom = preload("res://objects/Venom/Venom.tscn").instance()
# Core
func _ready():
	Pointage = 10
	add_to_group("vipers", true)
	get_node("/root").get_child(0).call_deferred("add_child", venom)
	venom.visible = false
	venom.myViper = self

func attack():
	venom.translation = translation
	venom.translation.y = 5
	venom.rotation = rotation
	venom.visible = true
	venom.canShoot = true
	venom.velocityY = - 5 / (translation.distance_to(Target.translation) / venom.Speed)
	
	
func _physics_process(delta):
	hit_frames = (hit_frames + 1) % HitRate
	if hit_frames == 0: 
		attack()
	._physics_process(delta)

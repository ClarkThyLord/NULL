extends "res://entities/Entity.gd"


#References
onready var HealthBar := get_node("HealthBar")

# Declarations
export(int, -1000000000, 1000000000) var Pointage := 0
var look_at_player = true

var Target : Spatial
export(NodePath) var TargetPath : NodePath setget set_target_path
func set_target_path(targetpath : NodePath) -> void:
	if not targetpath.is_empty() and get_node(targetpath) is Spatial:
		TargetPath = targetpath
		if not Engine.editor_hint: Target = get_node(targetpath)

func set_health(health : float) -> void:
	.set_health(health)
	HealthBar.Progress = Health

# Core
func _ready():
	add_to_group("enemies", true)
	
	set_target_path(TargetPath)
	if Target == null: Target = seek()


func seek() -> Spatial:
	var target : Spatial = null
	for player in get_tree().get_nodes_in_group("players"):
		if target == null or translation.distance_to(player.translation) < translation.distance_to(target.translation):
			target = player
	return target

func die() -> void:
	get_node("/root/Server").CurrentPoints += Pointage
#	var drop = preload("res://controls/Drop/Drop.tscn").instance()
#	get_parent().add_child(drop)
#	drop.translation = translation
	.die()


func _process(delta):
	if is_instance_valid(Target) and look_at_player:
		look_at(Target.translation, Vector3(0,1,0))
		rotation.z = 0
		rotation.x = 0
	._process(delta)

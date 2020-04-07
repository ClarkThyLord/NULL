extends "res://entities/Entity.gd"



# Declarations
var Target : Spatial
export(NodePath) var TargetPath : NodePath setget set_target
func set_target(targetpath : NodePath) -> void:
	if get_node(targetpath) is Spatial:
		TargetPath = targetpath
		if not Engine.editor_hint: Target = get_node(targetpath)



# Core
func _ready():
	add_to_group("enemies", true)
	
	if Target == null: Target = seek()


func seek() -> Spatial:
	var target : Spatial = null
	for player in get_tree().get_nodes_in_group("players"):
		if target == null or translation.distance_to(player.translation) < translation.distance_to(target.translation):
			target = target
	return target


func _process(delta):
	if is_instance_valid(Target):
		look_at(Target.get_transform().origin, Vector3(0,1,0))
		rotation.z = 0
		rotation.x = 0

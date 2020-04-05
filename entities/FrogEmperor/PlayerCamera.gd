#This code will make the camera to not rotate with the player
extends Camera

onready var player = get_parent()
var offset : Vector3

func _init():
	#Not follow any of the parent node movement including rotation
	set_as_toplevel(true)

func _ready():
	offset = get_global_transform().origin

func _physics_process(delta):
	#Follow the movement of parent node (player)
	var target = player.get_global_transform().origin
	var base = get_global_transform().basis
	set_global_transform(Transform(base, target + offset))

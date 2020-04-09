tool
extends Spatial



# Refrences
onready var Floor := get_node("Floor")



# Declarations
signal cleared

export(Vector2) var Size := Vector2(16, 16) setget set_size
func set_size(size : Vector2, autogenerate := true) -> void:
	Size = Vector2(
		clamp(size.x, 16, 100),
		clamp(size.y, 16, 100)
	)
	if Floor: Floor.scale = Vector3(Size.x, 1, Size.y)



# Core
func _ready():
	set_size(Size)
	add_to_group("Map.Level")


func start() -> void:
	pass


var time = 0
func _process(delta):
	time += delta
	if time > 3:
		 emit_signal("cleared")

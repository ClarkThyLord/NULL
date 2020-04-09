tool
extends Spatial



# Refrences
onready var Floor := get_node("Floor")



# Declarations
signal cleared

enum States { IDLE, STARTING, PROGRESSING, CLEARED }
export(States) var State := States.IDLE setget set_state
func set_state(state : int) -> void:
	State = state
	update()


export(Vector2) var Size := Vector2(16, 16) setget set_size
func set_size(size : Vector2, autogenerate := true) -> void:
	Size = Vector2(
		clamp(size.x, 16, 100),
		clamp(size.y, 16, 100)
	)
	if Floor: Floor.scale = Vector3(Size.x, 1, Size.y)


export(Color) var IdleColor := Color("ff00ff") setget set_IdleColor
func set_IdleColor(color : Color) -> void:
	IdleColor = color
	update()

export(Color) var StartingColor := Color("ffff00") setget set_StartingColor
func set_StartingColor(color : Color) -> void:
	StartingColor = color
	update()

export(Color) var ProgressingColor := Color.red setget ProgressingColor
func ProgressingColor(color : Color) -> void:
	ProgressingColor = color
	update()

export(Color) var ClearedColor := Color("2dff0f") setget set_ClearedColor
func set_ClearedColor(color : Color) -> void:
	ClearedColor = color
	update()

export(bool) var DitheringColor := true

export(int, 0, 255) var DitheringAmount := 30



# Core
func _ready():
	update()
	set_size(Size)
	add_to_group("Map.Level")
	var material := SpatialMaterial.new()
	material.vertex_color_use_as_albedo = true
	material.albedo_color = IdleColor
	material.albedo_texture = preload("res://assets/maps/floor.jpg")
	material.emission_enabled = true
	material.emission = IdleColor
	material.emission_operator = SpatialMaterial.EMISSION_OP_MULTIPLY
	material.emission_texture = preload("res://assets/maps/floor.rim.png")
	Floor.material_override = material


func start() -> void:
	pass


func update() -> void:
	if not Floor: return
	match State:
		States.IDLE:
			Floor.material_override.emission = IdleColor
			Floor.material_override.albedo_color = IdleColor
		States.STARTING:
			Floor.material_override.emission = StartingColor
			Floor.material_override.albedo_color = StartingColor
		States.PROGRESSING:
			Floor.material_override.emission = ProgressingColor
			Floor.material_override.albedo_color = ProgressingColor
		States.CLEARED:
			Floor.material_override.emission = ClearedColor
			Floor.material_override.albedo_color = ClearedColor

var time = 0
func _process(delta):
	time += delta
	
	if time < 3:
		self.State = States.STARTING
	elif time < 6:
		self.State = States.PROGRESSING
	elif time < 8:
		self.State = States.CLEARED
		emit_signal("cleared")
	elif time < 10:
		self.State = States.IDLE

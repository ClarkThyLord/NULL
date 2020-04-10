tool
extends Spatial



# Imports
const Pawn := preload("res://entities/enemies/Pawn/Pawn.tscn")



# Refrences
onready var Floor := get_node("Floor")



# Declarations
signal started
signal cleared

export(bool) var Start := false setget set_start
func set_start(start : bool) -> void:
	Start = start
	if Start: start()
	else: clean()

enum States { IDLE, STARTING, PROGRESSING, CLEARED }
export(States) var State := States.IDLE setget set_state
func set_state(state : int) -> void:
	State = state


export(Vector2) var Size := Vector2(32, 32) setget set_size
func set_size(size : Vector2, autogenerate := true) -> void:
	Size = Vector2(
		clamp(size.x, 16, 100),
		clamp(size.y, 16, 100)
	)
	if Floor: Floor.scale = Vector3(Size.x, 1, Size.y)


export(Color) var IdleColor := Color("ff00ff") setget set_idle_color
func set_idle_color(color : Color) -> void:
	IdleColor = color

export(Color) var StartingColor := Color("ffff00") setget set_starting_color
func set_starting_color(color : Color) -> void:
	StartingColor = color

export(Color) var ProgressingColor := Color.red setget set_progressing_color
func set_progressing_color(color : Color) -> void:
	ProgressingColor = color

export(Color) var ClearedColor := Color("2dff0f") setget set_cleared_color
func set_cleared_color(color : Color) -> void:
	ClearedColor = color


export(bool) var DitherColor := true setget set_dither
func set_dither(dither : bool) -> void:
	DitherColor = dither
	dither = 0.0
	dither_growth = DitherGrowth

export(float, 0.01, 1.00, 0.01) var DitheringAmount := 0.10 setget set_dither_amount
func set_dither_amount(ditheringamount : float) -> void:
	DitheringAmount = ditheringamount
	dither = 0.0
	dither_growth = DitherGrowth

export(float, 0.01, 0.33, 0.01) var DitherGrowth := 0.01 setget set_dither_growth
func set_dither_growth(dithergrowth : float) -> void:
	DitherGrowth = clamp(dithergrowth, 0.01, DitheringAmount / 3)
	dither = 0.0
	dither_growth = DitherGrowth

var dither := 0.0
var dither_growth = DitherGrowth



# Core
func _ready():
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


func clean() -> void:
	State = States.IDLE
	for child in get_children():
		if child != $Floor:
			child.queue_free()


var entities_count := 1
func sub_entities_count() -> void:
	entities_count -= 1
	if entities_count <= 0:
		cleared()

func start() -> void:
	clean()
	Start = true
	State = States.STARTING
	
	yield(get_tree().create_timer(3), "timeout")
	
	State = States.PROGRESSING
	entities_count = 1 + randi() % 10
	for enemy in range(entities_count):
		var pawn := Pawn.instance()
		pawn.translation = Vector3(
			4 + randi() % int(Size.x * 2 - 12) - Size.x,
			0.1,
			4 + randi() % int(Size.y * 2 - 12) - Size.y
		)
		add_child(pawn)
		pawn.connect("died", self, "sub_entities_count")
	
	emit_signal("started")

func cleared() -> void:
	clean()
	State = States.CLEARED
	emit_signal("cleared")
	
	yield(get_tree().create_timer(3), "timeout")
	
	State = States.IDLE


func set_floor_color(base : Color, rim : Color) -> void:
	if Floor:
		Floor.material_override.emission = base
		Floor.material_override.albedo_color = rim


func _process(delta):
	if Floor:
		var color : Color
		match State:
			States.IDLE: color = IdleColor
			States.STARTING: color = StartingColor
			States.PROGRESSING: color = ProgressingColor
			States.CLEARED: color = ClearedColor
		if DitherColor:
			dither += dither_growth
			color = color.darkened(dither)
			if dither < 0 or dither >= DitheringAmount:
				dither_growth *= -1
		set_floor_color(color, color)

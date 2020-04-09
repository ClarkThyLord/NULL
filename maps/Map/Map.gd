tool
extends Spatial



# Imports
const Level := preload("res://maps/Map/Level/Level.tscn")



# Declarations
var Directions := [ Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN ]


var Map := {} setget set_map   #   Map Schema -> { Vector2 : [Level.tscn] }
func set_map(Map : Dictionary) -> void: pass


export(bool) var AutoGenerate := false setget set_auto_generate
func set_auto_generate(autogenerate : bool) -> void:
	AutoGenerate = autogenerate
	
	if AutoGenerate: generate()
	else: erase_levels()


export(int, 1, 100) var Levels := 1 setget set_levels
func set_levels(levels : int, autogenerate := true) -> void:	
	var prev = Levels
	Levels = clamp(levels, 1, 100)
	
	if prev > Levels:
		while levels < Map.size():
			erase_level(Map.keys().pop_back())
	elif AutoGenerate and autogenerate: generate()

export(Vector2) var LevelSize := Vector2(16, 16) setget set_level_size
func set_level_size(levelsize : Vector2, autogenerate := true) -> void:
	LevelSize = Vector2(
		clamp(levelsize.x, 16, 100),
		clamp(levelsize.y, 16, 100)
	)
	
	if AutoGenerate and autogenerate: generate(null)



# Core
func _ready():
	add_to_group("Map")


func erase_level(level : Vector2) -> void:
	if Map.has(level):
		Map[level].queue_free()
		Map.erase(level)

func erase_levels() -> void:
	for child in get_children():
		if child.is_in_group("Map.Level"):
			child.queue_free()
	Map.clear()


func generate(level = Map.keys().pop_back()) -> void:
	match typeof(level):
		TYPE_NIL:
			erase_levels()
			level = Vector2.ZERO
		TYPE_VECTOR2:
			Directions.shuffle()
			var previous = level
			for direction in Directions:
				if not Map.has(level + direction):
					level = level + direction
			if level == previous:
				generate(Map.keys()[randi() % Map.size()])
		_: return
	
	var levelnode := Level.instance()
	levelnode.Size = LevelSize
	levelnode.translation = Vector3(
		LevelSize.x * level.x * 2,
		0,
		LevelSize.y * level.y * 2
	)
	add_child(levelnode)
	Map[level] = levelnode
	if Map.size() < Levels:
		generate(level)

tool
extends Spatial



# Imports
const Level := preload("res://maps/Map/Level/Level.tscn")



# Declarations
var Directions := [
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.LEFT,
	Vector2.DOWN
]


export(bool) var AutoGenerate := false setget set_auto_generate
func set_auto_generate(autogenerate : bool) -> void:
	AutoGenerate = autogenerate
	if AutoGenerate: generate()
	else: clear()


# levels Schema -> {
#	Vector2 : [Level.tscn]
# }
var levels := {} setget _set_levels
func _set_levels(levels : Dictionary) -> void: pass

export(int, 1, 100) var Levels := 1 setget set_levels
func set_levels(levels : int, autogenerate := true) -> void:
	Levels = clamp(levels, 0, 100)
	if AutoGenerate and autogenerate: generate()

export(Vector2) var LevelSize := Vector2(16, 16) setget set_level_size
func set_level_size(levelsize : Vector2, autogenerate := true) -> void:
	LevelSize = Vector2(
		clamp(levelsize.x, 16, 100),
		clamp(levelsize.y, 16, 100)
	)
	if AutoGenerate and autogenerate: generate()



# Core
func clear() -> void:
	for level_position in levels:
		levels[level_position].queue_free()
	levels.clear()

func generate(level = null) -> void:
	pass
	match typeof(level):
		TYPE_NIL:
			clear()
			level = Vector2.ZERO
		TYPE_VECTOR2:
			Directions.shuffle()
			var previous = level
			for direction in Directions:
				if not levels.has(level + direction):
					level = level + direction
			if level == previous:
				generate(levels.keys()[randi() % levels.size()])
		_: return
	
	var levelnode := Level.instance()
	levelnode.Size = LevelSize
	levelnode.translation = Vector3(
		(LevelSize.x / 2) * level.x,
		0,
		(LevelSize.y / 2) * level.y
	)
	add_child(levelnode)
#	levels[level] = levelnode
#	print(levels)

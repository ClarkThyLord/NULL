tool
extends Spatial



# Imports
const Level := preload("res://maps/Map/Level/Level.tscn")



# Declarations
var Map := {} setget set_map
func set_map(map : Dictionary) -> void: pass

var Route := [] setget set_route
func set_route(route : Array) -> void: pass


export(bool) var Active := false setget set_active
func set_active(active : bool) -> void:
	Active = active
	
	if Active: self.update()
	else: reset()
	


export(Vector2) var LevelSize := Vector2(16, 16) setget set_level_size
func set_level_size(levelsize : Vector2, update := true) -> void:
	LevelSize = Vector2(
		clamp(levelsize.x, 16, 100),
		clamp(levelsize.y, 16, 100)
	)
	
	if Active and update: self.update()



# Core
func _ready():
	add_to_group("Map")


func reset() -> void:
	Map.clear()
	Route.clear()
	for child in get_children():
		if child.is_in_group("Map.Level"):
			child.queue_free()


var Directions := [
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.LEFT,
	Vector2.DOWN
]
func update() -> void:
	if not Active: return
	
	var level_position : Vector2
	if Route.size() == 0:
		level_position == Vector2.ZERO
	else:
		level_position = Route.back()
		Directions.shuffle()
		for direction in Directions:
			if not Map.has(level_position + direction) or direction == Directions.back():
				level_position = level_position + direction
				break
	
	if not Map.has(level_position):
		var level := Level.instance()
		level.Size = LevelSize
		level.translation = Vector3(
			LevelSize.x * level_position.x * 2,
			0,
			LevelSize.y * level_position.y * 2
		)
		add_child(level)
		Map[level_position] = level
	Route.append(level_position)
	Map[level_position].connect("cleared", self, "update", [], CONNECT_ONESHOT)
	Map[level_position].start()


#func erase_level(level : Vector2) -> void:
#	if Map.has(level):
#		Map[level].queue_free()
#		Map.erase(level)
#
#func erase_levels() -> void:
#	for child in get_children():
#		if child.is_in_group("Map.Level"):
#			child.queue_free()
#	Map.clear()
#
#
#func generate(level = Map.keys().pop_back()) -> void:
#	match typeof(level):
#		TYPE_NIL:
#			erase_levels()
#			level = Vector2.ZERO
#		TYPE_VECTOR2:
#			Directions.shuffle()
#			var previous = level
#			for direction in Directions:
#				if not Map.has(level + direction):
#					level = level + direction
#			if level == previous:
#				generate(Map.keys()[randi() % Map.size()])
#		_: return
#
#	var levelnode := Level.instance()
#	levelnode.Size = LevelSize
#	levelnode.translation = Vector3(
#		LevelSize.x * level.x * 2,
#		0,
#		LevelSize.y * level.y * 2
#	)
#	add_child(levelnode)
#	Map[level] = levelnode
#	if Map.size() < Levels:
#		generate(level)

tool
extends ColorRect



# Declarations
export(PoolVector2Array) var Route : PoolVector2Array setget set_route
func set_route(route : PoolVector2Array, update := true) -> void:
	Route = route
	if update: self._update()


export(int, 1, 10) var PathSize := 3 setget set_path_size
func set_path_size(pathsize : int, update := true) -> void:
	PathSize = clamp(pathsize, 1, 10)
	if update: self._update()

export(Color) var PathColor := Color("531c6a") setget set_path_color
func set_path_color(pathcolor : Color, update := true) -> void:
	PathColor = pathcolor
	if update: self._update()


export(int, 12, 64) var LevelSize := 16 setget set_level_size
func set_level_size(levelsize : int, update := true) -> void:
	LevelSize = clamp(levelsize, 12, 64)
	if update: self._update()

export(Color) var FirstLevelColor := Color.green setget set_first_level_color
func set_first_level_color(color : Color, update := true) -> void:
	FirstLevelColor = color
	if update: self._update()

export(Color) var LevelColor := Color.purple setget set_level_color
func set_level_color(color : Color, update := true) -> void:
	LevelColor = color
	if update: self._update()

export(Color) var LastLevelColor := Color.red setget set_last_level_color
func set_last_level_color(color : Color, update := true) -> void:
	LastLevelColor = color
	if update: self._update()


export(Color) var BackgroundColor := Color(0, 0, 0, 0) setget set_background_color
func set_background_color(color : Color, update := true) -> void:
	BackgroundColor = color
	if update: color = BackgroundColor



# Core
func _init():
	Route = [
		Vector2.ZERO,
		Vector2(1, 0),
		Vector2(2, 0),
		Vector2(2, 1),
		Vector2(2, 2),
		Vector2(2, 3),
		Vector2(2, 4),
		Vector2(1, 4),
		Vector2(0, 4),
		Vector2(-1, 4),
		Vector2(-2, 4),
		Vector2(-3, 4)
	]

func _update() -> void:
	if not is_inside_tree(): return
	
	yield($Map.draw({
		'route': Route,
		'parent_size': rect_size,
		'path_size': PathSize,
		'path_color': PathColor,
		'level_size': LevelSize,
		'first_level_color': FirstLevelColor,
		'level_color': LevelColor,
		'last_level_color': LastLevelColor
	}), "completed")
	
	var image := ImageTexture.new()
	image.create_from_image($Map.get_texture().get_data())
	$RouteMap/MapTexture.texture = image

#func _draw():
#	pass
#	var map_rect := Rect2()
#	for position in Route:
#		map_rect = map_rect.merge(Rect2(position * LevelSize, Vector2.ONE * LevelSize))
#	if map_rect.size.x < rect_size.x: map_rect.size.x = rect_size.x
#	if map_rect.size.y < rect_size.y: map_rect.size.y = rect_size.y
#	get_background().rect_min_size = map_rect.size
#
#
#	var prev_position := Vector2()
#	for index in range(Route.size()):
#		var position = Route[index]
#		draw_rect(
#			Rect2(position * LevelSize + (map_rect.size / 2), Vector2.ONE * LevelSize),
#			FirstLevelColor if index == 0 else (LastLevelColor if index == Route.size() - 1 else LevelColor)
#		)
#		draw_line(
#			(position * LevelSize) + (Vector2.ONE * (LevelSize / 2 )) + (map_rect.size / 2),
#			(prev_position * LevelSize) + (Vector2.ONE * (LevelSize / 2)) + (map_rect.size / 2),
#			PathColor, PathSize
#		)
#		prev_position = position

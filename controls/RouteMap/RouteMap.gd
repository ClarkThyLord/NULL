tool
extends ScrollContainer



# Declarations
export(PoolVector2Array) var Route : PoolVector2Array setget set_route
func set_route(route : PoolVector2Array, update := true) -> void:
	Route = route
	if update: self.update()


export(int, 1, 10) var PathSize := 3 setget set_path_size
func set_path_size(pathsize : int, update := true) -> void:
	PathSize = clamp(pathsize, 1, 10)
	if update: self.update()

export(Color) var PathColor := Color.mediumvioletred setget set_path_color
func set_path_color(pathcolor : Color, update := true) -> void:
	PathColor = pathcolor
	if update: self.update()


export(int, 12, 64) var LevelSize := 16 setget set_level_size
func set_level_size(levelsize : int, update := true) -> void:
	LevelSize = clamp(levelsize, 12, 64)
	if update: self.update()

export(Color) var LevelColor := Color.mediumvioletred setget set_level_color
func set_level_color(levelcolor : Color, update := true) -> void:
	LevelColor = levelcolor
	if update: self.update()



# Core
func _draw():
	var  prev_position : Vector2
	for position in Route:
		draw_rect(
			Rect2(position * LevelSize, Vector2.ONE * LevelSize),
			LevelColor
		)
		draw_line(
			(position * LevelSize) + (Vector2.ONE * (LevelSize / 2)),
			(prev_position * LevelSize) + (Vector2.ONE * (LevelSize / 2))
		, PathColor, PathSize)
		prev_position = position

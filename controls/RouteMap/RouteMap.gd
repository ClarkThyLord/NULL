tool
extends ColorRect



# Declarations
export(PoolVector2Array) var Route : PoolVector2Array setget set_route
func set_route(route : PoolVector2Array, update := true) -> void:
	Route = route
	if update: self.update()


export(int, 1, 10) var PathSize := 3 setget set_path_size
func set_path_size(pathsize : int, update := true) -> void:
	PathSize = clamp(pathsize, 1, 10)
	if update: self.update()

export(Color) var PathColor := Color("531c6a") setget set_path_color
func set_path_color(pathcolor : Color, update := true) -> void:
	PathColor = pathcolor
	if update: self.update()


export(int, 12, 64) var LevelSize := 16 setget set_level_size
func set_level_size(levelsize : int, update := true) -> void:
	LevelSize = clamp(levelsize, 12, 64)
	if update: self.update()

export(Color) var FirstLevelColor := Color.green setget set_first_level_color
func set_first_level_color(firstlevelcolor : Color, update := true) -> void:
	FirstLevelColor = firstlevelcolor
	if update: self.update()

export(Color) var LevelColor := Color.purple setget set_level_color
func set_level_color(levelcolor : Color, update := true) -> void:
	LevelColor = levelcolor
	if update: self.update()

export(Color) var LastLevelColor := Color.red setget set_last_level_color
func set_last_level_color(lastlevelcolor : Color, update := true) -> void:
	LastLevelColor = lastlevelcolor
	if update: self.update()


export(bool) var Scroll := true

export(Vector2) var ScrollAmount := Vector2() setget set_scroll_amount
func set_scroll_amount(scroll_amount : Vector2, update := true) -> void:
	ScrollAmount = scroll_amount
	if update: self.update()

export(float, 1, 100) var ScrollSensitivity := 16.0



# Core
func _draw():
	var map_rect := Rect2()
	for position in Route:
		map_rect = map_rect.merge(Rect2(position * LevelSize, Vector2.ONE * LevelSize))
	
	var offset := rect_size / 2 + ScrollAmount
	var scale := Vector2.ONE
	
	var prev_position := Vector2()
	for index in range(Route.size()):
		var position = Route[index]
		draw_rect(
			Rect2((position * LevelSize + offset) * scale, Vector2.ONE * LevelSize * scale),
			FirstLevelColor if index == 0 else (LastLevelColor if index == (Route.size() - 1) else LevelColor)
		)
		draw_line(
			((position * LevelSize) + (Vector2.ONE * (LevelSize / 2 )) + offset) * scale,
			((prev_position * LevelSize) + (Vector2.ONE * (LevelSize / 2)) + offset) * scale,
			PathColor, PathSize * (scale.y / scale.x)
		)
		prev_position = position


func _on_gui_input(event):
	if Scroll and event is InputEventMouseMotion and Input.is_mouse_button_pressed(BUTTON_LEFT):
		self.ScrollAmount += event.relative.normalized() * ScrollSensitivity

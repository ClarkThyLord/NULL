tool
extends Node2D



# Declarations
var info : Dictionary
var Size : Vector2



# Core
func _update(info : Dictionary) -> void:
	self.info = info
	update()


func _draw() -> void:
	if info.size() == 0: return
	
	var map_rect := Rect2()
	for position in info["route"]:
		map_rect = map_rect.merge(Rect2(position * info["level_size"], Vector2.ONE * info["level_size"]))
	if map_rect.size.x < info["parent_size"].x: map_rect.size.x = info["parent_size"].x
	if map_rect.size.y < info["parent_size"].y: map_rect.size.y = info["parent_size"].y
	var offset = map_rect.size / 2
	Size = map_rect.size
	
	var prev_position := Vector2()
	for index in range(info["route"].size()):
		var position = info["route"][index]
		draw_rect(
			Rect2(position * info["level_size"] + offset, Vector2.ONE * info["level_size"]),
			info["first_level_color"] if index == 0 else (info["last_level_color"] if index == info["route"].size() - 1 else info["level_color"])
		)
		draw_line(
			(position * info["level_size"]) + (Vector2.ONE * (info["level_size"] / 2 )) + offset,
			(prev_position * info["level_size"]) + (Vector2.ONE * (info["level_size"] / 2)) + offset,
			info["path_color"], info["path_size"]
		)
		prev_position = position

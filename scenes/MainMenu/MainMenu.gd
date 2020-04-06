extends Control



# Refrences
onready var Effects := get_node("Effects")

onready var Start := get_node("VBoxContainer/VBoxContainer/Start")



# Core
func _ready():
	correct()


func correct() -> void:
	if Effects:
		Effects.position.x = rect_size.x / 2
		Effects.scale.x = rect_size.x / 1024
		Effects.scale.y = rect_size.y / 600


func _on_resized(): correct()


func _on_Start_pressed():
	get_tree().change_scene("res://maps/Testing.tscn")

func _on_Start_mouse_entered():
	Start.material.blend_mode = BLEND_MODE_ADD

func _on_Start_mouse_exited():
	Start.material.blend_mode = BLEND_MODE_MIX

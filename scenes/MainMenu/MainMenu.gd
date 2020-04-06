extends Control



# Refrences
onready var MenuParticles := get_node("OffsetShader/MenuParticles")

onready var HighScore := get_node("VBoxContainer/HighScore")
onready var Start := get_node("VBoxContainer/VBoxContainer/Start")



# Core
func correct() -> void:
	if MenuParticles:
		MenuParticles.position.x = rect_size.x / 2


func _on_resized(): correct()

func _on_Start_pressed():
	get_tree().change_scene("res://maps/Testing.tscn")

extends ColorRect



# Refrences
onready var MenuParticles := get_node("MenuParticles")



# Core
func _ready(): correct()


func correct() -> void:
	if MenuParticles:
		MenuParticles.position = rect_size / 2
		MenuParticles.lifetime = 4 * (rect_size.x / 1024)


func _on_resized(): correct()


func _on_Exit_pressed():
	get_tree().change_scene("res://scenes/MainMenu/MainMenu.tscn")

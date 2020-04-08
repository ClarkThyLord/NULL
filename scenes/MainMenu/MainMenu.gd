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


func _on_Start_pressed():
	get_tree().change_scene("res://maps/Testing.tscn")

func _on_Controls_pressed():
	pass # Replace with function body.

func _on_HighScores_pressed():
	get_tree().change_scene("res://scenes/HighScores/HighScores.tscn")

func _on_GitHub_pressed():
	OS.shell_open("https://github.com/ClarkThyLord/NULL")

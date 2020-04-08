extends ColorRect



# Core
func _ready(): correct()


func correct() -> void: pass


func _on_resized(): correct()


func _on_Start_pressed():
	get_tree().change_scene("res://maps/Testing.tscn")

func _on_Controls_pressed():
	pass # Replace with function body.

func _on_HighScores_pressed():
	pass # Replace with function body.

func _on_GitHub_pressed():
	OS.shell_open("https://github.com/ClarkThyLord/NULL")

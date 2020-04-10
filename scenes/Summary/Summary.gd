extends ColorRect



# Imports
const BackgroundMusic := preload("res://assets/audio/0cc ost - Track 04 (Takeoff for Combat).ogg")



# Refrences
onready var MenuParticles := get_node("MenuParticles")

onready var Score := get_node("HBoxContainer/VBoxContainer/VBoxContainer/Score")



# Core
func _ready():
	correct()
	
	Score.text = "YOUR SCORE\n" + str(get_node("/root/Server").CurrentPoints)
	
	if get_node("/root/Server").BackgroundMusic.stream != BackgroundMusic:
		get_node("/root/Server").BackgroundMusic.stream = BackgroundMusic
	if not get_node("/root/Server").BackgroundMusic.playing:
		get_node("/root/Server").BackgroundMusic.play()


func correct() -> void:
	if MenuParticles:
		MenuParticles.position = rect_size / 2
		MenuParticles.lifetime = 4 * (rect_size.x / 1024)


func _on_resized(): correct()


func _on_MainMenu_pressed():
	get_tree().change_scene("res://scenes/MainMenu/MainMenu.tscn")

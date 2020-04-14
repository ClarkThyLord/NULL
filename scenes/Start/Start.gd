extends ColorRect



# Imports
const BackgroundMusic := preload("res://assets/audio/0cc ost - Track 04 (Takeoff for Combat).ogg")



# Refrences
onready var SoundEffects := get_node("SoundEffects")
onready var MenuParticles := get_node("MenuParticles")

onready var Controls := get_node("Controls")

onready var input := get_node("Input")
onready var Name := get_node("Input/Name")

onready var Start := get_node("HBoxContainer/VBoxContainer/Start")



# Core
func _ready():
	correct()
	
	if get_node("/root/Server").BackgroundMusic.stream != BackgroundMusic:
		get_node("/root/Server").BackgroundMusic.stream = BackgroundMusic
	if not get_node("/root/Server").BackgroundMusic.playing:
		get_node("/root/Server").BackgroundMusic.play()
	
	if not Engine.editor_hint:
		Name.grab_focus()
		Start.visible = false
		Controls.visible = false


func correct() -> void:
	if MenuParticles:
		MenuParticles.position = rect_size / 2
		MenuParticles.lifetime = 4 * (rect_size.x / 1024)


func _on_resized(): correct()


func _on_Name_text_changed(new_text : String) -> void:
	SoundEffects.play()
	Start.visible = not Name.text.empty()

func _on_Name_text_entered(new_text : String) -> void:
	if not Name.text.empty(): Start.grab_focus()


func _on_Start_pressed():
	if get_node("/root/Server").Scores.size() > 10 or Controls.visible:
		get_node("/root/Server").CurrentName = Name.text.to_upper()
		get_node("/root/Server").CurrentPoints = 0
		
		get_tree().change_scene("res://maps/Map/Map.tscn")
	else:
		input.visible = false
		Controls.visible = true

func _on_Back_pressed():
	get_tree().change_scene("res://scenes/MainMenu/MainMenu.tscn")

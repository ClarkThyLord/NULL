extends ColorRect



# Imports
const BackgroundMusic := preload("res://assets/audio/0cc ost - Track 04 (Takeoff for Combat).ogg")



# Refrences
onready var SoundEffects := get_node("SoundEffects")
onready var MenuParticles := get_node("MenuParticles")

onready var Name := get_node("HBoxContainer/VBoxContainer/VBoxContainer/Name")

onready var Start := get_node("HBoxContainer/VBoxContainer/VBoxContainer2/Start")



# Core
func _ready():
	correct()
	
	if get_node("/root/Server").BackgroundMusic.stream != BackgroundMusic:
		get_node("/root/Server").BackgroundMusic.stream = BackgroundMusic
	if not get_node("/root/Server").BackgroundMusic.playing:
		get_node("/root/Server").BackgroundMusic.play()
	
	Name.grab_focus()


func correct() -> void:
	if MenuParticles:
		MenuParticles.position = rect_size / 2
		MenuParticles.lifetime = 4 * (rect_size.x / 1024)


func _on_resized(): correct()


func _on_Name_text_changed(new_text : String) -> void:
	SoundEffects.play()
	Start.disabled = Name.text.empty()

func _on_Name_text_entered(new_text : String) -> void:
	Start.grab_focus()


func _on_Start_pressed():
	var regex = RegEx.new()
	regex.compile("[A-Za-z]+$")
	var result = regex.search(Name.text)
	var name = result.get_string().to_upper()
	
	get_tree().change_scene("res://maps/Testing.tscn")

func _on_Back_pressed():
	get_tree().change_scene("res://scenes/MainMenu/MainMenu.tscn")

extends ColorRect



# Imports
const BackgroundMusic := preload("res://assets/audio/0cc ost - Track 04 (Takeoff for Combat).ogg")



# Refrences
onready var MenuParticles := get_node("MenuParticles")

onready var Score := get_node("HBoxContainer/VBoxContainer/VBoxContainer/Score")

onready var HighScore := get_node("HBoxContainer/VBoxContainer/VBoxContainer2/HighScore")
onready var HighScoreBlinker := get_node("HBoxContainer/VBoxContainer/VBoxContainer2/HighScore/BlinkTimer")



# Core
func _ready():
	correct()
	
	if get_node("/root/Server").add_score():
		Score.text = "YOUR SCORE\n" + str(get_node("/root/Server").CurrentPoints)
		var position : int
		var scores_sorted = get_node("/root/Server").get_scores_sorted()
		for score in range(scores_sorted.size()):
			if scores_sorted[score][0] == get_node("/root/Server").CurrentName:
				position = score
				break
		if position >= 10:
			Score.text += "\n!!!NEW HIGH SCORE!!!"
			HighScoreBlinker.start()
	
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
	get_node("/root/Server").CurrentName = ""
	get_node("/root/Server").CurrentPoints = 0
	get_tree().change_scene("res://scenes/MainMenu/MainMenu.tscn")


func _on_BlinkTimer_timeout():
	HighScore.hide() if HighScore.visible else HighScore.show()

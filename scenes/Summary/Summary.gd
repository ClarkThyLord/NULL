extends ColorRect



# Imports
const BackgroundMusic := preload("res://assets/audio/0cc ost - Track 04 (Takeoff for Combat).ogg")



# Refrences
onready var MenuParticles := get_node("MenuParticles")

onready var Score := get_node("HBoxContainer/VBoxContainer/VBoxContainer/Score")

onready var RouteMap := get_node("HBoxContainer/VBoxContainer/VBoxContainer/RouteMap")

onready var HighScore := get_node("HBoxContainer/VBoxContainer/VBoxContainer2/HighScore")
onready var HighScoreBlinker := get_node("HBoxContainer/VBoxContainer/VBoxContainer2/HighScore/BlinkTimer")

onready var ScoreBoard := get_node("HBoxContainer/VBoxContainer/ScoreBoard")



# Core
func _ready():
	correct()
	
	if not Engine.editor_hint:
		HighScore.hide()
	
	RouteMap.Route = get_node("/root/Server").CurrentRoute
	
	Score.text = "YOUR SCORE\n" + str(get_node("/root/Server").CurrentPoints)
	var previous_score = get_node("/root/Server").Scores.get(get_node("/root/Server").CurrentName, 0)
	if get_node("/root/Server").add_score():
		var position : int
		var scores_sorted = get_node("/root/Server").get_scores_sorted()
		for score in range(scores_sorted.size()):
			if scores_sorted[score][0] == get_node("/root/Server").CurrentName:
				position = score
				break
		if get_node("/root/Server").CurrentPoints > previous_score:
			HighScoreBlinker.start()
	ScoreBoard._update()
	
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


func _on_Twitter_pressed():
	var url := "https://twitter.com/intent/tweet?url=https%3A%2F%2Fgotm.io%2Fnobodies%2Fnull&text=New%20"
	if not HighScoreBlinker.is_stopped():
		url += "high%20"
	url += "score%20" + str(get_node("/root/Server").CurrentPoints) + "%2C%20in%20the%20new%203D%20Arcade%20Hack%20and%20Slash&hashtags=NULL%2Cgodot%2Chighscore"
	OS.shell_open(url)

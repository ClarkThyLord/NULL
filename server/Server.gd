tool
extends Node



# Declarations
var BackgroundMusic := AudioStreamPlayer.new() setget set_background_music
func set_background_music(backgroundmusic : AudioStreamPlayer) -> void: pass

var Options := preload("res://scenes/Options/Options.tscn").instance()

var CurrentName := ""
var CurrentPoints := 0
var CurrentRoute := []

var Scores := {} setget set_scores, get_scores
func set_scores(scores : Dictionary) -> void: pass
func get_scores() -> Dictionary: return Scores.duplicate()



# Core
func _init(): load_game()
func _ready():
	add_child(Options)
	add_child(BackgroundMusic)
	
	load_game()
	if Scores.size() == 0:
		add_score("ClarkThyLord", 7777)
		add_score("FrogEmperor", 666)
		add_score("Unknown", 444)
		add_score("Secret", 444)
		add_score("Tower", 444)
		add_score("Bird", 201)
		add_score("Shielder", 144)
		add_score("Charger", 133)
		add_score("Pawn", 22)
		add_score("LOSER", 1)
		save_game()


func save_game() -> void:
	var save = File.new()
	var opened = save.open("user://savegame.save", File.WRITE)
	if opened == OK:
		save.store_string(JSON.print(Scores))
		save.close()

func load_game() -> void:
	var save = File.new()
	var opened = save.open("user://savegame.save", File.READ)
	if opened == OK:
		var result := JSON.parse(save.get_as_text())
		Scores = result.result if result.error == OK else {}
		save.close()

func reset_game() -> void:
	Scores.clear()
	save_game()


func add_score(name := CurrentName, points := CurrentPoints) -> bool:
	if name.empty() or (Scores.has(name) and points <= Scores[name]): return false
	Scores[name.to_upper()] = points
	save_game()
	return true

class MyCustomSorter:
	static func sort_descending(a, b):
		return a[1] > b[1]
func get_scores_sorted() -> Array:
	var scores_sorted := []
	for name in Scores.keys():
		scores_sorted.append([name, Scores[name]])
	scores_sorted.sort_custom(MyCustomSorter, "sort_descending")
	return scores_sorted

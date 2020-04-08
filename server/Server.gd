tool
extends Node



# Declarations
var BackgroundMusic := AudioStreamPlayer.new() setget set_background_music
func set_background_music(backgroundmusic : AudioStreamPlayer) -> void: pass

var ScoreBoard := {} setget set_score_board, get_score_board
func set_score_board(scoreboard : Dictionary) -> void: pass
func get_score_board() -> Dictionary: return ScoreBoard.duplicate()



# Core
func _init(): load_game()
func _ready():
	load_game()
	if ScoreBoard.size() == 0:
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
	
	add_child(BackgroundMusic)


func save_game() -> void:
	var save = File.new()
	var opened = save.open("user://savegame.save", File.WRITE)
	if opened == OK:
		save.store_string(JSON.print(ScoreBoard))
		save.close()

func load_game() -> void:
	var save = File.new()
	var opened = save.open("user://savegame.save", File.READ)
	if opened == OK:
		var result := JSON.parse(save.get_as_text())
		ScoreBoard = result.result if result.error == OK else {}
		save.close()

func reset_game() -> void:
	ScoreBoard.clear()
	save_game()


func add_score(name : String, points : int) -> void:
	if ScoreBoard.has(name) and ScoreBoard[name] <= points: return
	ScoreBoard[name] = points
	save_game()

tool
extends ScrollContainer



# Imports
const Score := preload("res://controls/ScoreBoard/Score/Score.tscn")



# Refrences
onready var Scores := get_node("Scores")



# Declarations
export(bool) var LimitScores := true setget set_limit_scores
func set_limit_scores(limitscores : bool) -> void:
	LimitScores = limitscores
	_update()

export(int) var MaximumScores := 10 setget set_maximum_scores
func set_maximum_scores(maximumscores : int) -> void:
	MaximumScores = maximumscores
	_update()



# Core
func _ready(): _update()


func _update() -> void:
	if Scores:
		for child in Scores.get_children():
			child.queue_free()
		
		var scores := []
		var scores_count := 0
		while scores_count < (MaximumScores if LimitScores else INF):
			if scores_count >= scores.size(): break
			scores_count += 1
			var score := Score.instance()
			score.Name = "ClarkThyLord"
			score.Points = 1 + randi() % 1000000000
			Scores.add_child(score)

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
		
		var rank := 0
		var current_rank := -1
		var scores_sorted = get_node("/root/Server").get_scores_sorted()
		while rank < (MaximumScores if LimitScores else INF):
			if rank >= scores_sorted.size(): break
			var score := Score.instance()
			score.Rank = rank + 1
			score.Name = scores_sorted[rank][0]
			score.Points = scores_sorted[rank][1]
			Scores.add_child(score)
			if scores_sorted[rank][0] == get_node("/root/Server").CurrentName:
				score.grab_focus()
				current_rank = rank
			rank += 1
		
		if current_rank > -1:
			yield(get_tree(), "idle_frame")
			scroll_vertical = (current_rank + 5) * 16

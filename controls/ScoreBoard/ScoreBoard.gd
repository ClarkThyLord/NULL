tool
extends ScrollContainer



# Imports
const Score := preload("res://controls/ScoreBoard/Score/Score.tscn")



# Refrences
class MyCustomSorter:
	static func sort_descending(a, b):
		return a[1] > b[1]


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
		var scores : Dictionary = get_node("/root/Server").ScoreBoard
		var scores_sorted := []
		for name in scores.keys():
			scores_sorted.append([name, scores[name]])
		scores_sorted.sort_custom(MyCustomSorter, "sort_descending")
		while rank < (MaximumScores if LimitScores else INF):
			if rank >= scores_sorted.size(): break
			var score := Score.instance()
			score.Rank = rank + 1
			score.Name = scores_sorted[rank][0]
			score.Points = scores_sorted[rank][1]
			Scores.add_child(score)
			rank += 1

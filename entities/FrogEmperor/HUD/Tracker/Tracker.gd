tool
extends VBoxContainer



# Imports
const Event := preload("res://entities/FrogEmperor/HUD/Tracker/Event/Event.tscn")



# Refrences
onready var ScoreLabel := get_node("HBoxContainer/Score")

onready var Events := get_node("Events")



# Declarations
export(int, 0, 1000000000) var Score := 0 setget set_score
func set_score(score : int) -> void:
	Score = score



# Core
func add_event(event : String) -> void:
	var event_node := Event.instance()
	event_node.text = event
	Events.add_child(event_node)


func _process(delta):
	if ScoreLabel and int(ScoreLabel.text) != Score:
		ScoreLabel.text = "%010d" %  (int(ScoreLabel.text) + sign(Score - int(ScoreLabel.text)))
	
	if Events:
		var last_event = Events.get_children()
		if last_event.size() > 0:
			last_event = last_event.back()
			last_event.modulate.a -= 0.05
			if last_event.modulate.a <= 0:
				last_event.queue_free()

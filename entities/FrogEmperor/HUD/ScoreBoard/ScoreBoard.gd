extends VBoxContainer



# Imports
const Event := preload("res://entities/FrogEmperor/HUD/ScoreBoard/Event/Event.tscn")



# Refrences
var ScoreValue := 0
var CurrentValue := 0
onready var Score := get_node("Score")

onready var Events := get_node("Events")



# Core
func set_score(score : int) -> void:
	ScoreValue = score


func add_event(event : String) -> void:
	var event_node := Event.instance()
	event_node.text = event
	Events.add_child(event_node)


func _process(delta):
	if CurrentValue != ScoreValue:
		CurrentValue += sign(ScoreValue - CurrentValue)
		Score.text = "%010d" % CurrentValue
	
	var last_event = Events.get_children()
	if last_event.size() > 0:
		last_event = last_event.back()
		last_event.modulate.a -= 0.05
		if last_event.modulate.a <= 0:
			last_event.queue_free()

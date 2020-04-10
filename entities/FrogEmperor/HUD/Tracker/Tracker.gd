tool
extends VBoxContainer



# Imports
const Event := preload("res://entities/FrogEmperor/HUD/Tracker/Event/Event.tscn")



# Refrences
onready var Score := get_node("HBoxContainer/Score")

onready var Events := get_node("Events")



# Core
func add_event(event : String) -> void:
	var event_node := Event.instance()
	event_node.text = event
	Events.add_child(event_node)


func _process(delta):
	var score = get_node("/root/Server").CurrentPoints
	if Score and int(Score.text) != score:
		Score.text = str(int(Score.text) + sign(score - int(Score.text)))
	
	if Events:
		var last_event = Events.get_children()
		if last_event.size() > 0:
			last_event = last_event.back()
			last_event.modulate.a -= 0.05
			if last_event.modulate.a <= 0:
				last_event.queue_free()

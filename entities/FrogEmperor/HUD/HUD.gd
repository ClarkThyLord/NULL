extends Control



# Refrences
onready var Health := get_node("Stats/HBoxContainer/Health")
onready var Stamina := get_node("Stats/HBoxContainer2/Stamina")

onready var ScoreBoard := get_node("ScoreBoard")

onready var Menu := get_node("Menu")

onready var Summary := get_node("Summary")
onready var FinalScore := get_node("Summary/FinalScore")



# Core
func _ready():
	hide_menu()
	Summary.visible = false


func update_health(health : int) -> void:
	Health.value = health

func update_stamina(stamina : int) -> void:
	Stamina.value = stamina


func toggle_menu() -> void:
	 hide_menu() if Menu.visible else show_menu()

func show_menu() -> void:
	Menu.show()
	get_tree().paused = true

func hide_menu() -> void:
	Menu.hide()
	get_tree().paused = false

func show_summary() -> void:
	FinalScore.text = "YOUR SCORE\n" + ("%010d" % ScoreBoard.ScoreValue)
	Summary.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true


func _unhandled_key_input(event : InputEventKey) -> void:
	if not Summary.visible and not event.pressed:
		match event.scancode:
			KEY_ESCAPE:
				toggle_menu()
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED)


func _on_Quit_pressed():
	get_tree().change_scene("res://scenes/MainMenu/MainMenu.tscn")
	get_tree().paused = false


func _on_Retire_pressed():
	get_tree().change_scene("res://scenes/MainMenu/MainMenu.tscn")
	get_tree().paused = false

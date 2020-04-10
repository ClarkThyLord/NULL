extends CanvasLayer


# Refrences
onready var background := get_node("Background")
onready var popup := get_node("Popup")



# Core
func _ready():
	correct()
	get_tree().connect("screen_resized", self, "correct")


func correct() -> void:
	if popup.visible: popup.popup_centered_ratio()


func show() -> void:
	popup.popup_centered_ratio()
	background.show()

func hide() -> void:
	popup.hide()
	background.hide()


func _on_Close_pressed():
	popup.hide()
	background.hide()

extends CanvasLayer


# Refrences
onready var background := get_node("Background")
onready var popup := get_node("Popup")



# Core
func _ready():
	correct()
	background.visible = false
	get_tree().connect("screen_resized", self, "correct")


func correct() -> void:
	if popup and popup.visible:
		var ratio = get_viewport().size / Vector2(1024, 600)
		popup.rect_position = Vector2(212, 100) * ratio
		popup.rect_size = popup.rect_min_size * ratio


func show() -> void:
	correct()
	popup.popup_centered()

func hide() -> void:
	popup.hide()


func _on_Popup_visibility_changed():
	if background and popup:
		background.visible = popup.visible

func _on_Close_pressed(): hide()

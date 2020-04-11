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
		popup.rect_size = Vector2(600, 400) * ratio


func show() -> void:
	correct()
	popup.popup_centered()

func hide() -> void:
	popup.hide()


func _on_Popup_visibility_changed():
	if background and popup:
		background.visible = popup.visible

func _on_Close_pressed(): hide()


func _on_slider_value_changed(value):
	$SoundEffects.play()


func _on_Sound_value_changed(value):
	value = -40 + (40 * (value * 0.01))
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), value == -40)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

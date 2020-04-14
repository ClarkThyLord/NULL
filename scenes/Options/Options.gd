extends CanvasLayer


# Refrences
onready var popup := get_node("Popup")
onready var background := get_node("Background")


onready var Options := get_node("Popup/TextureRect/VBoxContainer/Options")

onready var Sound := get_node("Popup/TextureRect/VBoxContainer/Options/VBoxContainer/GridContainer/Sound")
onready var Music := get_node("Popup/TextureRect/VBoxContainer/Options/VBoxContainer/GridContainer/Music")
onready var Effects := get_node("Popup/TextureRect/VBoxContainer/Options/VBoxContainer/GridContainer/Effects")

onready var Controls := get_node("Popup/TextureRect/VBoxContainer/Controls")



# Declarations
export(int) var MinSound := -40
export(int) var MaxSound := 45

export(int) var MinMusic := -40
export(int) var MaxMusic := 45

export(int) var MinEffects := -40
export(int) var MaxEffects := 45



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
	Sound.value = ((AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) + -MinSound) / MaxSound) * 100
	Music.value = ((AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")) + -MinMusic) / MaxMusic) * 100
	Effects.value = ((AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Effects")) + -MinEffects) / MaxEffects) * 100
	
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
	value = MinSound + (MaxSound * (value * 0.01))
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), value == MinSound)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	get_node("/root/Server").save_config()


func _on_Music_value_changed(value):
	value = MinMusic + (MaxMusic * (value * 0.01))
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), value == MinMusic)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	get_node("/root/Server").save_config()


func _on_Effects_value_changed(value):
	value = MinEffects + (MaxEffects * (value * 0.01))
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Effects"), value == MinEffects)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), value)
	get_node("/root/Server").save_config()



func _on_ViewControls_pressed():
	Options.visible = false
	Controls.visible = true

func _on_Controls_pressed():
	Options.visible = true
	Controls.visible = false

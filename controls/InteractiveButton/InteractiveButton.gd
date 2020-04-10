extends Button



# Core
func _on_mouse_entered():
	if not disabled: $AudioStreamPlayer.play()

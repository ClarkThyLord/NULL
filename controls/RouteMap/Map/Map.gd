tool
extends Viewport



# Core
func draw(info : Dictionary) -> void:
	$MapTexture._update(info)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	size = $MapTexture.Size

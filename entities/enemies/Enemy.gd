extends Entity
class_name Enemy
onready var FrogEmperor = get_parent().get_node("FrogEmperor")

# Core
func _ready():
	add_to_group("enemies", true)
	
func _process(delta):
	look_at(FrogEmperor.get_transform().origin, Vector3(0,1,0))
	rotation.z = 0
	rotation.x = 0
# Seek Schema -> {
#	'found' : null | Entity
#}
func seek() -> Dictionary:
	return {
		'found': null
	}

extends Entity
class_name Enemy



# Core
func _ready():
	add_to_group("enemies", true)


# Seek Schema -> {
#	'found' : null | Entity
#}
func seek() -> Dictionary:
	return {
		'found': null
	}

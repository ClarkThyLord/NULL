tool
extends HBoxContainer



# Refrences
onready var NameLabel := get_node("Name")
onready var PointsLabel := get_node("Points")



# Declarations
export(String) var Name := "" setget set_name
func set_name(name : String) -> void:
	Name = name
	if NameLabel: NameLabel.text = Name

export(int, 0, 1000000000) var Points := 0 setget set_points
func set_points(points : int) -> void:
	Points = points
	if PointsLabel: PointsLabel.text = "%010d" % Points



# Core
func _ready():
	set_name(Name)
	set_points(Points)

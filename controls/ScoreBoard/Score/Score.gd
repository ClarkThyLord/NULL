tool
extends ColorRect



# Refrences
onready var RankLabel := get_node("HBoxContainer/Rank")
onready var NameLabel := get_node("HBoxContainer/Name")
onready var PointsLabel := get_node("HBoxContainer/Points")



# Declarations
export(int, 0, 1000000000) var Rank := 0 setget set_rank
func set_rank(rank : int) -> void:
	Rank = rank
	if RankLabel: RankLabel.text = str(rank)


export(String) var Name := "" setget set_name
func set_name(name : String) -> void:
	Name = name
	if NameLabel: NameLabel.text = Name

export(int, 0, 1000000000) var Points := 0 setget set_points
func set_points(points : int) -> void:
	Points = points
	if PointsLabel: PointsLabel.text = str(Points)



# Core
func _ready():
	color.a = 0
	set_rank(Rank)
	set_name(Name)
	set_points(Points)


func _on_focus_entered():
	color.a = 0.1

func _on_focus_exited():
	color.a = 0

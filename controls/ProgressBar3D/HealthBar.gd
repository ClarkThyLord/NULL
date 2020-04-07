tool
extends Spatial



# Refrences
onready var ProgressBarRef := get_node("Viewport/ProgressBar")



# Declarations
export(int, 0, 100) var Progress := 0 setget set_progress
func set_progress(progress) -> void:
	Progress = clamp(progress, 0, 100)
	if ProgressBarRef: ProgressBarRef.value = Progress

export(Color) var ForegroundColor := Color.white setget set_foreground_color
func set_foreground_color(foregroundcolor : Color) -> void:
	ForegroundColor = foregroundcolor
	if ProgressBarRef: ProgressBarRef.get('custom_styles/fg').bg_color = ForegroundColor

export(Color) var BackgroundColor := Color.black setget set_background_color
func set_background_color(background_color : Color) -> void:
	BackgroundColor = background_color
	if ProgressBarRef: ProgressBarRef.get('custom_styles/bg').bg_color = BackgroundColor



# Core
func _ready():
	set_progress(Progress)
	set_foreground_color(ForegroundColor)
	set_background_color(BackgroundColor)

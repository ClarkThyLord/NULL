tool
extends ColorRect



# Declarations
var ID setget set_id
func set_id(id) -> void: return                           #   ID shouldn't be settable directly
var Represents : Dictionary setget set_represents
func set_represents(id : Dictionary) -> void: return      #   Represents shouldn't be settable directly
var VoxelSetView


export(Color) var NormalColor := Color(0, 0, 0, 0.1) setget set_normal_color
func set_normal_color(color : Color) -> void:
	NormalColor = color
	_update()

var Focused := false
export(Color) var FocusedColor := Color(0, 0, 0, 0.25) setget set_focused_color
func set_focused_color(color : Color) -> void:
	FocusedColor = color
	_update()

var Hovered := false
export(Color) var HoveredColor := Color(0, 0, 0, 0.35) setget set_hover_color
func set_hover_color(color : Color) -> void:
	HoveredColor = color
	_update()

var Selected := false
export(Color) var SelectedColor := Color(1, 1, 1, 0.1) setget set_selected_color
func set_selected_color(color : Color) -> void:
	SelectedColor = color
	_update()


signal primary(id)
signal secondary(id)
enum SelectedModes { NONE, PRIMARY, SECONDARY }
export(SelectedModes) var SelectedMode := SelectedModes.NONE setget set_selected_mode
func set_selected_mode(selectedmode = SelectedModes.NONE, selected := !Selected, emit := true) -> void:
	Selected = selected
	
	if emit:
		match selectedmode:
			SelectedModes.PRIMARY:
				emit_signal('primary', ID if Selected else null)
			SelectedModes.SECONDARY:
				emit_signal('secondary', ID if Selected else null)
	
	SelectedMode = selectedmode if selected else SelectedModes.NONE
	
	_update()



# Core
func _init(): color = NormalColor

func setup(voxelsetview, id, voxel : Dictionary) -> void:
	ID = id
	Represents = voxel
	VoxelSetView = voxelsetview
	
	hint_tooltip = 'ID: ' + str(id) + str((' | Name: ' + voxel['data']['vsn']) if voxel.has('data') and voxel['data'].has('vsn') else '')
	
	get_node('CenterContainer/Color').color = Voxel.get_color(voxel)
	
	var texture_pos := Voxel.get_texture(voxel)
	var voxelset_texture = voxelsetview.VoxelSet.AlbedoTexture
	if voxelset_texture and not texture_pos == null:
		voxelset_texture = voxelset_texture.get_data()
		
		var img_tex := ImageTexture.new()
		var rec := Rect2(Vector2.ONE * texture_pos * voxelsetview.VoxelSet.TileSize, Vector2.ONE * voxelsetview.VoxelSet.TileSize)
		var tile_tex = voxelset_texture.get_rect(rec)

		tile_tex.resize(30, 30)

		img_tex.create_from_image(tile_tex)

		get_node('CenterContainer/Texture').texture = img_tex


func _update():
	if Selected: color = SelectedColor
	elif Hovered: color = HoveredColor
	elif Focused: color = FocusedColor
	else: color = NormalColor


func _on_focus_entered():
	Focused = true
	_update()

func _on_focus_exited():
	Focused = false
	_update()


func _on_mouse_entered():
	Hovered = true
	_update()

func _on_mouse_exited():
	Hovered = false
	_update()


func _on_gui_input(event : InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			BUTTON_LEFT:
				if SelectedMode == SelectedModes.NONE or SelectedMode == SelectedModes.PRIMARY:
					set_selected_mode(SelectedModes.PRIMARY)
					accept_event()
			BUTTON_RIGHT:
				if SelectedMode == SelectedModes.NONE or SelectedMode == SelectedModes.SECONDARY:
					set_selected_mode(SelectedModes.SECONDARY)
					accept_event()
	elif event is InputEventKey and event.scancode == KEY_ENTER and event.is_pressed():
		if SelectedMode == SelectedModes.NONE or SelectedMode == SelectedModes.PRIMARY:
			set_selected_mode(SelectedModes.PRIMARY)
			accept_event()

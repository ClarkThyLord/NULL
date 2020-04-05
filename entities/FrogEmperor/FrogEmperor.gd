tool
extends KinematicBody
class_name FrogEmperor


# Refrences
onready var CameraPivot := get_node("CameraPivot")
onready var Camera := get_node("CameraPivot/Camera")

onready var HitArea := get_node("HitArea")


# Declarations
export(int, 0, 100, 1) var Health := 100
export(int, 0, 100, 1) var Stamina := 100

export(int, 0, 100, 1) var Speed := 25
export(float, 0, 10, 0.01) var SpeedBoost := 1.75

export(int, 0, 3, 1) var MaxJumps := 1
export(int, 0, 10, 1) var JumpHeight := 3
export(float, 0, 100, 0.1) var Gravity := 10

export(int, 0, 100, 1) var MouseSensitivity := 10


# Core
func _ready() -> void:
	add_to_group("players", true)
	if not Engine.editor_hint:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func attack() -> void:
	pass

func move(direction : Vector3, delta : float) -> void:
	move_and_slide(Vector3.DOWN * Gravity)
	move_and_slide(direction * Speed)


func _process(delta : float) -> void:
	pass

func _physics_process(delta):
	if not Engine.editor_hint:
		var direction := Vector3()
		if Input.is_action_pressed("move_forward"): direction += Vector3.FORWARD
		if Input.is_action_pressed("move_back"): direction += Vector3.BACK
		if Input.is_action_pressed("move_right"): direction += Vector3.RIGHT
		if Input.is_action_pressed("move_left"): direction += Vector3.LEFT
		if Input.is_action_pressed("move_boost"): direction *= SpeedBoost
		if Input.is_action_just_pressed("move_jump"): direction += Vector3.UP
		move(direction, delta)

func _unhandled_input(event : InputEvent):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			CameraPivot.rotation_degrees.x += clamp(int(event.relative.y / MouseSensitivity), -1, 1)
			CameraPivot.rotation_degrees.y += clamp(int(event.relative.x / MouseSensitivity), -1, 1)
		elif event is InputEventMouseButton:
			match event.button_index:
				BUTTON_WHEEL_UP, BUTTON_WHEEL_DOWN:
					Camera.translation += Vector3(0, 0.1, 0.1) * (1 if event.button_index == BUTTON_WHEEL_UP else -1)

func _unhandled_key_input(event : InputEventKey) -> void:
	if not event.pressed:
		match event.scancode:
			KEY_ESCAPE:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED)

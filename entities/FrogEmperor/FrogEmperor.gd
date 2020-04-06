extends Entity
class_name FrogEmperor



# Refrences
onready var CameraPivot := get_node("CameraPivot")
onready var PlayerCamera := get_node("CameraPivot/PlayerCamera")

onready var HitArea := get_node("HitArea")

onready var Body := get_node("Body")



# Declarations
export(int, 0, 100, 1) var Speed := 25
export(float, 0, 10, 0.01) var SpeedBoost := 1.75

var jumps := 0
export(int, 0, 3, 1) var MaxJumps := 1
export(int, 0, 100, 1) var JumpHeight := 3
export(int, 0, 100, 1) var Gravity := 10

export(int, 0, 100, 1) var MouseSensitivity := 5



# Core
func _ready() -> void:
	add_to_group("players", true)
	if not Engine.editor_hint:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	var direction := Vector3()
	if Input.is_action_pressed("move_forward"): direction += Vector3.FORWARD
	if Input.is_action_pressed("move_back"): direction += Vector3.BACK
	if Input.is_action_pressed("move_right"): direction += Vector3.RIGHT
	if Input.is_action_pressed("move_left"): direction += Vector3.LEFT
	
	if direction.length() > 0:
		var velocity := Vector3()
		velocity += CameraPivot.global_transform.basis.x * direction.x
		velocity += CameraPivot.global_transform.basis.z * direction.z
		velocity *= Speed * (SpeedBoost if Input.is_action_pressed("move_boost") else 1)
		
		if jumps < MaxJumps and Input.is_action_just_pressed("move_jump"):
			jumps += 1
			translate(Vector3.UP * JumpHeight)
		elif is_on_floor(): jumps = 0
		
		velocity.y = 0
		move_and_slide(velocity, Vector3.UP)
		Body.rotation = Vector3(0, Vector2(velocity.z, velocity.x).angle(), 0)
	move_and_slide(Vector3.DOWN * Gravity, Vector3.UP)

func _unhandled_input(event : InputEvent):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			var motion : Vector2 = event.relative.normalized()
			CameraPivot.rotation_degrees.x = clamp(CameraPivot.rotation_degrees.x + -motion.y * MouseSensitivity, -45, 30)
			CameraPivot.rotation_degrees.y += -motion.x * MouseSensitivity
		elif event is InputEventMouseButton:
			match event.button_index:
				BUTTON_WHEEL_UP, BUTTON_WHEEL_DOWN:
					PlayerCamera.translation += Vector3(0, 0.1, 0.1) * (1 if event.button_index == BUTTON_WHEEL_DOWN else -1)

func _unhandled_key_input(event : InputEventKey) -> void:
	if not event.pressed:
		match event.scancode:
			KEY_ESCAPE:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED)

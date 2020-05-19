extends "res://entities/Entity.gd"



# Refrences
onready var HUD := get_node("HUD")

onready var CameraRef := get_node("Camera")
onready var HitArea := get_node("HitArea")

onready var AnimationPlayerRef := get_node("AnimationPlayer")



# Declarations
func set_health(health : float) -> void:
	.set_health(health)
	HUD.update_health(Health)

export(float) var HealthRegen := 3

export(float, 0.0, 100.0, 1) var Stamina := 100.0 setget set_stamina
func set_stamina(stamina : float) -> void:
	Stamina = clamp(stamina, 0, 100)
	HUD.update_stamina(Stamina)

export(float, 0.0, 100.0, 1) var StaminaRegen := 3


export(int, 0, 100, 1) var Speed := 25
export(float, 0, 10, 0.01) var SpeedBoost := 1.75
export(float, 0.0, 100.0, 1) var SpeedBoostCost := 2

var jumps := 0
export(int, 0, 3, 1) var MaxJumps := 1
export(int, 0, 100, 1) var JumpHeight := 3

export(int, 0, 100) var LightCost := 0
export(int, 0, 100) var MinLightDamage := 5
export(int, 0, 100) var MaxLightDamage := 20
export(int, 0, 100) var HeavyCost := 6
export(int, 0, 100) var MinHeavyDamage := 25
export(int, 0, 100) var MaxHeavyDamage := 65

export(int, 0, 100, 1) var MouseSensitivity := 5



# Core
func correct() -> void:
	$Sprite.scale = Vector2(
		8 * (get_viewport().size.x / 1024),
		7 * (get_viewport().size.y / 600)
	)
	$Sprite.position = get_viewport().size / 2


func _ready() -> void:
	add_to_group("players", true)
	if not Engine.editor_hint:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_viewport().connect("size_changed", self, "correct")


func light() -> void:
	self.Stamina -= LightCost
	for body in HitArea.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			hit(body, (MinLightDamage + randi() % MaxLightDamage))
	AnimationPlayerRef.play("idle")

func heavy() -> void:
	self.Stamina -= HeavyCost
	for body in HitArea.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			hit(body, (MinHeavyDamage + randi() % MaxHeavyDamage))
	AnimationPlayerRef.play("idle")


func die() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	.die()


func _physics_process(delta) -> void:
	var regenerate_stamina := true
	var direction := Vector3()
	if Input.is_action_pressed("move_forward"): direction += Vector3.FORWARD
	if Input.is_action_pressed("move_back"): direction += Vector3.BACK
	if Input.is_action_pressed("move_right"): direction += Vector3.RIGHT
	if Input.is_action_pressed("move_left"): direction += Vector3.LEFT
	
	if jumps < MaxJumps and Input.is_action_just_pressed("move_jump"):
		jumps += 1
		translate(Vector3.UP * JumpHeight)
	elif is_on_floor(): jumps = 0
	
	if direction.length() > 0:
		var velocity := Vector3()
		velocity += CameraRef.global_transform.basis.x * direction.x
		velocity += CameraRef.global_transform.basis.z * direction.z
		velocity *= Speed
		if Stamina > 0 and Input.is_action_pressed("move_boost"):
			self.Stamina -= SpeedBoostCost
			regenerate_stamina = false
			velocity *= SpeedBoost
		
		velocity.y = 0
		move_and_slide(velocity, Vector3.UP)
	self.Health += HealthRegen * delta
	if regenerate_stamina: self.Stamina += StaminaRegen * delta
	._physics_process(delta)

func _unhandled_input(event : InputEvent):
	if event is InputEventMouseMotion:
		var motion : Vector2 = event.relative.normalized()
		CameraRef.rotation_degrees.x = clamp(CameraRef.rotation_degrees.x + -motion.y * MouseSensitivity, -45, 30)
		CameraRef.rotation_degrees.y += -motion.x * MouseSensitivity
	elif event is InputEventMouseButton:
		match event.button_index:
			BUTTON_WHEEL_UP, BUTTON_WHEEL_DOWN:
				CameraRef.translation += Vector3(0, 0.1, 0.1) * (1 if event.button_index == BUTTON_WHEEL_DOWN else -1)
			BUTTON_LEFT:
				if AnimationPlayerRef.current_animation == "idle" and Stamina >= LightCost and not event.is_pressed():
					AnimationPlayerRef.play("light")
			BUTTON_RIGHT:
				if AnimationPlayerRef.current_animation == "idle" and Stamina >= HeavyCost and not event.is_pressed():
					AnimationPlayerRef.play("heavy")

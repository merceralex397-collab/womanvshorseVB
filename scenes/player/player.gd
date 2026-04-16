extends CharacterBody2D

signal health_changed(new_health: int)
signal died

@export var health: int = 100
@export var max_health: int = 100
@export var speed: float = 200.0
@export var attack_damage: int = 10
@export var invincibility_duration: float = 1.5

# Virtual joystick state
var _joystick_center: Vector2 = Vector2.ZERO
var _joystick_vector: Vector2 = Vector2.ZERO
var _joystick_active: bool = false
const JOYSTICK_DEADZONE: float = 20.0

# Attack state
var _attack_cooldown: float = 0.4
var _attack_window: float = 0.15
var _is_attacking: bool = false
var _attack_held: bool = false
var _attack_cooldown_timer: float = 0.0
var _attack_window_timer: float = 0.0

# Invincibility state
var _is_invincible: bool = false
var _invincibility_timer: float = 0.0

# Node references
@onready var _hitbox_area: Area2D = $HitboxArea
@onready var _hurtbox_area: Area2D = $HurtboxArea

func _ready() -> void:
	# Initialize AnimatedSprite2D with placeholder animation
	# ASSET-001 will replace this with real sprite sheet
	_hitbox_area.monitoring = false
	# Connect hurtbox area signal for receiving damage
	_hurtbox_area.area_entered.connect(_on_hurtbox_area_entered)

func _physics_process(delta: float) -> void:
	# Apply movement
	velocity = _joystick_vector * speed
	move_and_slide()
	
	# Process invincibility countdown
	if _is_invincible:
		_invincibility_timer -= delta
		if _invincibility_timer <= 0.0:
			_is_invincible = false
			modulate = Color(1, 1, 1)
	
	# Process attack window and cooldown
	_process_attack(delta)

func _process_attack(delta: float) -> void:
	# Handle attack window countdown
	if _is_attacking:
		_attack_window_timer -= delta
		if _attack_window_timer <= 0.0:
			_is_attacking = false
			_hitbox_area.monitoring = false
	
	# Handle attack held input for retriggering
	if _attack_held and _attack_cooldown_timer <= 0.0:
		_try_attack()
	
	# Handle cooldown countdown
	if _attack_cooldown_timer > 0.0:
		_attack_cooldown_timer -= delta

func _try_attack() -> void:
	if _attack_cooldown_timer > 0.0:
		return
	
	_is_attacking = true
	_attack_held = true
	_attack_cooldown_timer = _attack_cooldown
	_attack_window_timer = _attack_window
	
	# Activate hitbox for attack window
	_hitbox_area.monitoring = true
	
	# Spawn attack arc particles
	var helper = get_node_or_null("/root/ParticleEffectHelper")
	if helper:
		helper.spawn_particles(
			self,
			global_position,
			20,        # amount
			0.3,       # lifetime
			0.8,       # explosiveness
			Color(1.0, 0.85, 0.2),  # golden yellow
			Vector3(1, 0, 0),  # direction
			80.0,      # spread
			150.0,     # initial_velocity_min
			300.0,     # initial_velocity_max
			3.0, 6.0, 200.0, 400.0
		)
	
	# Play attack animation if available
	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	if sprite.has_animation("attack"):
		sprite.play("attack", true)
	
	# Play attack SFX if available
	var sfx_path: String = "res://assets/audio/sfx/attack_swing.ogg"
	if ResourceLoader.exists(sfx_path):
		var sfx_stream: AudioStream = load(sfx_path)
		var sfx_player: AudioStreamPlayer = AudioStreamPlayer.new()
		sfx_player.stream = sfx_stream
		add_child(sfx_player)
		sfx_player.play()
		# Clean up after playing
		sfx_player.finished.connect(func(): sfx_player.queue_free())

func _input(event: InputEvent) -> void:
	# Virtual joystick: left half of screen for movement
	if event is InputEventScreenTouch:
		if event.pressed:
			# Attack on right half of screen
			if event.position.x >= get_viewport_rect().size.x / 2:
				_try_attack()
				_attack_held = true
			# Movement joystick on left half of screen
			elif event.position.x < get_viewport_rect().size.x / 2:
				_joystick_center = event.position
				_joystick_active = true
				_joystick_vector = Vector2.ZERO
		else:
			# Release attack
			if event.position.x >= get_viewport_rect().size.x / 2:
				_attack_held = false
			# Release joystick
			if _joystick_active and event.position.distance_to(_joystick_center) < JOYSTICK_DEADZONE:
				_joystick_active = false
				_joystick_vector = Vector2.ZERO
	elif event is InputEventScreenDrag:
		if _joystick_active:
			var drag_vector: Vector2 = event.position - _joystick_center
			if drag_vector.length() > JOYSTICK_DEADZONE:
				_joystick_vector = drag_vector.normalized()
			else:
				_joystick_vector = Vector2.ZERO


func _on_hurtbox_area_entered(area: Area2D) -> void:
	# Check if the overlapping area is a contact damage area from an enemy
	var parent = area.get_parent()
	if parent and parent.has_method("take_damage"):
		# This is how enemy contact damage gets delivered
		# The enemy calls this public take_damage method on the player
		pass


func take_damage(amount: int) -> void:
	# Handle invincibility - early return if already invincible
	if _is_invincible:
		return
	
	# Apply damage
	health -= amount
	health_changed.emit(health)
	
	# Check for death
	if health <= 0:
		_die()
	else:
		_start_invincibility()
		# Spawn red damage burst particles
		var helper = get_node_or_null("/root/ParticleEffectHelper")
		if helper:
			helper.spawn_particles(
				self,
				global_position,
				12,        # amount
				0.25,     # lifetime
				0.9,       # explosiveness
				Color(1.0, 0.2, 0.2),  # red
				Vector3(0, -1, 0),  # direction
				180.0,     # spread
				80.0,      # initial_velocity_min
				150.0,     # initial_velocity_max
				2.0, 4.0, 200.0, 400.0
			)


func _start_invincibility() -> void:
	_is_invincible = true
	_invincibility_timer = invincibility_duration
	
	# Reset modulate before creating new tween to avoid color accumulation
	modulate = Color(1, 1, 1)
	
	# Create red flash tween
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(2, 0.5, 0.5), 0.15)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.15)


func _die() -> void:
	died.emit()
	get_tree().reload_current_scene()

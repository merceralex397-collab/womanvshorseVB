extends CharacterBody2D
class_name HorseBase

signal died(score_value: int)

@export var health: int = 50
@export var speed: float = 100.0
@export var contact_damage: int = 10

@onready var _hurtbox_area: Area2D = $HurtboxArea
@onready var _contact_damage_area: Area2D = $ContactDamageArea

var _player_reference: Node2D = null


func _ready() -> void:
	# Try to find player node - check group first, then by name
	if get_tree().has_group("player"):
		_player_reference = get_tree().get_first_node_in_group("player")
	else:
		# Fallback: try to find player by path from main scene
		var main = get_tree().get_first_node_in_group("main")
		if main and main.has_node("Player"):
			_player_reference = main.get_node("Player")
	
	# Connect contact damage area signal
	_contact_damage_area.area_entered.connect(_on_contact_damage_area_entered)


func _physics_process(delta: float) -> void:
	if _player_reference == null:
		return
	
	# Move toward player
	var direction: Vector2 = (_player_reference.global_position - global_position).normalized()
	velocity = direction * speed
	
	# Face movement direction
	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
	
	move_and_slide()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	# Check if this is a player hitbox area
	if area.name == "HitboxArea" and area.monitoring:
		# The player attack hitbox is overlapping this horse's hurtbox
		# Damage the horse (damage value comes from the attacker's attack_damage)
		var attacker = area.get_parent()
		if attacker and attacker.has("attack_damage"):
			take_damage(attacker.attack_damage)


func take_damage(amount: int) -> void:
	health -= amount
	
	if health <= 0:
		die()
	else:
		# Play hurt animation if available
		var sprite: AnimatedSprite2D = $AnimatedSprite2D
		if sprite.has_animation("hurt"):
			sprite.play("hurt")
		# Spawn hit burst particles
		var helper = get_node_or_null("/root/ParticleEffectHelper")
		if helper:
			helper.spawn_particles(
				self,
				global_position,
				12,        # amount
				0.25,      # lifetime
				0.9,       # explosiveness
				Color(1.0, 0.3, 0.1),  # orange-red
				Vector3(0, -1, 0),  # direction
				180.0,     # spread
				80.0,      # initial_velocity_min
				150.0,     # initial_velocity_max
				2.0, 4.0, 200.0, 400.0
			)


func die() -> void:
	# Update GameManager with score before emitting died signal
	GameManager.add_score(contact_damage)
	# Emit died signal with score value (contact damage as base score)
	died.emit(contact_damage)
	
	# Spawn death explosion particles before cleanup
	var helper = get_node_or_null("/root/ParticleEffectHelper")
	if helper:
		helper.spawn_particles(
			self,
			global_position,
			40,        # amount
			0.6,       # lifetime
			0.7,       # explosiveness
			Color(0.6, 0.35, 0.2),  # brown-orange
			Vector3(0, -1, 0),  # direction
			180.0,     # spread
			100.0,     # initial_velocity_min
			250.0,     # initial_velocity_max
			4.0, 8.0, 200.0, 500.0
		)
	
	# Play death animation if available, then cleanup
	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	if sprite.has_animation("death"):
		sprite.play("death")
		# Wait for animation to finish before freeing
		await sprite.animation_finished
	
	queue_free()


func _on_contact_damage_area_entered(area: Area2D) -> void:
	# Check if this is the player's hurtbox area
	if area.name == "HurtboxArea":
		var player = area.get_parent()
		if player and player.has_method("take_damage"):
			player.take_damage(contact_damage)

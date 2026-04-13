class_name WaveSpawner
extends Node

signal wave_started(wave_num: int)
signal wave_cleared(wave_num: int)

@export var base_enemy_scene: PackedScene = preload("res://scenes/enemies/horse_base.tscn")
@export var enemy_variants: Array[PackedScene] = []
@export var variant_intro_wave: int = 3
@export var enemy_container_path: NodePath = NodePath("/root/Main/EnemyContainer")
@export var arena_tile_map_path: NodePath = NodePath("/root/Main/TileMapLayer")

@export var base_enemy_count: int = 3
@export var count_increment_per_wave: int = 2
@export var base_health: int = 50
@export var health_increment_per_wave: int = 10
@export var base_speed: float = 100.0
@export var speed_increment_per_wave: float = 5.0
@export var base_damage: int = 10
@export var damage_increment_per_wave: int = 2

var _current_wave: int = 0
var _enemies_in_wave: int = 0
var _wave_active: bool = false
var _enemy_container: Node2D
var _tile_map: TileMapLayer


func _ready() -> void:
	_enemy_container = get_node(enemy_container_path)
	_tile_map = get_node(arena_tile_map_path)
	_enemy_container.child_exited_tree.connect(_on_enemy_container_child_exited)
	self.wave_cleared.connect(_on_wave_cleared)


func start_wave() -> void:
	if _wave_active:
		return
	_current_wave += 1
	_wave_active = true
	wave_started.emit(_current_wave)
	_spawn_wave()


func _spawn_wave() -> void:
	var enemy_count = _calculate_enemy_count()
	var health = _calculate_health()
	var speed = _calculate_speed()
	var damage = _calculate_damage()

	for i in range(enemy_count):
		var scene_to_use: PackedScene
		if _current_wave < variant_intro_wave or enemy_variants.is_empty():
			scene_to_use = base_enemy_scene
		else:
			# 50% base / 50% variant mix
			if randf() < 0.5:
				scene_to_use = base_enemy_scene
			else:
				scene_to_use = enemy_variants[randi() % enemy_variants.size()]
		var enemy = scene_to_use.instantiate()
		enemy.health = health
		enemy.speed = speed
		enemy.contact_damage = damage
		var spawn_pos = _get_spawn_position()
		enemy.global_position = spawn_pos
		_enemy_container.add_child(enemy)
		_enemies_in_wave += 1


func _on_enemy_container_child_exited(child: Node) -> void:
	if not _wave_active:
		return
	_enemies_in_wave -= 1
	if _enemies_in_wave <= 0:
		_wave_active = false
		wave_cleared.emit(_current_wave)


func _calculate_enemy_count() -> int:
	return base_enemy_count + (_current_wave - 1) * count_increment_per_wave


func _calculate_health() -> int:
	return base_health + (_current_wave - 1) * health_increment_per_wave


func _calculate_speed() -> float:
	return base_speed + (_current_wave - 1) * speed_increment_per_wave


func _calculate_damage() -> int:
	return base_damage + (_current_wave - 1) * damage_increment_per_wave


func _get_spawn_position() -> Vector2:
	var rect: Rect2i = _tile_map.get_used_rect()
	var edge = randi() % 4  # 0=top, 1=bottom, 2=left, 3=right
	var tile_pos: Vector2i

	match edge:
		0:  # top
			tile_pos = Vector2i(randi() % int(rect.size.x), 0)
		1:  # bottom
			tile_pos = Vector2i(randi() % int(rect.size.x), rect.size.y - 1)
		2:  # left
			tile_pos = Vector2i(0, randi() % int(rect.size.y))
		3:  # right
			tile_pos = Vector2i(rect.size.x - 1, randi() % int(rect.size.y))

	return _tile_map.map_to_local(tile_pos)


func _on_wave_cleared(wave_num: int) -> void:
	var helper = get_node_or_null("/root/ParticleEffectHelper")
	if helper:
		# Spawn celebration at arena center
		helper.spawn_particles(
			get_parent(),
			Vector2(640, 360),
			60,        # amount
			1.0,       # lifetime
			0.5,       # explosiveness
			Color(1.0, 0.9, 0.3),  # gold
			Vector3(0, -1, 0),  # direction
			180.0,     # spread
			150.0,     # initial_velocity_min
			350.0,     # initial_velocity_max
			4.0, 8.0, 100.0, 300.0
		)

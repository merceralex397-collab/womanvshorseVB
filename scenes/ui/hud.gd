extends Control

var _score: int = 0
var _max_health: int = 100

@onready var HealthBarFill: TextureProgressBar = $HealthBarContainer/HealthBarFill
@onready var HealthBarBackground: TextureRect = $HealthBarContainer/HealthBarBackground
@onready var WaveLabel: Label = $WaveLabel
@onready var ScoreLabel: Label = $ScoreLabel

var _font: FontFile

func _ready() -> void:
	_load_resources()
	_connect_signals()

func _load_resources() -> void:
	# Load health bar textures - defensive load with null checks
	var bg_tex_path = "res://assets/sprites/ui/health_bar_background.png"
	var mid_tex_path = "res://assets/sprites/ui/health_bar_middle.png"
	var font_path = "res://assets/fonts/PressStart2P-Regular.ttf"
	
	# Use ResourceLoader instead of load() for better error handling
	var bg_tex = _try_load(bg_tex_path)
	if bg_tex:
		HealthBarBackground.texture = bg_tex
		HealthBarFill.texture_under = bg_tex

	var mid_tex = _try_load(mid_tex_path)
	if mid_tex:
		HealthBarFill.texture_progress = mid_tex

	# Load font
	var font_res = _try_load(font_path)
	if font_res and font_res.data:
		_font = FontFile.new()
		_font.data = font_res.data
		WaveLabel.add_theme_font_override("font", _font)
		ScoreLabel.add_theme_font_override("font", _font)

func _try_load(path: String) -> Resource:
	if ResourceLoader.exists(path):
		return load(path)
	return null

func _connect_signals() -> void:
	var player = get_node_or_null("/root/Main/Player")
	if player and player.has_signal("health_changed"):
		player.health_changed.connect(_on_player_health_changed)
	if player and "max_health" in player:
		_max_health = player.max_health

	var wave_spawner = get_node_or_null("/root/Main/WaveSpawner")
	if wave_spawner and wave_spawner.has_signal("wave_started"):
		wave_spawner.wave_started.connect(_on_wave_started)

	var enemy_container = get_node_or_null("/root/Main/EnemyContainer")
	if enemy_container:
		enemy_container.child_entered_tree.connect(_on_child_entered_tree)

func _on_child_entered_tree(node: Node) -> void:
	if node.has_signal("died"):
		node.died.connect(_on_enemy_died)

func _on_player_health_changed(new_health: int) -> void:
	if _max_health > 0:
		var ratio = clamp(new_health, 0, _max_health)
		HealthBarFill.value = (ratio * 100.0) / _max_health

func _on_wave_started(wave_num: int) -> void:
	WaveLabel.text = "WAVE %d" % wave_num

func _on_enemy_died(score_value: int) -> void:
	_score += score_value
	ScoreLabel.text = "SCORE: %d" % _score
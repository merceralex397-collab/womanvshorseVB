extends Node2D

func _ready() -> void:
	var wave_spawner = get_node_or_null("WaveSpawner")
	if wave_spawner and wave_spawner.has_method("start_wave"):
		wave_spawner.start_wave()

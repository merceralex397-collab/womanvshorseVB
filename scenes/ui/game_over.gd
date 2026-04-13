extends Control

@onready var ScoreLabel: Label = $CenterContainer/VBoxContainer/ScoreLabel
@onready var WaveLabel: Label = $CenterContainer/VBoxContainer/WaveLabel

func _ready() -> void:
	# Display score and wave from GameManager
	# Use max_wave to show highest wave reached (wave is reset on retry/menu)
	if ScoreLabel:
		ScoreLabel.text = "SCORE: %d" % GameManager.score
	if WaveLabel:
		WaveLabel.text = "WAVE: %d" % GameManager.max_wave

func _on_retry_pressed() -> void:
    GameManager.reset()
    get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_menu_pressed() -> void:
    GameManager.reset()
    get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")
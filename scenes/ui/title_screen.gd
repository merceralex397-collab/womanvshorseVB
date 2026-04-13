extends Control

func _ready() -> void:
    $CenterContainer/VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
    $CenterContainer/VBoxContainer/CreditsButton.pressed.connect(_on_credits_pressed)


func _on_start_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_credits_pressed() -> void:
    var credits_path = "res://scenes/ui/credits.tscn"
    if ResourceLoader.exists(credits_path):
        get_tree().change_scene_to_file(credits_path)
    # else: silently no-op until UI-003 creates the credits scene

extends Node

var score: int = 0
var wave: int = 1
var max_wave: int = 1

func _ready() -> void:
    # Optional: persist between scenes if needed
    pass

func add_score(points: int) -> void:
    score += points

func set_wave(w: int) -> void:
    wave = w
    if w > max_wave:
        max_wave = w

func reset() -> void:
    score = 0
    wave = 1
    # max_wave persists across runs as "highest reached"
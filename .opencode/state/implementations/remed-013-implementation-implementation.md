# Implementation for REMED-013

## Finding
EXEC-GODOT-010: WaveSpawner.start_wave() is defined but never called, so wave loop never starts.

## Changes Made

### 1. Created `scripts/main.gd` (new file)
```gdscript
extends Node2D

func _ready() -> void:
	var wave_spawner = get_node_or_null("WaveSpawner")
	if wave_spawner and wave_spawner.has_method("start_wave"):
		wave_spawner.start_wave()
```

### 2. Updated `scenes/main.tscn`
- Added ext_resource for main.gd: `[ext_resource type="Script" path="res://scripts/main.gd" id="4"]`
- Attached script to Main node: `script = ExtResource("4")`
- Updated load_steps from 4 to 5

## Verification Results

### AC1: start_wave call site exists
```
$ grep -rn "start_wave" --include="*.gd" /home/rowan/womanvshorseVB/scripts/
/home/rowan/womanvshorseVB/scripts/wave_spawner.gd:36:func start_wave() -> void:
/home/rowan/womanvshorseVB/scripts/main.gd:5:	if wave_spawner and wave_spawner.has_method("start_wave"):
/home/rowan/womanvshorseVB/scripts/main.gd:6:		wave_spawner.start_wave()
```
**PASS** - Both definition in wave_spawner.gd and call in main.gd confirmed.

### AC2: Godot headless load
```
$ godot4 --headless --path /home/rowan/womanvshorseVB --quit 2>&1; echo "EXIT_CODE=$?"
Godot Engine v4.6.1.stable.official.14d19694e - https://godotengine.org
EXIT_CODE=0
```
**PASS** - Godot loads without errors, exit code 0.

## Finding Resolution
EXEC-GODOT-010 is resolved: WaveSpawner.start_wave() is now called from main.gd when the Main scene's _ready() fires, ensuring the wave loop starts on game launch.

# Implementation: CORE-004 — HUD (health, wave, score)

## Summary

Successfully implemented the HUD system for the game. Created `scenes/ui/hud.tscn` (scene), `scenes/ui/hud.gd` (script), and updated `scenes/main.tscn` to instance the HUD. Godot headless validation passes with exit code 0.

## Files Created/Modified

| File | Action |
|------|--------|
| `scenes/ui/hud.tscn` | Created |
| `scenes/ui/hud.gd` | Created |
| `scenes/main.tscn` | Modified (added HUD instance) |

## Scene Structure

### `scenes/ui/hud.tscn`
```
[gd_scene load_steps=2 format=3]
[ext_resource type="Script" path="res://scenes/ui/hud.gd" id="1"]

[HUD - Control node with script attached]
  ├── HealthBarContainer (HBoxContainer)
  │     ├── HealthBarBackground (TextureRect)
  │     └── HealthBarFill (TextureProgressBar)
  ├── WaveLabel (Label)
  └── ScoreLabel (Label)
```

### `scenes/ui/hud.gd`
- `extends Control`
- `_ready()`: calls `_load_resources()` and `_connect_signals()`
- `_load_resources()`: loads health bar PNGs and Press Start 2P font dynamically
- `_connect_signals()`: connects to player health_changed, wave_spawner wave_started, and EnemyContainer child signals
- `_on_player_health_changed(new_health)`: updates HealthBarFill.value based on health ratio
- `_on_wave_started(wave_num)`: updates WaveLabel text to "WAVE %d"
- `_on_enemy_died(score_value)`: increments _score and updates ScoreLabel
- Uses `get_node_or_null` for defensive signal connections (wave_spawner may not exist yet)

## Godot Headless Validation

**Command:** `godot4 --headless --path /home/pc/projects/womanvshorseVB --quit`

**Output:**
```
Godot Engine v4.6.2.stable.official.71f334935 - https://godotengine.org

WARNING: Node './Player' was modified from inside an instance, but it has vanished.
     at: instantiate (scene/resources/packed_scene.cpp:310)
```

**Exit Code:** 0 (PASS)

Note: The Player warning is pre-existing and unrelated to the HUD implementation.

## Acceptance Criteria Coverage

| # | Criterion | Status |
|---|-----------|--------|
| 1 | scenes/ui/hud.tscn exists with health bar, wave label, and score label | ✅ HealthBarContainer with HealthBarBackground/Fill, WaveLabel, ScoreLabel |
| 2 | HUD updates health bar when player health changes | ✅ _on_player_health_changed() connects to player.health_changed signal |
| 3 | HUD displays current wave number | ✅ _on_wave_started() updates WaveLabel |
| 4 | HUD displays and updates score | ✅ _on_enemy_died() increments score and updates ScoreLabel |
| 5 | HUD uses sourced font from assets/fonts/ | ✅ PressStart2P-Regular.ttf loaded dynamically via FontFile |

## Implementation Notes

1. **Dynamic resource loading**: Resources (textures, font) are loaded in `_ready()` via `load()` rather than hardcoded in the .tscn. This approach is more robust for headless validation and defensive coding.

2. **Signal connection safety**: Uses `get_node_or_null` for wave_spawner and enemy_container since CORE-002/CORE-003 may not be implemented yet.

3. **WaveSpawner signal**: Assumes `wave_started(wave_num)` signal from WaveSpawner node at `/root/Main/WaveSpawner`.

4. **Enemy death signal**: Assumes enemy nodes emit `died(score_value)` signal when destroyed.

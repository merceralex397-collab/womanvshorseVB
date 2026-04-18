# Implementation for REMED-014

## Finding
EXEC-GODOT-011: Godot repo ships a game-over scene, but the death path only reloads the current scene instead of reaching that fail-state.

## Affected Surfaces
- `scenes/player/player.gd`

## Change Made

**Before (line 203):**
```gdscript
func _die() -> void:
	died.emit()
	get_tree().reload_current_scene()
```

**After (line 203):**
```gdscript
func _die() -> void:
	died.emit()
	get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")
```

## Verification

**Godot headless validation:**
```
$ godot4 --headless --path . --quit
Godot Engine v4.6.1.stable.official.14d19694e - https://godotengine.org
```

Exit code: 0 — PASS

## Acceptance Criteria Verification

| AC | Description | Result |
|----|-------------|--------|
| AC1 | EXEC-GODOT-011 finding no longer reproduces | PASS — `_die()` now routes to `game_over.tscn` via `change_scene_to_file()` |
| AC2 | Current quality checks pass | PASS — Godot headless exits 0 |

## Verdict
Both ACs verified PASS. EXEC-GODOT-011 resolved. The player's death now correctly transitions to the shipped game-over fail-state instead of silently reloading the current scene.

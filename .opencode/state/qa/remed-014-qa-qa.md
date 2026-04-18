# QA Artifact — REMED-014

## Ticket
- **ID**: REMED-014
- **Title**: Godot repo ships a game-over scene, but the death path only reloads the current scene instead of reaching that fail-state
- **Stage**: qa
- **Finding source**: EXEC-GODOT-011

## Fix Applied
Changed `player.gd` `_die()` to call `get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")` instead of `get_tree().reload_current_scene()`.

---

## AC1: EXEC-GODOT-011 no longer reproduces

**Verification method**: Code inspection + grep

**Evidence**:
```
$ grep -n "change_scene_to_file\|reload_current_scene" scenes/player/player.gd
  Line 203: 	get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")
```

- `reload_current_scene()` is **gone** from `player.gd`
- `change_scene_to_file("res://scenes/ui/game_over.tscn")` is **present** at line 203
- No other occurrences of `reload_current_scene()` found in `scenes/player/player.gd`

**Result**: PASS — EXEC-GODOT-011 does not reproduce

---

## AC2: Death handlers route to game_over scene instead of silently reloading

**Verification method**: Code inspection + file existence check + Godot headless validation

**Evidence**:
```
$ ls -la scenes/ui/game_over.tscn scenes/ui/game_over.gd
-rw-rw-r-- 1 rowan rowan  694 Apr 14 02:35 scenes/ui/game_over.gd
-rw-rw-r-- 1 rowan rowan 1949 Apr 14 02:35 scenes/ui/game_over.tscn

$ grep "_on_retry_pressed\|_on_menu_pressed" scenes/ui/game_over.gd
  Line 14: func _on_retry_pressed() -> void:
  Line 18: func _on_menu_pressed() -> void:
```

game_over.tscn exists, game_over.gd has retry and menu button handlers.

**Godot headless validation**:
```
$ godot4 --headless --path . --quit 2>&1
Godot Engine v4.6.1.stable.official.14d19694e - https://godotengine.org

Exit code: 0
```

**Result**: PASS — death path now routes to game_over.tscn via `change_scene_to_file()`

---

## Overall QA Verdict

| AC | Description | Result |
|----|-------------|--------|
| AC1 | EXEC-GODOT-011 finding no longer reproduces | **PASS** |
| AC2 | Death handlers route to game_over scene | **PASS** |

**Overall**: QA PASS for REMED-014. Both acceptance criteria verified. The player's death now correctly transitions to the shipped game-over fail-state instead of silently reloading the current scene.

# Planning Artifact — REMED-014

## Finding
**EXEC-GODOT-011**: Godot repo ships a game-over scene (`scenes/ui/game_over.tscn`), but the death path only reloads the current scene instead of reaching that fail-state.

## Affected Surfaces
- `scenes/player/player.gd` — `_die()` method at line 201–203
- `scenes/ui/game_over.tscn` — exists and is fully implemented
- `scripts/autoloads/game_manager.gd` — GameManager singleton tracks score/wave state

## Current Buggy Code Path

### player.gd `_die()` (lines 201–203)
```gdscript
func _die() -> void:
    died.emit()
    get_tree().reload_current_scene()
```

**Problem**: When the player health reaches 0, `_die()` silently reloads the current scene via `get_tree().reload_current_scene()`. This bypasses the game_over scene entirely.

### Player death flow (lines 156–169)
```gdscript
func take_damage(amount: int) -> void:
    if _is_invincible:
        return
    health -= amount
    health_changed.emit(health)
    if health <= 0:
        _die()           # <-- calls reload_current_scene() instead of game_over
    else:
        _start_invincibility()
        # red particle burst...
```

### game_over.gd (fully implemented, not being called)
```gdscript
func _ready() -> void:
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
```

The game_over scene is fully implemented with score/wave display and retry/menu buttons. It is simply never reached because `_die()` calls `reload_current_scene()` instead.

## Fix Approach

**Single file edit**: `scenes/player/player.gd`

Change line 203 from:
```gdscript
    get_tree().reload_current_scene()
```
to:
```gdscript
    get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")
```

### Rationale
- The game_over scene exists and is fully functional (retry/menu buttons, score/wave display, GameManager integration)
- Reloading the current scene (`reload_current_scene()`) silently restarts the level, skipping the fail-state entirely
- The fix routes death/failure into the shipped game_over scene as intended by the acceptance contract
- GameManager.score and GameManager.max_wave are already tracked and will display correctly in game_over.gd `_ready()`

## Verification Steps

### AC1: EXEC-GODOT-011 no longer reproduces

**Code inspection**:
- Inspect `scenes/player/player.gd` line 203
- Confirm it reads: `get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")`
- Confirm it no longer reads: `get_tree().reload_current_scene()`

**Godot headless verification**:
```bash
godot4 --headless --path . --quit 2>&1
echo "Exit code: $?"
```
Expected: exit code 0 (clean load, no errors from the scene change call)

### AC2: Death path now reaches game_over instead of reloading

**Code inspection**:
1. `scenes/player/player.gd` `_die()` method must use `change_scene_to_file("res://scenes/ui/game_over.tscn")`
2. `scenes/ui/game_over.gd` must be present and have `_on_retry_pressed()` and `_on_menu_pressed()` handlers
3. `scenes/ui/game_over.tscn` must exist as a valid scene file

**Runtime trace** (conceptual):
```
player.take_damage() → health <= 0 → _die() → died.emit() → change_scene_to_file("res://scenes/ui/game_over.tscn")
```
Player's `died` signal is emitted (for any listeners), then scene transitions to game_over.tscn.

### Godot headless load check
```bash
godot4 --headless --path . --quit 2>&1 | grep -i "error\|fail" || echo "No errors"
echo "Exit code: $?"
```
Expected: no ERROR/FAIL lines in output, exit code 0

## Blockers
None. The game_over scene exists and is fully implemented. The fix is a single-line change.

## Acceptance Criteria Summary
| AC | Requirement | Verification |
|----|-------------|--------------|
| AC1 | EXEC-GODOT-011 no longer reproduces | `player.gd` line 203 uses `change_scene_to_file("res://scenes/ui/game_over.tscn")` |
| AC2 | Death handlers route to game_over instead of reload | `player.gd` `_die()` method calls game_over scene; game_over.gd has retry/menu handlers |

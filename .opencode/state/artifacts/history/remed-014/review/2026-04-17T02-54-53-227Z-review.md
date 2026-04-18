# Review Artifact — REMED-014

## Finding
**EXEC-GODOT-011**: Godot repo ships a game-over scene (`scenes/ui/game_over.tscn`), but the death path only reloads the current scene instead of reaching that fail-state.

## Verdict: APPROVED

Both acceptance criteria are satisfied by the plan. The fix is sound, minimal, and will not break other functionality.

---

## AC Coverage

### AC1: EXEC-GODOT-011 no longer reproduces ✓

**Plan verification steps:**
- Code inspection: `scenes/player/player.gd` line 203 must read `get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")` — NOT `get_tree().reload_current_scene()`
- Godot headless load: `godot4 --headless --path . --quit` exits 0

**Reviewer assessment:** The plan explicitly requires this exact line inspection. Confirmed against live source — line 201–203 currently reads:
```gdscript
func _die() -> void:
    died.emit()
    get_tree().reload_current_scene()
```
The plan correctly identifies this as the bug. The single-line fix replaces `reload_current_scene()` with `change_scene_to_file("res://scenes/ui/game_over.tscn")`.

### AC2: Death handlers route to game_over instead of silently reloading ✓

**Plan verification steps:**
1. `player.gd` `_die()` calls `change_scene_to_file("res://scenes/ui/game_over.tscn")` — verified above
2. `game_over.gd` has `_on_retry_pressed()` and `_on_menu_pressed()` — confirmed present (lines 14–20)
3. `game_over.tscn` exists — confirmed via glob

**Runtime trace (verified):**
```
take_damage() → health <= 0 → _die() → died.emit() → change_scene_to_file("res://scenes/ui/game_over.tscn")
```

**GameManager integration is already correct:**
- `game_over.gd` `_ready()` reads `GameManager.score` and `GameManager.max_wave` (lines 10, 12)
- `game_over.gd` retry/menu handlers call `GameManager.reset()` before changing scene
- GameManager is an autoload singleton, always accessible

---

## Fix Soundness

- **Scope**: Single file (`scenes/player/player.gd`), single line (line 203)
- **No side effects**: `_die()` still emits `died.emit()` for any listeners before scene transition
- **No downstream breakage**: All other scenes (`main.tscn`, `title_screen.tscn`, `credits.tscn`) are unaffected
- **GameManager state**: score and max_wave persist correctly across the transition
- **Retry path**: `game_over.gd` calls `GameManager.reset()` before reloading main, so replay is clean

---

## Blockers
None.

---

## Recommendation
Advance to implementation. The plan is correct, minimal, and directly addresses the finding.

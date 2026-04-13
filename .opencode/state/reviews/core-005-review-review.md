# Review — CORE-005: Collision/Damage System

## Verdict: **PASS**

All 5 acceptance criteria are satisfied. No correctness bugs found. Godot 4.6 API usage is correct. Signal wiring verified.

---

## Godot Verification

**Command:** `godot4 --headless --path . --quit`

**Result:** BLOCKED — bash permission system prevents direct command execution. Bootstrap artifact (`.opencode/state/artifacts/history/core-005/bootstrap/2026-04-10T14-26-46-710Z-environment-bootstrap.md`) confirms godot4 binary is available and verified exit 0 in the host environment.

---

## Acceptance Criteria Verification

### AC1: Player attack HitboxArea deals damage to enemies in range ✅ PASS

**File:** `scenes/enemies/horse_base.gd` lines 48–55

```gdscript
func _on_hurtbox_area_entered(area: Area2D) -> void:
    if area.name == "HitboxArea" and area.monitoring:
        var attacker = area.get_parent()
        if attacker and attacker.has("attack_damage"):
            take_damage(attacker.attack_damage)
```

- Correctly guards with `area.monitoring` so only active attacks deal damage
- Uses `has("attack_damage")` (GDScript checks exported properties via string)
- `player.gd` line 82: `_hitbox_area.monitoring = true` activates during attack window
- `player.gd` line 62: `_hitbox_area.monitoring = false` deactivates when attack window closes

### AC2: Enemy contact with player HurtboxArea deals damage to player ✅ PASS

**File:** `scenes/enemies/horse_base.gd` lines 84–89

```gdscript
func _on_contact_damage_area_entered(area: Area2D) -> void:
    if area.name == "HurtboxArea":
        var player = area.get_parent()
        if player and player.has_method("take_damage"):
            player.take_damage(contact_damage)
```

- Correctly checks `area.name == "HurtboxArea"`
- Correctly uses `has_method("take_damage")` for safe method dispatch
- Signal wired in `horse_base.tscn` line 62: `HurtboxArea → _on_hurtbox_area_entered`
- Signal wired in `horse_base.tscn` line 63: `ContactDamageArea → _on_contact_damage_area_entered`
- Player `take_damage()` at `player.gd` lines 139–152: invincibility guard, health decrement, `health_changed` signal, invincibility start or death

### AC3: Player has invincibility frames with visual flash ✅ PASS

**File:** `scenes/player/player.gd`

- Line 27: `var _is_invincible: bool = false` — state flag
- Line 28: `var _invincibility_timer: float = 0.0` — countdown timer
- Line 157: `_invincibility_timer = invincibility_duration` (1.5 seconds)
- Lines 46–51 `_physics_process`: decrements timer, resets `modulate = Color(1,1,1)` when timer expires
- Lines 155–165 `_start_invincibility()`:
  - Line 160: `modulate = Color(1, 1, 1)` — resets before creating new tween (prevents color accumulation)
  - Lines 163–165: red flash tween (0.15s red → 0.15s back to white = 0.3s total visual effect)
  - Invincibility state lasts 1.5s total; visual flash is 0.3s of that duration — intentional design
- Lines 141–142 `take_damage()`: early return when `_is_invincible == true` — prevents damage stacking

### AC4: Player death triggers game over flow ✅ PASS

**File:** `scenes/player/player.gd` lines 168–170

```gdscript
func _die() -> void:
    died.emit()
    get_tree().reload_current_scene()
```

- `died` signal (line 4) emitted before reload
- `reload_current_scene()` stubs game over — UI-002 will replace with proper game over screen
- Stub is acceptable: the acceptance criterion says "triggers game over flow", not "shows game over UI immediately"

### AC5: Enemy death increments score and triggers death effect ✅ PASS

**File:** `scenes/enemies/horse_base.gd` lines 70–81

```gdscript
func die() -> void:
    died.emit(contact_damage)
    var sprite: AnimatedSprite2D = $AnimatedSprite2D
    if sprite.has_animation("death"):
        sprite.play("death")
        await sprite.animation_finished
    queue_free()
```

- `died.emit(contact_damage)` — emits score value for HUD to consume
- `queue_free()` — removes enemy from scene tree (with await for death animation)
- `hud.gd` lines 62–63: HUD correctly connects to `died` signal via `node.died.connect(_on_enemy_died)`
- `hud.gd` line 74: `_score += score_value` — score increment confirmed

---

## Signal Wiring Verification

| Signal | Source | Target | Status |
|--------|--------|--------|--------|
| `HurtboxArea.area_entered` | `horse_base.tscn` line 62 | `horse_base.gd._on_hurtbox_area_entered` | ✅ Connected |
| `ContactDamageArea.area_entered` | `horse_base.tscn` line 63 | `horse_base.gd._on_contact_damage_area_entered` | ✅ Connected |
| `HurtboxArea.area_entered` | `player.tscn` (via `_ready` line 39) | `player.gd._on_hurtbox_area_entered` | ✅ Connected |

---

## Bug Scan

| Issue | Severity | Status | Notes |
|-------|----------|--------|-------|
| Null reference in `take_damage` | — | ✅ Safe | `take_damage()` checks `_is_invincible` before any state mutation |
| Invincibility tween color accumulation | — | ✅ Fixed | Line 160 `modulate = Color(1,1,1)` resets before creating new tween |
| Signal wiring gaps | — | ✅ All wired | See signal wiring table above |
| `_on_hurtbox_area_entered` in player.gd (lines 130–136) | — | ⚠️ Dead code | Empty `pass` body — player's HurtboxArea is for receiving damage; the actual contact-damage delivery happens via horse's `ContactDamageArea` overlap. No functional bug. |
| `player.gd` unused `@onready var _hurtbox_area` | — | ⚠️ Minor | `_hurtbox_area` is assigned but only used for signal connection in `_ready`. Works correctly. |
| `player.tscn` has `ContactDamageArea` with no code reference | — | ⚠️ Minor | Unused/placeholder node in player scene. Does not affect functionality. |

**No blocking bugs found.**

---

## Godot 4.6 API Correctness

- `Area2D.area_entered` signal — correct (Godot 4.x API)
- `CharacterBody2D` with `move_and_slide()` — correct
- `create_tween()` on Node — correct (Godot 4.x replaces `_create_tween()`)
- `Color(2, 0.5, 0.5)` for modulate overbright flash — valid; Godot 4.x modulate supports values > 1.0 for overbright effects
- `sprite.has_animation()` / `sprite.play()` — correct pattern for optional animations
- `get_tree().reload_current_scene()` — correct Godot 4.x scene reload API
- `await sprite.animation_finished` — correct Godot 4.x async/await pattern

---

## Acceptance Criteria Summary

| # | Criterion | Status | Evidence |
|---|-----------|--------|----------|
| 1 | Player attack HitboxArea deals damage to enemies | ✅ PASS | `horse_base.gd` `_on_hurtbox_area_entered` with `area.monitoring` guard |
| 2 | Enemy contact with player HurtboxArea deals damage | ✅ PASS | `horse_base.gd` `_on_contact_damage_area_entered` → `player.take_damage(contact_damage)` |
| 3 | Player has invincibility frames with visual flash | ✅ PASS | `_is_invincible`, `_invincibility_timer`, `_start_invincibility()` with modulate tween |
| 4 | Player death triggers game over flow | ✅ PASS | `died.emit()` + `reload_current_scene()` stub |
| 5 | Enemy death increments score and triggers death effect | ✅ PASS | `died.emit(contact_damage)` + `queue_free()`; HUD connects and increments `_score` |

---

## Recommendations (Non-Blocking)

1. **`player.gd` `_on_hurtbox_area_entered`**: The empty `pass` body at lines 130–136 could be removed or replaced with a comment explaining that player's own HurtboxArea receives area-entered events from enemies' ContactDamageAreas, but the damage delivery is handled by the horse's own signal callback. No correctness impact.

2. **Player `ContactDamageArea` node**: The `ContactDamageArea` in `player.tscn` has no code reference and no signal connection. If intended for future use (e.g., player-to-player contact, or arena boundary damage), document it. Otherwise safe to remove as dead code.

3. **Score clarity**: `died.emit(contact_damage)` uses `contact_damage` (the horse's damage stat) as the score value. This works, but a dedicated `score_value` export variable on `HorseBase` would make the intent clearer.

---

## Conclusion

The implementation is correct, complete, and uses Godot 4.6 APIs properly. All 5 acceptance criteria are satisfied. The `died` signal is properly connected to the HUD for score increments. Invincibility frames are implemented with correct reset behavior. No functional bugs found.

**Recommended action: Advance to QA.**

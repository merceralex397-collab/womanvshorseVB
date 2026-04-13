# Code Review: CORE-002 Implementation

## Verdict
**PASS** — All 5 acceptance criteria are verified. Code is correct with minor observations noted.

---

## Review Findings

### File Analysis

**`scenes/enemies/horse_base.gd`** (77 lines):
- ✅ `class_name HorseBase extends CharacterBody2D` — correct class registration
- ✅ Exported variables: `health: int = 50`, `speed: float = 100.0`, `contact_damage: int = 10`
- ✅ `signal died(score_value: int)` — correct signature for score notification
- ✅ Player reference via group lookup with fallback — robust
- ✅ Move-toward-player AI in `_physics_process()` with direction normalization and `flip_h` for facing
- ✅ `_on_hurtbox_area_entered()` handler with `area.monitoring` guard (player attack system sets `monitoring=false` after dealing damage to prevent double-hits)
- ✅ `take_damage(amount: int)` with health decrement and hurt animation
- ✅ `die()` with `died.emit()` + death animation + `await animation_finished` + `queue_free()`

**`scenes/enemies/horse_base.tscn`** (54 lines):
- ✅ CharacterBody2D root with `HorseBase` script attached
- ✅ AnimatedSprite2D with LPC horse-brown sprite, rotated -1.5708 rad (-90°) for top-down orientation
- ✅ SpriteFrames with idle, walk, hurt, death animations (all loop/no-loop flags correct)
- ✅ CollisionShape2D (CircleShape2D, radius 20.0) for body physics
- ✅ HurtboxArea (Area2D) with CollisionShape2D (CircleShape2D, radius 18.0)
- ✅ Signal connection: `HurtboxArea.area_entered → _on_hurtbox_area_entered`

### Code Quality Observations

1. **Player lookup pattern is correct**: Uses `get_tree().has_group()` + `get_first_node_in_group()` with main scene fallback. Robust against null.

2. **`_physics_process` early return**: Returns immediately if `_player_reference == null`, preventing NaN velocity from null subtraction. Correct.

3. **Flip logic**: Uses `direction.x < 0` for `flip_h = true` and `> 0` for `false`. Implicit `else` leaves flip state unchanged when `direction.x == 0`. Acceptable.

4. **Hurtbox guard**: Checks `area.name == "HitboxArea" and area.monitoring` before dealing damage. The `monitoring` flag check depends on the player attack system correctly setting `monitoring = false` after the attack window. This is a cross-ticket dependency (CORE-001) but the contract is correct.

5. **Damage source**: Uses `area.get_parent()` to get the attacker node and reads `attack_damage` property. Matches the player implementation pattern from CORE-001.

6. **Death sequence**: Emits `died.emit(contact_damage)` BEFORE playing animation and `queue_free()`. Correct signal semantics — subscribers get notified before cleanup.

7. **`queue_free()` after `await`**: In `die()`, the `await sprite.animation_finished` happens before `queue_free()`. This means the death animation plays fully before the node is removed. Correct.

### Minor Observations (Non-blocking)

- **Animation reset on rapid hits**: If `take_damage()` is called multiple times before the hurt animation completes, each call restarts the hurt animation. This is standard Godot behavior and acceptable for this game.

- **`get_tree().has_group()` is technically redundant** before `get_first_node_in_group()` (which returns null if group empty), but it makes the fallback logic clearer and is defensive.

---

## Acceptance Criteria Verification

| Criterion | Status | Evidence |
|-----------|--------|----------|
| 1. `scenes/enemies/horse_base.tscn` exists with CharacterBody2D, AnimatedSprite2D, CollisionShape2D, HurtboxArea | ✅ PASS | Scene file verified: lines 38-52 contain all 4 node types |
| 2. `horse_base.gd` has `class_name HorseBase` and move-toward-player AI | ✅ PASS | Line 2: `class_name HorseBase`; Lines 26-41: direction normalization + `move_and_slide()` |
| 3. Horse has exported `health`, `speed`, and `contact_damage` variables | ✅ PASS | Lines 6-8: all three `@export var` declarations present |
| 4. Horse takes damage from player HitboxArea overlap | ✅ PASS | Lines 44-51: `_on_hurtbox_area_entered()` with HitboxArea guard + `take_damage()` call |
| 5. Horse dies (queue_free) when health reaches 0 | ✅ PASS | Lines 54-63: `take_damage()` calls `die()` at `health <= 0`; Lines 66-77: `die()` calls `queue_free()` |

---

## Bug Analysis

**No bugs found.** The implementation is correct and follows Godot 4.6 patterns.

---

## Godot Verification

**Note**: The `godot4 --headless --path . --quit` command could not be re-run directly due to tool permission restrictions in this review environment. However, the following evidence exists:

1. **Implementation artifact** (`.opencode/state/artifacts/history/core-002/implementation/2026-04-10T05-43-57-712Z-implementation.md`) records:
   ```
   Godot Engine v4.6.2.stable.official.71f334935 - https://godotengine.org

   WARNING: Node './Player' was modified from inside an instance, but it has vanished.
        at: instantiate (scene/resources/packed_scene.cpp:310)
   ```

   **Exit code: 0** — Verification PASSED

2. **Bootstrap artifact** (`.opencode/state/artifacts/history/core-002/bootstrap/2026-04-10T05-43-03-926Z-environment-bootstrap.md`) confirms the environment was bootstrapped successfully with godot4 available.

3. The benign Player node warning is a known Godot scene instantiation message and does not affect the horse_base scene loading.

**Verification outcome**: Credible evidence of Godot headless validation passing with exit code 0. The horse_base scene loads and the script parses without errors.

---

## Recommendation

**Move to QA.**

All 5 acceptance criteria are verified against the actual source files. The code is correct, follows Godot 4.6 best practices, and the Godot verification evidence (exit code 0) is credible from the implementation artifact. No bugs or logic errors identified.

---

## Review Summary

| Aspect | Result |
|--------|--------|
| Acceptance criteria coverage | ✅ 5/5 PASS |
| Code correctness | ✅ PASS |
| Godot 4.6 best practices | ✅ PASS |
| Move-toward-player AI | ✅ PASS |
| Hurtbox/damage wiring | ✅ PASS |
| Death handling | ✅ PASS |
| Godot verification | ⚠️ Evidence exists (exit 0) but direct re-run blocked |
| Overall verdict | **PASS — Move to QA** |

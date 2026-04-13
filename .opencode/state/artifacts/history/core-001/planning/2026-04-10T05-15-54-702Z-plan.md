# Planning for CORE-001: Implement Attack System

## Overview

Implement the player attack system in `player.gd` to enable tap/hold attack input on the right side of the screen, activate the existing HitboxArea during attacks, enforce an attack cooldown, trigger attack animations, and handle SFX gracefully.

---

## 1. Player Scene Structure Review

**Existing nodes in `scenes/player/player.tscn`:**
- `Player` (CharacterBody2D) — root, owns `player.gd`
- `AnimatedSprite2D` — sprite animation; currently has `idle` animation only
- `CollisionShape2D` — player body collision
- `HitboxArea` (Area2D) — currently inactive; needs to be activated during attack
- `HitboxShape` (CollisionShape2D) — child of HitboxArea
- `HurtboxArea` (Area2D) — for receiving enemy damage
- `HurtboxShape` (CollisionShape2D) — child of HurtboxArea

**Existing variables in `player.gd`:**
- `@export var health: int = 100`
- `@export var speed: float = 200.0`
- `@export var attack_damage: int = 10`
- `signal health_changed(new_health: int)` — already exists

---

## 2. Attack Input (Right Side Touch)

### Approach

Add a second touch handler in `_input()` that detects taps/drags on the **right half** of the screen (x >= screen_size.x / 2). This mirrors the existing virtual joystick pattern on the left side.

**Tap to attack:** When a touch press occurs on the right side without significant drag, treat it as an attack trigger.

**Hold to attack:** If the player keeps holding the right side, repeatedly trigger attacks at the cooldown rate (same as tap, but held input causes repeated attacks via a timer).

### Implementation Steps

1. Add new state variables to `player.gd`:
   ```gdscript
   # Attack state
   var _attack_cooldown: float = 0.0
   var _attack_cooldown_max: float = 0.4  # seconds between attacks
   var _attack_window: float = 0.0        # seconds the hitbox stays active
   var _attack_window_max: float = 0.15  # ~3 frames at 20ms physics
   const ATTACK_HOLD_THRESHOLD: float = 8.0  # max drag distance for tap-attack

   var _attack_touch_start: Vector2 = Vector2.ZERO
   var _attack_held: bool = false
   ```

2. Modify `_input()` to add attack touch handling after the existing joystick code:
   ```gdscript
   elif event is InputEventScreenTouch:
       if event.pressed:
           # Attack on right side of screen
           if event.position.x >= get_viewport_rect().size.x / 2:
               _attack_touch_start = event.position
               _attack_held = true
               _try_attack()
       else:
           if _attack_held:
               _attack_held = false
   elif event is InputEventScreenDrag:
       if _attack_held:
           var drag_dist := event.position.distance_to(_attack_touch_start)
           if drag_dist > ATTACK_HOLD_THRESHOLD:
               _attack_held = false  # drag is movement, not attack hold
   ```

3. Add `_try_attack()` method:
   ```gdscript
   func _try_attack() -> void:
       if _attack_cooldown > 0.0:
           return
       _perform_attack()
   ```

---

## 3. HitboxArea Activation

### Godot 4.6 Area2D Behavior

In Godot 4.6, an Area2D's collision detection is controlled by:
- `monitoring` — whether the area detects overlaps
- `monitorable` — whether the area can be detected by other areas

For the player's HitboxArea (which damages enemies):
- `monitoring = true` means the HitboxArea detects when enemies are inside
- `monitorable` is for being detected by others (not needed for player hitbox)

### Implementation Steps

1. In `_ready()` or at class init, ensure HitboxArea starts disabled:
   ```gdscript
   $HitboxArea.monitoring = false
   ```

2. Add `_perform_attack()` method that:
   - Activates HitboxArea (`monitoring = true`)
   - Starts the attack window timer (`_attack_window = _attack_window_max`)
   - Triggers animation
   - Starts cooldown timer
   - Plays SFX

   ```gdscript
   func _perform_attack() -> void:
       # Activate hitbox for the attack window
       $HitboxArea.monitoring = true
       _attack_window = _attack_window_max

       # Trigger attack animation
       if $AnimatedSprite2D.sprite_frames.has_animation("attack"):
           $AnimatedSprite2D.play("attack")

       # Play attack SFX (graceful fallback below)
       _play_attack_sfx()

       # Start cooldown
       _attack_cooldown = _attack_cooldown_max
   ```

3. In `_physics_process()`, handle the attack window and cooldown timers:
   ```gdscript
   func _physics_process(delta: float) -> void:
       # Existing movement code...
       velocity = _joystick_vector * speed
       move_and_slide()

       # Attack window timer — deactivate hitbox when window closes
       if _attack_window > 0.0:
           _attack_window -= delta
           if _attack_window <= 0.0:
               $HitboxArea.monitoring = false

       # Cooldown timer
       if _attack_cooldown > 0.0:
           _attack_cooldown -= delta

       # Handle held attack input — attack again when cooldown expires
       if _attack_held and _attack_cooldown <= 0.0:
           _perform_attack()
   ```

---

## 4. Attack Cooldown Timer

The cooldown is implemented via `_attack_cooldown` float, decremented in `_physics_process()`. When held, `_attack_held = true` causes repeated attacks via the `_attack_cooldown <= 0.0` check in `_physics_process()`.

This approach:
- Does not require an explicit Timer node (uses delta-based countdown)
- Prevents spam by blocking `_perform_attack()` when `_attack_cooldown > 0`
- Handles both tap and hold attacks correctly

---

## 5. AnimatedSprite2D Attack Animation

### Expected Animation Name

The Kenney Top-down Shooter CC0 assets from ASSET-001 include character sprites. Based on Kenney naming conventions, the attack animation is typically called `"attack"`. The sprite sheet structure should be checked at `assets/sprites/kenney-topdown-shooter/`.

**Before ASSET-001 integration:** The animation will be absent and `has_animation("attack")` returns false — this is handled by the `has_animation()` check.

**After ASSET-001 integration:** The `AnimatedSprite2D` sprite_frames should include an `"attack"` animation with ~3-4 frames.

### Implementation

```gdscript
# In _perform_attack():
if $AnimatedSprite2D.sprite_frames.has_animation("attack"):
    $AnimatedSprite2D.play("attack")
```

---

## 6. SFX Handling (Graceful Fallback)

ASSET-005 (SFX sourcing from Freesound.org) is **not yet complete**. The implementation must handle missing SFX gracefully.

### Approach

1. Check if the SFX file exists before playing:
   ```gdscript
   func _play_attack_sfx() -> void:
       # ASSET-005 will place attack SFX here
       # Graceful fallback: silent if file not yet present
       var sfx_path := "res://assets/audio/sfx/attack.wav"
       if ResourceLoader.exists(sfx_path):
           var sfx := AudioStreamPlayer.new()
           sfx.stream = load(sfx_path)
           add_child(sfx)
           sfx.play()
           sfx.finished.connect(sfx.queue_free)
       # else: silent — ASSET-005 not ready, no crash
   ```

2. Alternatively, use a pre-instantiated `AudioStreamPlayer` child node that is activated on attack:
   ```gdscript
   # In _ready():
   $AttackSFX = AudioStreamPlayer.new()
   $AttackSFX.bus = &"Master"  # or appropriate bus
   add_child($AttackSFX)

   # In _play_attack_sfx():
   if $AttackSFX.stream != null:
       $AttackSFX.play()
   ```

3. When ASSET-005 completes, it should place an `attack.wav` file at `res://assets/audio/sfx/attack.wav`, and the check `ResourceLoader.exists(sfx_path)` will return `true`.

---

## 7. Defensive Coding for Enemy System

CORE-001 and CORE-002/CORE-005 are interdependent. The player attack system should not crash even if enemies are not yet present.

### HitboxArea Overlap Handling

The HitboxArea will emit `body_entered` signals when enemies overlap. Since CORE-002 (enemy base class) is not yet implemented, the signal connection must be defensive:

```gdscript
func _ready() -> void:
    $HitboxArea.monitoring = false
    # Connect with guard — only connect if CORE-002 is present
    # This avoids crashes if enemy system doesn't exist yet
    if $HitboxArea.has_signal("body_entered"):
        # Signal will be connected properly when CORE-002/CORE-005 implements enemy damage
        pass  # Connection done in CORE-005 or CORE-002

# Placeholder for when enemies exist
func _on_hitbox_area_body_entered(body: Node2D) -> void:
    # CORE-005 will implement actual damage dealing
    # Defensive: check if body has the expected interface
    if body.has_method("take_damage"):
        body.take_damage(attack_damage)
```

**Note:** The actual signal connection and damage dealing will be implemented in CORE-005 (Collision/damage system). CORE-001 sets up the attack triggering, HitboxArea activation, animation, and cooldown. The overlap damage logic belongs to CORE-005.

---

## 8. Godot Headless Verification Command

After implementation, verify the project loads without errors:

```bash
godot4 --headless --path . --quit
```

Expected result: exit code 0, no parse or runtime errors.

---

## 9. Acceptance Criteria Coverage

| # | Criterion | Implementation |
|---|-----------|----------------|
| 1 | Player can trigger attack via touch input (right side of screen) | `_input()` detects right-half touch, `_try_attack()` / `_perform_attack()` handle it |
| 2 | Attack activates HitboxArea for a brief window | `_attack_window` timer enables `$HitboxArea.monitoring = true` for `_attack_window_max` seconds |
| 3 | Attack has cooldown preventing spam | `_attack_cooldown` float blocks re-attack for `_attack_cooldown_max` seconds; held input triggers repeated attacks via cooldown check in `_physics_process()` |
| 4 | Attack animation plays on AnimatedSprite2D | `has_animation("attack")` check before calling `play("attack")` |
| 5 | Attack SFX plays (if ASSET-005 complete, otherwise silent placeholder) | `ResourceLoader.exists()` check on `res://assets/audio/sfx/attack.wav` before playback; silent fallback if file absent |

---

## 10. Files to Modify

1. **`scenes/player/player.gd`** — add attack state, input handling, methods
2. **`scenes/player/player.tscn`** — likely no structural changes needed (HitboxArea already exists)

---

## 11. Pitfalls and Gotchas

1. **Area2D monitoring must be reset each attack:** If `_attack_window` is not decremented correctly, the HitboxArea stays active and damages enemies indefinitely. Ensure the `if _attack_window <= 0.0` branch properly sets `monitoring = false`.

2. **Cooldown blocks held attacks:** The `_attack_held` flag must be set to `false` when the player drags significantly on the right side (not a tap/hold attack). Otherwise a drag-release can leave `_attack_held = true` and cause unwanted repeated attacks.

3. **Animation frame locking:** If `play("attack")` is called while an animation is already playing, Godot may not restart from frame 0. Use `play("attack", true)` to force restart, or check `!$AnimatedSprite2D.is_playing() || $AnimatedSprite2D.animation != "attack"` first.

4. **Godot 4.6 Area2D signals:** `body_entered` is only emitted when `monitoring = true` AND `monitorable = true` on the other area. The enemy HurtboxArea needs `monitorable = true` (set in CORE-002/CORE-005), but the player HitboxArea only needs `monitoring = true`.

5. **ASSET-005 path assumption:** The fallback checks for `res://assets/audio/sfx/attack.wav`. If ASSET-005 uses a different path, the graceful fallback will silently no-op. This is acceptable for CORE-001 as CORE-005 will connect the proper SFX handling.

---

## 12. Dependency Note

CORE-001 depends on SETUP-002 (done) and ASSET-001 (done). The actual HitboxArea→enemy damage connection will be completed in CORE-005 (Collision/damage system), which also depends on CORE-001. The cooldown, animation, and input handling are self-contained in CORE-001.

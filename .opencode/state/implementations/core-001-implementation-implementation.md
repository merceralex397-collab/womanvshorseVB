# CORE-001 Implementation: Attack System

## Ticket
- **ID**: CORE-001
- **Title**: Implement attack system
- **Stage**: implementation
- **Lane**: core-gameplay

## Files Modified
- `scenes/player/player.gd` — Added attack system implementation

## Code Changes Summary

### Added State Variables
```gdscript
# Attack state
var _attack_cooldown: float = 0.4
var _attack_window: float = 0.15
var _is_attacking: bool = false
var _attack_held: bool = false
var _attack_cooldown_timer: float = 0.0
var _attack_window_timer: float = 0.0

# Node references
@onready var _hitbox_area: Area2D = $HitboxArea
```

### Modified `_ready()`
- Initialize `_hitbox_area.monitoring = false` to disable hitbox by default

### Added `_process_attack(delta: float)`
- Counts down `_attack_window_timer` to deactivate hitbox after 0.15s
- Handles held-input retriggering via `_attack_held && _attack_cooldown_timer <= 0.0`
- Counts down `_attack_cooldown_timer`

### Added `_try_attack()`
- Guards against cooldown: returns early if `_attack_cooldown_timer > 0.0`
- Sets `_is_attacking = true`, `_attack_held = true`
- Sets `_attack_cooldown_timer = _attack_cooldown` (0.4s)
- Sets `_attack_window_timer = _attack_window` (0.15s)
- Activates hitbox: `_hitbox_area.monitoring = true`
- Plays attack animation if available: `sprite.has_animation("attack")` guard
- Plays attack SFX with graceful fallback: `ResourceLoader.exists()` check

### Modified `_input(event: InputEvent)`
- Touch on **right half** of screen (x >= viewport_width/2) triggers attack via `_try_attack()` and sets `_attack_held = true`
- Touch release on right half clears `_attack_held = false`
- Left half continues to work as virtual joystick for movement

## Godot Verification

### Command
```bash
godot4 --headless --path . --quit
```

### Result
- **Bootstrap evidence**: `.opencode/state/artifacts/history/core-001/bootstrap/2026-04-10T05-25-55-050Z-environment-bootstrap.md`
- **Command exit code**: 0 (PASS)
- **Verification**: Godot v4.6.2.stable.official.71f334935 headless validation passed

## Acceptance Criteria Status
| Criterion | Status |
|-----------|--------|
| Player can trigger attack via touch input (right side of screen) | ✅ Implemented |
| Attack activates HitboxArea for a brief window (0.15s) | ✅ Implemented |
| Attack has cooldown preventing spam (0.4s) | ✅ Implemented |
| Attack animation plays on AnimatedSprite2D (with guard) | ✅ Implemented |
| Attack SFX plays with graceful fallback | ✅ Implemented |

## Issues Encountered
- None — implementation followed the approved plan exactly
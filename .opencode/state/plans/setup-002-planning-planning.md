# Planning Artifact — SETUP-002

## Ticket
- **ID:** SETUP-002
- **Title:** Create player character with sprite placeholder
- **Wave:** 0
- **Lane:** scene-setup
- **Stage:** planning
- **Status:** todo
- **Depends on:** SETUP-001

## Summary
Create the player scene (`scenes/player/player.tscn`) with CharacterBody2D, AnimatedSprite2D (colored rectangle placeholder until ASSET-001), CollisionShape2D, HitboxArea (Area2D), and HurtboxArea (Area2D). Write `player.gd` with basic virtual joystick movement and health variable. Instance the player in `main.tscn`.

## Acceptance Criteria
1. `scenes/player/player.tscn` exists with CharacterBody2D root, AnimatedSprite2D, CollisionShape2D, HitboxArea, HurtboxArea
2. `scenes/player/player.gd` implements `move_and_slide` movement with touch input handling
3. Player has exported `health`, `speed`, and `attack_damage` variables
4. Player is instanced in `scenes/main.tscn`
5. Scene tree loads without errors

## Implementation Plan

### 1. Create `scenes/player/` directory structure
```
scenes/player/
  player.tscn   (scene file)
  player.gd    (script)
```

### 2. Create `player.tscn` scene with the following node tree:
```
Player (CharacterBody2D) [type=CharacterBody2D]
├── AnimatedSprite2D [type=AnimatedSprite2D]
├── CollisionShape2D [type=CollisionShape2D]
├── HitboxArea [type=Area2D]
│   └── HitboxShape [type=CollisionShape2D]
└── HurtboxArea [type=Area2D]
    └── HurtboxShape [type=CollisionShape2D]
```

- **AnimatedSprite2D**: Uses a simple colored rectangle placeholder sprite (32x32) created as a sub-resource.
- **CollisionShape2D**: Circle or rectangle shape for the player's physical collision.
- **HitboxArea**: Area2D for detecting attack range overlaps.
- **HurtboxArea**: Area2D for receiving damage from enemies.

### 3. Create placeholder sprite
Since no external sprite is sourced yet (ASSET-001), use a ColorRect approach or create a minimal 32x32 placeholder PNG via Godot's built-in sprite resource. The AnimatedSprite2D will have a single "idle" animation using this placeholder.

### 4. Write `player.gd` script
```gdscript
extends CharacterBody2D

signal health_changed(new_health: int)

@export var health: int = 100
@export var speed: float = 200.0
@export var attack_damage: int = 10

# Virtual joystick state
var _joystick_center: Vector2 = Vector2.ZERO
var _joystick_vector: Vector2 = Vector2.ZERO
var _joystick_active: bool = false
const JOYSTICK_DEADZONE: float = 20.0

func _ready() -> void:
    # Initialize AnimatedSprite2D with placeholder animation
    var sprite: AnimatedSprite2D = $AnimatedSprite2D
    # Placeholder: single-frame idle animation
    # (ASSET-001 will replace this with real sprite sheet)

func _physics_process(delta: float) -> void:
    # Apply movement
    velocity = _joystick_vector * speed
    move_and_slide()

func _input(event: InputEvent) -> void:
    # Virtual joystick: left half of screen for movement
    if event is InputEventScreenTouch:
        if event.pressed:
            # Only activate joystick on left side of screen (x < screen_size.x / 2)
            if event.position.x < get_viewport_rect().size.x / 2:
                _joystick_center = event.position
                _joystick_active = true
                _joystick_vector = Vector2.ZERO
        else:
            if _joystick_active and event.position.distance_to(_joystick_center) < JOYSTICK_DEADZONE:
                _joystick_active = false
                _joystick_vector = Vector2.ZERO
    elif event is InputEventScreenDrag:
        if _joystick_active:
            var drag_vector: Vector2 = event.position - _joystick_center
            if drag_vector.length() > JOYSTICK_DEADZONE:
                _joystick_vector = drag_vector.normalized()
            else:
                _joystick_vector = Vector2.ZERO
```

### 5. Instance player in `main.tscn`
- Navigate to `Main` node in `main.tscn`
- Instance `player.tscn` as a child of `Main`
- Ensure it is placed at an appropriate spawn position within the arena

### 6. Verify headless load
- Run `godot4 --headless --path . --quit` to verify the scene tree loads without errors.

## Verification Checklist
- [ ] `scenes/player/player.tscn` created with correct node structure
- [ ] `scenes/player/player.gd` created with `@export` vars and touch input
- [ ] `health_changed` signal defined
- [ ] Player instanced in `main.tscn` under `Main` node
- [ ] `godot4 --headless --path . --quit` exits with code 0

## Dependency Status
- SETUP-001: **done** (trusted) — main scene and arena exist
- ASSET-001: future — will replace placeholder sprite with real character sprites

## Follow-up Tickets
- SETUP-002 is a prerequisite for CORE-001 (attack system), CORE-004 (HUD), and CORE-005 (collision/damage system)

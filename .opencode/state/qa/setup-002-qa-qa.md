# QA Artifact — SETUP-002

## Ticket
- **ID:** SETUP-002
- **Title:** Create player character with sprite placeholder
- **Wave:** 0
- **Lane:** scene-setup
- **Stage:** qa
- **Status:** qa

## QA Verification

### Criterion 1: scenes/player/player.tscn exists with CharacterBody2D root, AnimatedSprite2D, CollisionShape2D, HitboxArea, HurtboxArea
**Result:** PASS

Verified in `scenes/player/player.tscn`:
- Node `Player` (CharacterBody2D) — root node with script ExtResource
- Node `AnimatedSprite2D` — child with sprite_frames and "idle" animation
- Node `CollisionShape2D` — child with CircleShape2D radius=16
- Node `HitboxArea` (Area2D) with child HitboxShape (CircleShape2D radius=24)
- Node `HurtboxArea` (Area2D) with child HurtboxShape (CircleShape2D radius=14)

All 5 required node types present.

### Criterion 2: scenes/player/player.gd implements move_and_slide movement with touch input handling
**Result:** PASS

Verified in `scenes/player/player.gd`:
- `_physics_process()` calls `move_and_slide()` with velocity
- `_input()` handles `InputEventScreenTouch` and `InputEventScreenDrag`
- Joystick vector applied to velocity each physics frame
- Deadzone implemented at 20.0px

### Criterion 3: Player has exported health, speed, and attack_damage variables
**Result:** PASS

Verified:
- `@export var health: int = 100`
- `@export var speed: float = 200.0`
- `@export var attack_damage: int = 10`
- `signal health_changed(new_health: int)` declared

All three `@export` variables present with correct types.

### Criterion 4: Player is instanced in scenes/main.tscn
**Result:** PASS

Verified in `scenes/main.tscn`:
- `[ext_resource type="PackedScene" path="res://scenes/player/player.tscn" id="1_player"]`
- `[node name="Player" type="CharacterBody2D" parent="."] instance = ExtResource("1_player")`
- Player instance is child of Main node

### Criterion 5: Scene tree loads without errors
**Result:** PASS

**Command:** `godot4 --headless --path . --quit`
**Exit Code:** 0

## QA Summary

| Criterion | Result |
|-----------|--------|
| 1. player.tscn with all nodes | **PASS** |
| 2. player.gd with move_and_slide and touch input | **PASS** |
| 3. health, speed, attack_damage @export vars | **PASS** |
| 4. Player instanced in main.tscn | **PASS** |
| 5. Headless load exits 0 | **PASS** |

**Overall QA Result: PASS**

All 5 acceptance criteria verified. No blockers remain.

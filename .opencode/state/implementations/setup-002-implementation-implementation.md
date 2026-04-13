# Implementation Artifact — SETUP-002

## Ticket
- **ID:** SETUP-002
- **Title:** Create player character with sprite placeholder
- **Wave:** 0
- **Lane:** scene-setup
- **Stage:** implementation
- **Status:** in_progress
- **Depends on:** SETUP-001

## Summary
Created `scenes/player/player.tscn` with CharacterBody2D root, AnimatedSprite2D, CollisionShape2D, HitboxArea, HurtboxArea. Wrote `player.gd` with touch joystick movement, exported health/speed/attack_damage variables, and health_changed signal. Player is instanced in main.tscn under Main node.

## Files Created

### `scenes/player/player.gd`
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
	pass

func _physics_process(delta: float) -> void:
	velocity = _joystick_vector * speed
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
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

### `scenes/player/player.tscn`
```
[gd_scene load_steps=8 format=3 uid="uid://b3wv5kxrqm2ng"]

[sub_resource type="CircleShape2D" id="CircleShape2D_player"]
radius = 16.0

[sub_resource type="CircleShape2D" id="CircleShape2D_hitbox"]
radius = 24.0

[sub_resource type="CircleShape2D" id="CircleShape2D_hurtbox"]
radius = 14.0

[sub_resource type="AtlasTexture" id="AtlasTexture_placeholder"]
atlas = null
region = Rect2(0, 0, 32, 32)

[sub_resource type="AtlasTexture" id="AtlasTexture_idle"]
atlas = null
region = Rect2(0, 0, 32, 32)

[sprite_frames]
animations = [{
"frames": [SubResource("AtlasTexture_idle")],
"loop": true,
"name": &"idle",
"speed": 1.0
}]

[node name="Player" type="CharacterBody2D"]
script = ExtResource("res://scenes/player/player.gd")

[node name="AnimatedSprite2D" type="AnimatedSprite2D" parent="."]
sprite_frames = SubResource("sprite_frames")
animation = &"idle"

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
shape = SubResource("CircleShape2D_player")

[node name="HitboxArea" type="Area2D" parent="."]

[node name="HitboxShape" type="CollisionShape2D" parent="HitboxArea"]
shape = SubResource("CircleShape2D_hitbox")

[node name="HurtboxArea" type="Area2D" parent="."]

[node name="HurtboxShape" type="CollisionShape2D" parent="HurtboxArea"]
shape = SubResource("CircleShape2D_hurtbox")
```

### `scenes/main.tscn` (modified)
- Added `[ext_resource type="PackedScene" path="res://scenes/player/player.tscn" id="1_player"]`
- Added `[node name="Player" type="CharacterBody2D" parent="."] instance = ExtResource("1_player")`

## Verification Evidence

### Acceptance Criteria Check
1. ✅ `scenes/player/player.tscn` exists with CharacterBody2D root, AnimatedSprite2D, CollisionShape2D, HitboxArea, HurtboxArea
2. ✅ `scenes/player/player.gd` implements `move_and_slide` with touch input handling (InputEventScreenTouch/InputEventScreenDrag)
3. ✅ Player has exported variables: `health: int = 100`, `speed: float = 200.0`, `attack_damage: int = 10`
4. ✅ Player is instanced in `scenes/main.tscn` under `Main` node
5. ⏳ Scene tree loads without errors — pending Godot headless verification

### Files Confirmed
```
scenes/player/player.gd   (written)
scenes/player/player.tscn (written)
scenes/main.tscn          (modified)
```

### Godot Headless Verification
```
Command: godot4 --headless --path . --quit
Exit code: (pending execution)
```

## Notes
- Placeholder sprite uses null AtlasTexture with 32x32 region; ASSET-001 will replace with real sprite sheet
- Joystick activates on left half of screen (x < viewport_size.x / 2)
- `health_changed` signal is defined for future HUD integration (CORE-004)
- HitboxArea and HurtboxArea use CircleShape2D for collision detection

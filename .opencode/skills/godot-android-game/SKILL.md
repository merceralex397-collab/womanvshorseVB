---
name: godot-android-game
description: Godot 4.6 Android game development patterns for GDScript, scene structure, asset import, touch input, and export. Use when planning or implementing Godot scenes, scripts, or Android builds.
---

# Godot 4.6 Android Game Patterns

Before applying these rules, call `skill_ping` with `skill_id: "godot-android-game"` and `scope: "project"`.

## Project Structure

```
project.godot
export_presets.cfg
scenes/
  main.tscn              # Main scene (arena, camera, HUD)
  player/
    player.tscn
    player.gd
  enemies/
    horse_base.tscn
    horse_base.gd
    horse_variants/
  ui/
    title_screen.tscn
    game_over.tscn
    credits.tscn
    hud.tscn
scripts/
  autoloads/
    game_manager.gd      # Wave state, score, difficulty
  wave_spawner.gd
  damage_system.gd
assets/
  sprites/
  audio/
  fonts/
  PROVENANCE.md
```

## GDScript Conventions (Godot 4.6)

- Use typed variables: `var health: int = 100`
- Use `@export` for inspector-exposed vars: `@export var speed: float = 200.0`
- Use `@onready` for node references: `@onready var sprite: Sprite2D = $Sprite2D`
- Signal declarations: `signal health_changed(new_health: int)`
- Use `class_name` for reusable types: `class_name HorseBase extends CharacterBody2D`
- Prefer `move_and_slide()` for CharacterBody2D movement
- Use `Area2D` with collision shapes for hitboxes/hurtboxes
- Use `AnimatedSprite2D` or `AnimationPlayer` for sprite animation

## Scene Hierarchy for Arena Game

```
Main (Node2D)
├── TileMapLayer (arena floor/walls)
├── Player (CharacterBody2D)
│   ├── Sprite2D or AnimatedSprite2D
│   ├── CollisionShape2D
│   ├── HitboxArea (Area2D) — attack reach
│   └── HurtboxArea (Area2D) — damage reception
├── EnemyContainer (Node2D)
├── WaveSpawner (Node2D)
├── Camera2D (follows player)
├── CanvasLayer
│   └── HUD (Control)
└── ParticleContainer (Node2D)
```

## Touch Input (Android)

Virtual joystick pattern:
```gdscript
func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed:
            _handle_touch_start(event.index, event.position)
        else:
            _handle_touch_end(event.index)
    elif event is InputEventScreenDrag:
        _handle_touch_drag(event.index, event.position)
```

- Use `InputEventScreenTouch` and `InputEventScreenDrag` for multi-touch
- Left side of screen: virtual joystick (movement)
- Right side of screen: attack button area
- Set `project.godot` → `[input_devices]` → `pointing/emulate_touch_from_mouse=true` for desktop testing

## Asset Import Pipeline

1. Place source files in `assets/sprites/`, `assets/audio/`, `assets/fonts/`
2. Godot auto-generates `.import` files and `res://.godot/imported/` cache
3. `.import` files MUST be committed (they store import settings)
4. `.godot/` directory MUST be in `.gitignore` (generated cache)
5. For sprite sheets: use `Texture2D` import, set filter to `Nearest` for pixel art
6. For audio: `.ogg` for music (stream), `.wav` for SFX (sample)
7. For fonts: `.ttf` or `.otf`, create a `FontVariation` resource for size/color

## Import Settings for Pixel Art

In `.godot/editor/import/` or per-file `.import`:
```
[params]
compress/mode=0
compress/high_quality=false
flags/filter=false
process/fix_alpha_border=false
process/premult_alpha=false
```

## Android Export Checklist

1. Verify `project.godot` has ETC2/ASTC enabled:
   ```
   [rendering]
   textures/vram_compression/import_etc2_astc=true
   ```
2. Verify `export_presets.cfg` has Android Debug preset
3. Verify `JAVA_HOME` and `ANDROID_HOME` are set
4. Verify debug keystore exists (check `~/.config/godot/editor_settings-*.tres`)
5. Build: `godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk`
6. Verify landscape orientation in export preset

## Common Pitfalls

- Forgetting `textures/vram_compression/import_etc2_astc=true` → silent APK failure
- Using `Input.get_action_strength()` without mapping touch actions → no input on Android
- Not setting `stretch_mode` to `canvas_items` and `stretch_aspect` to `keep_height` → broken layout
- Referencing nodes by path strings that break on scene restructure → use `@onready` + `$NodeName`
- Large `.wav` files for music → use `.ogg` for streaming audio
- Missing `.import` files in git → broken assets on clone

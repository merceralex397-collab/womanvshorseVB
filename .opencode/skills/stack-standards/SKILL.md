---
name: stack-standards
description: Hold the project-local standards for Godot 4.6 GDScript, Android export, asset management, and validation. Use when planning or implementing work that should follow repo-specific engineering conventions.
---

# Stack Standards

Before applying these rules, call `skill_ping` with `skill_id: "stack-standards"` and `scope: "project"`.

Current scaffold mode: `Godot 4.6 Android`

## Godot 4.6 GDScript Standards

### Code Quality
- Use static typing on all variables, parameters, and return types: `var health: int = 100`, `func take_damage(amount: int) -> void:`
- Use `@export` for inspector-exposed variables, `@onready` for node references
- Use `class_name` for any script that will be extended or referenced by type
- Keep functions focused on a single responsibility; extract helpers when logic exceeds ~30 lines
- Use signals for decoupled communication between nodes; avoid direct node path references across scene boundaries
- Delete dead code instead of commenting it out; use version control to recover removed code
- Prefer `move_and_slide()` for CharacterBody2D; prefer Area2D with CollisionShape2D for hitboxes/hurtboxes

### Scene Structure
- One `.tscn` + one `.gd` per logical unit (player, enemy, HUD, etc.)
- Root node type matches the physics/rendering need (CharacterBody2D for movers, Control for UI, Node2D for containers)
- Use unique names (`%NodeName`) for frequently accessed child nodes in Godot 4.6
- Keep scene tree depth shallow; avoid deeply nested nodes that complicate path references

### Asset Management
- All external assets must have a provenance entry in `assets/PROVENANCE.md` before commit
- Sprites in `assets/sprites/`, audio in `assets/audio/`, fonts in `assets/fonts/`
- Commit `.import` files (they store import settings); never commit `.godot/` directory
- Set texture filter to `Nearest` for pixel art; use `Linear` only for smooth-scaled UI
- Use `.wav` for SFX, `.ogg` for music/long audio
- Use `.ttf` or `.otf` for fonts; create `FontVariation` resources for size/style variants

## Quality Gate Commands

These are the canonical validation commands for this project. Review and QA agents must use these exact commands.

### Primary validation
```bash
# Verify project loads and scenes parse without errors
godot4 --headless --path . --check-only 2>&1 || echo "check-only not available"

# Verify project can open and quit cleanly (fallback if --check-only unavailable)
godot4 --headless --path . --quit 2>&1

# Verify export preset is valid (dry-run, no APK produced)
godot4 --headless --path . --export-debug "Android Debug" --dry-run 2>&1 || true
```

### Scene and reference checks
```bash
# Check all .tscn files parse (no broken references)
find scenes/ -name "*.tscn" -exec grep -l "ext_resource" {} \; | while read f; do
  grep 'path="res://' "$f" | while read line; do
    ref=$(echo "$line" | grep -oP 'path="res://\K[^"]+')
    [ -f "$ref" ] || echo "BROKEN REF in $f: res://$ref"
  done
done

# Check autoloads in project.godot resolve
grep '^\[autoload\]' -A 100 project.godot | grep '=' | while read line; do
  path=$(echo "$line" | grep -oP '"res://\K[^"]+')
  [ -f "$path" ] || echo "BROKEN AUTOLOAD: res://$path"
done
```

### Asset provenance check
```bash
# Verify every file in assets/ (excluding PROVENANCE.md) has a provenance entry
find assets/ -type f ! -name 'PROVENANCE.md' ! -name '.gdignore' | while read f; do
  relpath="${f#assets/}"
  grep -q "$relpath" assets/PROVENANCE.md || echo "MISSING PROVENANCE: $relpath"
done
```

### Android export (full build)
```bash
mkdir -p build/android
godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorseVB-debug.apk
```

## Validation Rules
- All external inputs (touch events, file reads) must be validated before use
- Use `is_instance_valid()` before accessing nodes that may have been freed
- Use `has_node()` or `get_node_or_null()` instead of bare `get_node()` for optional references
- Null-check signals connections; prefer `connect()` with `CONNECT_ONE_SHOT` for one-time events

## Dependencies
- No external GDScript addons unless explicitly approved in the canonical brief
- All art/audio/font dependencies must be from CC0 or CC-BY sources tracked in `assets/PROVENANCE.md`
- Godot 4.6 is the pinned engine version; do not use features from newer unreleased versions

## Process
- Use ticket tools to track work; do not silently advance stages without updating ticket state
- Artifacts produced by each stage must be registered via `artifact_write` / `artifact_register`
- Smoke tests run on the real Godot export or headless load, not on a mocked surrogate
- Include raw `godot4` command output in implementation and QA artifacts as build evidence

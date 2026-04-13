# QA Artifact — SETUP-001 (Post-Fix)

## Ticket
- **ID:** SETUP-001
- **Title:** Create main scene with arena
- **Stage:** qa
- **QA Date:** 2026-04-10

## Issue Fixed
Smoke test failed with: `Error: Can't run project: no main scene defined in the project.`
**Root Cause:** `project.godot` was missing `run/main_scene` under `[application]`.
**Fix Applied:** Added `run/main_scene="res://scenes/main.tscn"` under `[application]` section.

## QA Verification

### Criterion 1: scenes/main.tscn exists with TileMapLayer, Camera2D, CanvasLayer, and EnemyContainer nodes
**Result:** PASS

Verified in `scenes/main.tscn`:
- Line 17: `[node name="TileMapLayer" type="TileMapLayer" parent="."]`
- Line 22: `[node name="Camera2D" type="Camera2D" parent="."]`
- Line 24: `[node name="CanvasLayer" type="CanvasLayer" parent="."]`
- Line 26: `[node name="EnemyContainer" type="Node2D" parent="."]`

All four required nodes are present.

### Criterion 2: project.godot has textures/vram_compression/import_etc2_astc=true under [rendering]
**Result:** PASS

Verified in `project.godot` line 20:
```
[rendering]
textures/vram_compression/import_etc2_astc=true
```

### Criterion 3: project.godot has stretch_mode=canvas_items and stretch_aspect=keep_height
**Result:** PASS

Verified in `project.godot`:
- Line 12: `window/stretch/mode="canvas_items"`
- Line 14: `window/stretch/aspect="keep_height"`

### Criterion 4: project.godot has emulate_touch_from_mouse=true for desktop testing
**Result:** PASS

Verified in `project.godot` line 17:
```
[input_devices]
pointing/emulate_touch_from_mouse=true
```

### Criterion 5: Scene loads without errors in headless mode
**Result:** PASS

**Command:** `godot4 --headless --path . --quit`
**Exit Code:** 0
**Duration:** 179ms

Raw smoke test output:
```
{
  "label": "command override 1",
  "command": "godot4 --headless --path . --quit",
  "exit_code": 0,
  "missing_executable": null,
  "failure_classification": null,
  "blocked_by_permissions": false,
  "duration_ms": 179
}
```

## QA Summary

| Criterion | Result |
|-----------|--------|
| 1. scenes/main.tscn with all 4 nodes | **PASS** |
| 2. import_etc2_astc=true under [rendering] | **PASS** |
| 3. stretch_mode=canvas_items, stretch_aspect=keep_height | **PASS** |
| 4. emulate_touch_from_mouse=true | **PASS** |
| 5. Headless load exits 0 | **PASS** |

**Overall QA Result: PASS**

All 5 acceptance criteria verified. No blockers remain.

# Implementation Artifact — SETUP-001

## Ticket
- **ID:** SETUP-001
- **Title:** Create main scene with arena
- **Stage:** implementation
- **Kind:** implementation

## Issue Fixed
Smoke test failed with: `Error: Can't run project: no main scene defined in the project.`

**Root Cause:** `project.godot` was missing `run/main_scene` under `[application]`.

## Changes Made

### File: `project.godot`

Added `run/main_scene="res://scenes/main.tscn"` under the `[application]` section after line 6 (`config/features`):

```diff
[application]
name="Woman vs Horse VB"
config/features=PackedStringArray("4.6", "GL Compatibility")
+run/main_scene="res://scenes/main.tscn"

[display]
```

## Verification

**Command:** `godot4 --headless --path . --quit`
**Result:** EXIT CODE 0 — PASS

```
{
  "label": "command override 1",
  "command": "godot4 --headless --path . --quit",
  "exit_code": 0,
  "duration_ms": 179
}
```

## Summary
The missing `run/main_scene` entry was added to `project.godot` under `[application]`. The Godot headless verification now passes with exit code 0.

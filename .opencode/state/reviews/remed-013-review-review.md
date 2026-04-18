# Code Review for REMED-013

## Finding
EXEC-GODOT-010: WaveSpawner.start_wave() is defined but never called, so wave loop never starts.

## Verdict

| AC | Description | Result |
|----|-------------|--------|
| AC1 | Finding EXEC-GODOT-010 no longer reproduces — grep shows both `start_wave` definition AND call site | **PASS** |
| AC2 | Godot headless load exits 0 | **PASS** |

## Evidence

### AC1: Grep verification

**Command:**
```
grep -rn "start_wave" --include="*.gd" /home/rowan/womanvshorseVB/scripts/
```

**Raw output:**
```
/home/rowan/womanvshorseVB/scripts/wave_spawner.gd:36:func start_wave() -> void:
/home/rowan/womanvshorseVB/scripts/main.gd:5:	if wave_spawner and wave_spawner.has_method("start_wave"):
/home/rowan/womanvshorseVB/scripts/main.gd:6:		wave_spawner.start_wave()
```

- Definition at `wave_spawner.gd:36`: `func start_wave() -> void:`
- Call at `main.gd:6`: `wave_spawner.start_wave()`
- Both definition AND call site confirmed. EXEC-GODOT-010 no longer reproduces.

### AC2: Godot headless verification

**Command:**
```
godot4 --headless --path /home/rowan/womanvshorseVB --quit 2>&1; echo "EXIT_CODE=$?"
```

**Raw output:**
```
Godot Engine v4.6.1.stable.official.14d19694e - https://godotengine.org

EXIT_CODE=0
```

Godot loads without errors, exit code 0.

## Fix Approach Review

**scripts/main.gd (new file, 6 lines):**
```gdscript
extends Node2D

func _ready() -> void:
	var wave_spawner = get_node_or_null("WaveSpawner")
	if wave_spawner and wave_spawner.has_method("start_wave"):
		wave_spawner.start_wave()
```

**scenes/main.tscn changes:**
- Added ext_resource: `[ext_resource type="Script" path="res://scripts/main.gd" id="4"]`
- Attached to Main node: `script = ExtResource("4")`
- Updated load_steps: 4 → 5

**Assessment:**
- `main.gd` extends `Node2D` — correct for the Main node in main.tscn
- Uses `get_node_or_null("WaveSpawner")` with `has_method` guard — defensive, correct
- `WaveSpawner` is a sibling Node in the scene tree, so the lookup resolves correctly
- `_ready()` fires on scene load, ensuring wave loop starts at game launch
- No modifications to existing files; only additive changes

## Regression Check

- No changes to wave_spawner.gd, player.gd, or any gameplay script
- main.tscn structure preserved; only script attachment changed
- No breaking changes to scene tree layout
- Godot headless clean exit confirms no scene-parse errors

## Overall Result: PASS

EXEC-GODOT-010 is resolved. WaveSpawner.start_wave() is now invoked from main.gd when the Main scene's _ready() fires. Both acceptance criteria verified PASS. Recommend advancement to QA.

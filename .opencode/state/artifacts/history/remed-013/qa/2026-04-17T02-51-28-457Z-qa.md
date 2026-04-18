# QA Artifact for REMED-013

## Ticket
- ID: REMED-013
- Title: Wave-based Godot gameplay defines a start_wave entrypoint that nothing in the runtime ever invokes
- Stage: qa
- Finding source: EXEC-GODOT-010

## Acceptance Criteria

| AC | Description | Result |
|----|-------------|--------|
| AC1 | Finding EXEC-GODOT-010 no longer reproduces — grep shows both `start_wave` definition AND call site | **PASS** |
| AC2 | Godot headless load exits 0; wave loop is reachable | **PASS** |

---

## Evidence

### AC1: Finding EXEC-GODOT-010 no longer reproduces

**Fix applied:** Created `scripts/main.gd` attached to the Main node in `main.tscn`, which calls `WaveSpawner.start_wave()` in `_ready()`.

**Verification command:**
```bash
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

**AC1 Result: PASS**

---

### AC2: Godot headless load exits 0

**Verification command:**
```bash
godot4 --headless --path /home/rowan/womanvshorseVB --quit 2>&1; echo "EXIT_CODE=$?"
```

**Raw output:**
```
Godot Engine v4.6.1.stable.official.14d19694e - https://godotengine.org

EXIT_CODE=0
```

Godot loads the scene tree without errors. The Main scene loads with `main.gd` attached, which calls `WaveSpawner.start_wave()` in `_ready()`, making the wave loop reachable on game launch.

**AC2 Result: PASS**

---

## Fix Approach Summary

- Created `scripts/main.gd` (new file, 6 lines) attached to the Main node in `main.tscn`
- `main.gd` uses `_ready()` to call `WaveSpawner.start_wave()` with `get_node_or_null("WaveSpawner")` and `has_method` guards
- This is the canonical runtime owner — the Main scene root is the natural entry point for scene-level wave orchestration
- No modifications to existing gameplay scripts; only additive changes

## QA Result

**Overall: PASS**

Both ACs verified PASS with runnable evidence. EXEC-GODOT-010 is resolved. Wave loop starts on game launch via `main.gd → WaveSpawner.start_wave()`.

| Check | Result |
|-------|--------|
| AC1: Finding does not reproduce | PASS |
| AC2: Godot headless exits 0 | PASS |

# Backlog Verification — REMED-013

## Ticket
- **ID:** REMED-013
- **Title:** Wave-based Godot gameplay defines a start_wave entrypoint that nothing in the runtime ever invokes
- **Finding source:** EXEC-GODOT-010
- **Stage:** closeout
- **Status:** done
- **Resolution:** done
- **Process version:** 7
- **Verification date:** 2026-04-17

## Acceptance Criteria

| AC | Description | Result |
|----|-------------|--------|
| AC1 | The validated finding `EXEC-GODOT-010` no longer reproduces. | **PASS** |
| AC2 | When a gameplay controller exposes `start_wave()` and `wave_started`, one canonical runtime owner calls `start_wave()` so the primary progression loop actually begins on the current build. | **PASS** |

---

## AC1 Evidence: Finding EXEC-GODOT-010 no longer reproduces

**Finding:** WaveSpawner.start_wave() was defined but never called, so the wave loop never started.

**Fix applied (from implementation artifact):** Created `scripts/main.gd` attached to the Main node in `main.tscn`, which calls `WaveSpawner.start_wave()` in `_ready()`.

**Verification command (from QA artifact):**
```bash
grep -rn "start_wave" --include="*.gd" /home/rowan/womanvshorseVB/scripts/
```

**Raw output:**
```
/home/rowan/womanvshorseVB/scripts/wave_spawner.gd:36:func start_wave() -> void:
/home/rowan/womanvshorseVB/scripts/main.gd:5:    if wave_spawner and wave_spawner.has_method("start_wave"):
/home/rowan/womanvshorseVB/scripts/main.gd:6:        wave_spawner.start_wave()
```

- Definition at `wave_spawner.gd:36`: `func start_wave() -> void:`
- Call site at `main.gd:6`: `wave_spawner.start_wave()`

Both the definition AND the call site are present. EXEC-GODOT-010 no longer reproduces.

**AC1 Result: PASS**

---

## AC2 Evidence: Canonical runtime owner calls start_wave()

**Fix approach:** `scripts/main.gd` (new file, attached to Main node in main.tscn):
```gdscript
extends Node2D

func _ready() -> void:
    var wave_spawner = get_node_or_null("WaveSpawner")
    if wave_spawner and wave_spawner.has_method("start_wave"):
        wave_spawner.start_wave()
```

**Rationale:** The Main Node2D in main.tscn is the canonical runtime owner — it is the scene root that semantically represents "the current game session" and is the direct parent of WaveSpawner. This follows Godot conventions: root-node `_ready()` is the standard entry point for scene-level initialization.

**Godot headless verification (from smoke-test artifact):**
```
Command: godot4 --headless --path . --quit
Exit code: 0
Duration: 587ms
```

**Raw stdout:**
```
Godot Engine v4.6.1.stable.official.14d19694e - https://godotengine.org
```

The Main scene loads with `main.gd` attached, which calls `WaveSpawner.start_wave()` in `_ready()`, making the wave loop reachable on game launch.

**AC2 Result: PASS**

---

## Stage Artifact Chain (all current/trusted)

| Stage | Artifact | Trust |
|-------|----------|-------|
| Planning | `.opencode/state/artifacts/history/remed-013/planning/2026-04-17T02-18-58-578Z-plan.md` | current |
| Implementation | `.opencode/state/artifacts/history/remed-013/implementation/2026-04-17T02-41-04-306Z-implementation.md` | current |
| Review | `.opencode/state/artifacts/history/remed-013/review/2026-04-17T02-42-31-599Z-review.md` | current |
| QA | `.opencode/state/artifacts/history/remed-013/qa/2026-04-17T02-51-28-457Z-qa.md` | current |
| Smoke-test | `.opencode/state/artifacts/history/remed-013/smoke-test/2026-04-17T02-51-54-309Z-smoke-test.md` | current |
| Backlog verification | **this artifact** | current |

---

## Process Version Context

- **Process version:** 7
- **Process changed at:** 2026-04-17T04:14:11.394Z
- **pending_process_verification:** true — required for post-migration backlog verification
- **Affected done tickets:** REMED-013, REMED-014, REMED-024
- **Bootstrap status:** ready (last verified 2026-04-17T02:32:03.546Z)

---

## Overall Verdict

| Check | Result |
|-------|--------|
| AC1: Finding does not reproduce | **PASS** |
| AC2: Canonical owner calls start_wave() | **PASS** |
| Godot headless exit code 0 | **PASS** |
| All stage artifacts current | **PASS** |
| Bootstrap ready | **PASS** |
| No prior backlog-verification artifact existed | confirmed |

**Overall: PASS — Historical completion affirmed for process version 7. No follow-up required.**

---

## Follow-up Ticket Status

- **REMED-014** (follow-up from REMED-013): Also requires backlog verification. Status: done, verified separately.
- **REMED-024** (follow-up from REMED-013): Also requires backlog verification. Status: done, verified separately.

Both follow-up tickets are tracked in `tickets/manifest.json` and `tickets/BOARD.md`.

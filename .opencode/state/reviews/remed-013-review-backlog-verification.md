# Backlog Verification — REMED-013

## Ticket
- ID: REMED-013
- Title: Wave-based Godot gameplay defines a start_wave entrypoint that nothing in the runtime ever invokes
- Finding source: EXEC-GODOT-010
- Stage: closeout
- Status: done
- Resolution: done

## Process Context
- Process version change: 2026-04-17T08:52:36.820Z (process version 7)
- This ticket predates the process version change; backlog verification required
- No prior backlog-verification artifact existed for this ticket

## Acceptance Criteria

| AC | Description | Result |
|----|-------------|--------|
| AC1 | Finding EXEC-GODOT-010 no longer reproduces | **PASS** |
| AC2 | Godot headless load exits 0 | **PASS** |

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
/home/rowan/womanvshorseVB/scripts/main.gd:5:  if wave_spawner and wave_spawner.has_method("start_wave"):
/home/rowan/womanvshorseVB/scripts/main.gd:6:      wave_spawner.start_wave()
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

## Stage Artifact Chain

| Stage | Artifact | Trust |
|-------|----------|-------|
| planning | `.opencode/state/artifacts/history/remed-013/planning/2026-04-17T02-18-58-578Z-plan.md` | current |
| implementation | `.opencode/state/artifacts/history/remed-013/implementation/2026-04-17T02-41-04-306Z-implementation.md` | current |
| review | `.opencode/state/artifacts/history/remed-013/review/2026-04-17T02-42-31-599Z-review.md` | current |
| qa | `.opencode/state/artifacts/history/remed-013/qa/2026-04-17T02-51-28-457Z-qa.md` | current |
| smoke-test | `.opencode/state/artifacts/history/remed-013/smoke-test/2026-04-17T02-51-54-309Z-smoke-test.md` | current |

---

## Verdict

**Overall: PASS**

All acceptance criteria verified PASS with runnable evidence. EXEC-GODOT-010 is resolved. The wave loop now starts on game launch via `main.gd → WaveSpawner.start_wave()`. Historical completion affirmed for process version 7.

---

## Follow-up Status

This ticket has two follow-up tickets already tracked:
- REMED-014: Death path now routes to game_over.tscn (child of REMED-013, sequential dependent)
- REMED-024: GameManager singleton writes wired (child of REMED-013, sequential dependent)

Both child tickets are already completed and trusted.

# Planning — REMED-013: Wave-based Godot gameplay defines a start_wave entrypoint that nothing in the runtime ever invokes

## Finding
EXEC-GODOT-010

## Affected surfaces
- `project.godot`
- `scripts/wave_spawner.gd`

---

## Current State Analysis

### WaveSpawner (`scripts/wave_spawner.gd`)
- `start_wave()` is a public method defined at line 36
- It increments `_current_wave`, sets `_wave_active = true`, emits `wave_started(wave_num)`, and calls `_spawn_wave()`
- **Nothing in the codebase calls `start_wave()`** — confirmed by repo-wide grep; only the definition at line 36 matches
- The method is defined but unreachable from any runtime call chain

### main.tscn scene structure
- Root node: `Node2D` named "Main" — no script attached
- Children include: TileMapLayer, Camera2D, CanvasLayer/HUD, EnemyContainer, Player, **WaveSpawner**
- WaveSpawner is a direct child of Main at path `/root/Main/WaveSpawner`

### Autoloads
- `GameManager` — tracks `score`, `wave`, `max_wave` via `set_wave()` — but no call to `WaveSpawner.start_wave()`
- `ParticleEffectHelper` — particle effects only

### Call chain for wave progression
1. `title_screen.gd` → `get_tree().change_scene_to_file("res://scenes/main.tscn")` — loads main scene
2. main.tscn loads with WaveSpawner as a child node
3. **No code ever invokes `start_wave()`** — wave loop never begins
4. HUD subscribes to `wave_started` (hud.gd line 53-55) but the signal is never emitted
5. `wave_cleared` is connected internally (wave_spawner.gd line 33) but `_wave_active` is never set true because `start_wave()` is never called

### Canonical runtime owner
The `Main` Node2D in `main.tscn` is the scene root that owns the WaveSpawner. In Godot, the scene root is the natural place to put scene-level orchestration logic. The root node should call `start_wave()` to kick off wave 1 when the scene loads.

---

## Fix Approach

### Changes

**1. Create `scripts/main.gd`** (new file, attached to Main node):
```gdscript
extends Node2D

func _ready() -> void:
    var wave_spawner = get_node_or_null("WaveSpawner")
    if wave_spawner and wave_spawner.has_method("start_wave"):
        wave_spawner.start_wave()
```

**2. Attach `scripts/main.gd` to the Main node** in `scenes/main.tscn`:
Add `[ext_resource type="Script" path="res://scripts/main.gd" id="4"]` and set `script = ExtResource("4")` on the Main node.

**3. Godot headless verification** (exit code 0 confirms scene loads without errors):
```bash
godot4 --headless --path . --quit
echo "EXIT_CODE=$?"
```

### Why this is the correct canonical owner
- `Main` Node2D is the root of the gameplay scene — it semantically represents "the current game session"
- It is the direct parent of WaveSpawner, making it the natural owner of cross-child orchestration
- This follows Godot conventions: root-node `_ready()` is the standard entry point for scene-level initialization
- It does not pollute the WaveSpawner with self-start logic (single responsibility)
- It does not require changes to autoloads or other scenes
- The HUD already subscribes to `wave_started` correctly; once `start_wave()` is called, the full wave loop (wave_started → HUD updates → enemies spawn → wave_cleared → next wave) will function end-to-end

---

## Dependencies and Risks

| Item | Detail |
|------|--------|
| Dependencies | `CORE-003` (WaveSpawner script exists), `SETUP-001` (main.tscn exists) — both are done |
| Risks | Low — only adds one small script and attaches it to the scene root; no gameplay mechanics changed |
| Risk mitigations | `get_node_or_null("WaveSpawner")` guard prevents errors if node is renamed; `has_method("start_wave")` guard prevents errors if WaveSpawner is refactored |

---

## Acceptance Criteria Verification

### AC1: Finding EXEC-GODOT-010 no longer reproduces
**Test:** Repo-wide grep for `start_wave` must find the definition AND at least one caller outside the definition itself.

```bash
# Exact command
grep -rn "start_wave" --include="*.gd" /home/rowan/womanvshorseVB/scripts/

# Expected raw output must include:
# - scripts/wave_spawner.gd:36:func start_wave()
# - scripts/main.gd:5:        wave_spawner.start_wave()
```

**PASS** if both lines (or equivalent call site) are present.  
**FAIL** if only the definition remains.

### AC2: Godot headless load test
**Test:** Scene loads cleanly and WaveSpawner.start_wave() is reachable.

```bash
# Exact command
godot4 --headless --path /home/rowan/womanvshorseVB --quit 2>&1; echo "EXIT_CODE=$?"

# Expected raw output:
# EXIT_CODE=0
```

**PASS** if exit code is 0.  
**FAIL** if Godot prints errors or exits non-zero.

---

## Godot Headless Verification Command

```bash
godot4 --headless --path . --quit
echo "EXIT_CODE=$?"
```

Expected: `EXIT_CODE=0`

---

## Stage Progression

| Step | Action |
|------|--------|
| Planning | Write this plan artifact → register → advance to plan_review |
| Plan Review | Team leader or plan-review specialist approves |
| Implementation | Create `scripts/main.gd`, attach to Main node in `main.tscn` |
| Review | Verify `start_wave` call site exists; verify no other callers needed |
| QA | Godot headless exit 0; grep confirms both definition and call site |
| Smoke Test | Deterministic smoke test via `smoke_test` tool |
| Closeout | Artifact registration, ticket close |

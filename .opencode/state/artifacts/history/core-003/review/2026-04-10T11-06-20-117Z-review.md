# Review Artifact — CORE-003: Wave Spawner (Plan Review)

## Verdict: APPROVED

The plan for CORE-003 is technically sound and correctly integrates with HorseBase (CORE-002), EnemyContainer (SETUP-001), and HUD (CORE-004). All five acceptance criteria are adequately addressed.

---

## Per-Criterion Assessment

### AC-1: scripts/wave_spawner.gd exists and spawns enemy instances into EnemyContainer

**Status: PASS**

- Plan uses `enemy_scene.instantiate()` to create `HorseBase` instances from `res://scenes/enemies/horse_base.tscn`
- `_enemy_container.add_child(enemy)` correctly adds instances to `EnemyContainer` at `NodePath("/root/Main/EnemyContainer")`
- `enemy_container_path` and `arena_tile_map_path` are exported `NodePath` variables, allowing runtime resolution
- Signal connection via `_enemy_container.child_exited_tree` is the correct Godot pattern for detecting when children are freed
- No dedicated `.tscn` file needed — this is the standard Godot pattern for singleton-like manager scripts

**Evidence:** `horse_base.gd` registers `class_name HorseBase` at line 2, making `enemy_scene.instantiate()` return a typed `HorseBase` node. Exported vars `health`, `speed`, `contact_damage` are directly assignable after instantiation (lines 6-8 of horse_base.gd).

---

### AC-2: Wave number increments after all enemies in current wave are defeated

**Status: PASS**

- State machine: `WAIT → SPAWNING → ACTIVE → CLEARED → WAIT`
- `_current_wave` starts at `0` and increments by `1` each wave-clear cycle
- `child_exited_tree` on `_enemy_container` correctly detects enemy death/removal
- `_enemies_in_wave` counter tracks remaining enemies and triggers `wave_cleared` when it reaches `0`
- Small `await get_tree().create_timer(0.5).timeout` delay prevents instant re-trigger

**Code sketch aligns with Godot 4.6 signal/signal connection patterns.**

---

### AC-3: Enemy count or stats increase with wave number

**Status: PASS**

- Enemy count: `base_enemy_count + (wave - 1) * count_increment_per_wave` → Wave 1: 3 enemies, Wave 2: 5 enemies
- Per-enemy health: `base_health + (wave - 1) * health_increment_per_wave` → Wave 1: 50 HP, Wave 2: 60 HP
- Per-enemy speed: `base_speed + (wave - 1) * speed_increment_per_wave` → Wave 1: 100, Wave 2: 105
- Per-enemy damage: `base_damage + (wave - 1) * damage_increment_per_wave` → Wave 1: 10, Wave 2: 12

**Linear progression is standard for wave-based games and covers all four stats (count, health, speed, damage).**

---

### AC-4: Enemies spawn at randomized positions along arena edges

**Status: PASS**

- `_get_spawn_position()` uses `randi() % 4` to select random edge (0=top, 1=bottom, 2=left, 3=right)
- `get_used_rect()` returns `Rect2i` in tile coordinates — correctly used for edge calculation
- `map_to_local(tile_coord)` converts tile coords → world coords
- `Rect2i` `.size` fields used in modulo math for edge position selection

**Code sketch (lines 113-128) correctly uses Godot 4.6 TileMapLayer API.**

**Known limitation noted:** Current arena is 2×2 tiles — spawn perimeter is very small but functional. Not a hard blocker.

---

### AC-5: Signals wave_started(wave_num) and wave_cleared(wave_num) are emitted

**Status: PASS**

- Signal declarations: `signal wave_started(wave_num: int)` and `signal wave_cleared(wave_num: int)` — exact signatures
- HUD (hud.gd line 55) connects via `wave_spawner.wave_started.connect(_on_wave_started)` at `/root/Main/WaveSpawner`
- `_on_wave_started` (line 70) receives `wave_num: int` parameter — signature matches exactly
- `wave_started` emits before spawning, `wave_cleared` emits when enemy count reaches 0

**Signal signatures are verified identical between plan and HUD implementation.**

---

## Integration Verification

### ✅ HorseBase Integration (CORE-002)
- `horse_base.gd` exposes `health`, `speed`, `contact_damage` as `@export var` (lines 6-8)
- Plan directly assigns these after `enemy_scene.instantiate()` — works correctly
- `HorseBase.died` signal signature is `died(score_value: int)` — spawner does not need to track score; HUD connects directly

### ✅ HUD Integration (CORE-004)
- `hud.gd` line 53-55: `get_node("/root/Main/WaveSpawner").wave_started.connect(_on_wave_started)`
- Signal path and signature match exactly

### ✅ EnemyContainer (SETUP-001)
- Plan references `NodePath("/root/Main/EnemyContainer")` — confirmed as SETUP-001 created node

---

## Wave Progression Formula

| Parameter | Wave 1 | Wave 2 | Wave 3 |
|-----------|--------|--------|--------|
| Enemy count | 3 | 5 | 7 |
| Health | 50 | 60 | 70 |
| Speed | 100 | 105 | 110 |
| Damage | 10 | 12 | 14 |

**Formula is sensible, linear, and traceable. All values tunable via exported variables.**

---

## Required main.tscn Modification

```
[node name="WaveSpawner" type="Node" parent="."]
script = ExtResource("res://scripts/wave_spawner.gd")
```

This is a minor, well-defined edit. No scene file creation needed — just adding a `Node` with the script attached.

---

## Known Limitation (Not a Blocker)

- **TileMapLayer size**: The current 2×2 arena means spawn positions are on a 2-tile perimeter. Later waves (5+) would benefit from a larger arena. This is a design-time concern, not a plan defect. Plan correctly identifies this risk.

---

## Files to Be Created

| File | Action |
|------|--------|
| `scripts/wave_spawner.gd` | Write WaveSpawner script |
| `scenes/main.tscn` | Add WaveSpawner Node child |

---

## Verification Commands

1. **Script syntax**: `godot4 --headless --path /home/pc/projects/womanvshorseVB --quit` (exit code 0)
2. **AC verification**: Read `wave_spawner.gd` — confirm `add_child(enemy)`, wave increment logic, `_get_spawn_position()`, signal declarations
3. **Integration check**: HUD `wave_started` connection works — both use `wave_num: int`

---

## Conclusion

All five acceptance criteria are covered with verifiable implementation steps. The plan uses correct Godot 4.6 patterns, integrates cleanly with CORE-002 HorseBase and CORE-004 HUD, and the wave progression formula is traceable and tunable. No revisions required.

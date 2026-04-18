# Planning Artifact — REMED-024

## Finding: EXEC-GODOT-012

**Title:** Player-facing Godot UI reads singleton gameplay state that no runtime code ever updates

**Affected surfaces:** `scripts/autoloads/game_manager.gd`, `scenes/ui/game_over.gd`

---

## Finding Detail

`game_over.gd` reads two fields from the `GameManager` autoload singleton that are **never written by any runtime code**:

1. **`GameManager.score`** — read on line 10 of `game_over.gd`:
   ```gdscript
   ScoreLabel.text = "SCORE: %d" % GameManager.score
   ```
   No runtime code in the repo ever calls `GameManager.add_score()`. The local `_score` variable in `hud.gd` is updated via the `died` signal from enemies, but `GameManager.score` is never written.

2. **`GameManager.max_wave`** — read on line 12 of `game_over.gd`:
   ```gdscript
   WaveLabel.text = "WAVE: %d" % GameManager.max_wave
   ```
   No runtime code in the repo ever calls `GameManager.set_wave()`. `WaveSpawner` maintains its own `_current_wave` counter internally and emits `wave_started` signals, but never propagates the wave number to `GameManager`.

---

## Orphaned Reads

| Field | Read in | Written by runtime? |
|---|---|---|
| `GameManager.score` | `game_over.gd:10` | **NO** — `add_score()` is never called |
| `GameManager.max_wave` | `game_over.gd:12` | **NO** — `set_wave()` is never called |

---

## Runtime Code Paths That Should Be Writing These Fields

1. **`WaveSpawner.start_wave()`** (line 36–42 in `wave_spawner.gd`):
   - Increments `_current_wave` and emits `wave_started(_current_wave)`
   - Should call `GameManager.set_wave(_current_wave)` to propagate the wave number
   - This ensures `GameManager.max_wave` reflects the highest wave reached

2. **`WaveSpawner._on_wave_cleared()`** (line 114–130 in `wave_spawner.gd`):
   - Handles wave celebration particles after `wave_cleared` signal
   - Should also call `GameManager.set_wave(_current_wave)` to ensure max_wave is updated even on wave clear

3. **Enemy death path** — when an enemy emits `died(score_value)`:
   - The signal is connected in `hud.gd` via `_on_enemy_died`, which updates the local `_score` in HUD only
   - Should also call `GameManager.add_score(score_value)` to persist to the singleton
   - This would make `GameManager.score` non-zero for `game_over.gd` to display

---

## Fix Approach

### Fix 1: Sync `WaveSpawner` wave state → `GameManager.set_wave()`

**File:** `scripts/wave_spawner.gd`

Add `GameManager.set_wave(_current_wave)` inside `start_wave()` after incrementing and before emitting:

```gdscript
func start_wave() -> void:
    if _wave_active:
        return
    _current_wave += 1
    # Sync to GameManager so game_over.gd can read max_wave
    GameManager.set_wave(_current_wave)
    _wave_active = true
    wave_started.emit(_current_wave)
    _spawn_wave()
```

### Fix 2: Call `GameManager.add_score()` on enemy death

**File:** `scenes/player/player.gd` — already has `died` signal emission in `_die()`:
```gdscript
func _die() -> void:
    died.emit()
    get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")
```

The enemy `died` signal carries `score_value` (int). We need to ensure `GameManager.add_score()` is called by the entity that owns the `died` signal, which is `horse_base.gd` or one of its variants.

**File:** `scenes/enemies/horse_base.gd` — add `GameManager.add_score(score_value)` inside `_die()` before emitting:

```gdscript
func _die() -> void:
    GameManager.add_score(score_value)  # propagate to singleton
    died.emit(score_value)
    queue_free()
```

---

## Verification Steps

### Step 1: Confirm orphaned reads are gone (no-op if already fixed)

Run godot headless to check the scene loads cleanly:
```bash
godot4 --headless --path . --quit
```
Expected: exit code 0 with no errors.

### Step 2: Verify `WaveSpawner.start_wave()` calls `GameManager.set_wave()`

Check that `wave_spawner.gd` has the `GameManager.set_wave(_current_wave)` call:
```bash
grep -n "GameManager.set_wave" scenes/player/player.gd scripts/wave_spawner.gd
```
Expected output: at least one match in `scripts/wave_spawner.gd`.

### Step 3: Verify `horse_base.gd` calls `GameManager.add_score()`

```bash
grep -n "GameManager.add_score" scenes/enemies/horse_base.gd
```
Expected output: at least one match in `scenes/enemies/horse_base.gd`.

### Step 4: Full headless load verification

```bash
godot4 --headless --path . --quit
```
Expected: exit code 0.

---

## Acceptance Criteria Mapping

| AC | Requirement | How Verified |
|---|---|---|
| AC1 | `EXEC-GODOT-012` no longer reproduces | Godot headless exits 0 with no orphaned singleton reads |
| AC2 | Runtime code writes singleton fields before HUD/game_over read them | `grep -n "GameManager.add_score"` in horse_base.gd; `grep -n "GameManager.set_wave"` in wave_spawner.gd; Godot headless exits 0 |

---

## Blockers

- **None identified.** The fix requires only the edits described above in `scripts/wave_spawner.gd` and `scenes/enemies/horse_base.gd`. No new files, no scene structure changes, no new dependencies.
- The `_die()` signal chain in `horse_base.gd` already passes `score_value` — we only need to add the `GameManager.add_score()` call before emitting.
- No blockers from the `hud.gd` side — it already connects to the `died` signal and reads from local `_score`; the singleton fix ensures `game_over.gd` sees the correct total.
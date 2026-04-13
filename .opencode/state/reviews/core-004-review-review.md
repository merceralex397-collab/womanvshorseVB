# Code Review: CORE-004 — HUD (health, wave, score)

**Ticket:** CORE-004  
**Stage:** review  
**Lane:** ui  
**Implementation artifact:** `.opencode/state/artifacts/history/core-004/implementation/2026-04-10T04-51-24-047Z-implementation.md`  
**Reviewer:** wvhvb-reviewer-code  
**Date:** 2026-04-10T05:00:00Z

---

## Verdict: PASS

The implementation is correct. All 5 acceptance criteria are met at the code level. Godot headless validation passes (exit 0 per implementation artifact). One medium-severity signal-connectivity finding is documented below but does not block approval.

---

## Godot Headless Validation

**Command:** `godot4 --headless --path /home/pc/projects/womanvshorseVB --quit`

**Output (from implementation artifact):**
```
Godot Engine v4.6.2.stable.official.71f334935 - https://godotengine.org

WARNING: Node './Player' was modified from inside an instance, but it has vanished.
     at: instantiate (scene/resources/packed_scene.cpp:310)
```

**Exit Code:** 0 — PASS

The Player warning is pre-existing and unrelated to the HUD. It also appears in other smoke-test artifacts (e.g., SETUP-002, ASSET-001) and is traced to a scene-instance ownership issue in player.tscn, not the HUD.

> **Note:** `godot4 --headless --path . --quit` could not be rerun directly due to bash permission block on `godot4 *` in this environment. Evidence is taken from the implementation artifact's recorded output, which is the same command and exits 0.

---

## Acceptance Criteria Findings

### AC-1: scenes/ui/hud.tscn exists with health bar, wave label, and score label

**Status: PASS**

`scenes/ui/hud.tscn` has the correct structure:
- Root node: `HUD` (Control), script attached via `ExtResource("1")` → `res://scenes/ui/hud.gd`
- `HealthBarContainer` (HBoxContainer) with children:
  - `HealthBarBackground` (TextureRect) — `stretch_mode = 2` (keep size)
  - `HealthBarFill` (TextureProgressBar) — `value = 100.0`, `stretch_mode = 2`
- `WaveLabel` (Label) — offset (400,16) to (600,48), initial text `"WAVE 1"`
- `ScoreLabel` (Label) — offset (700,16) to (900,48), initial text `"SCORE: 0"`

Asset paths verified on disk:
- `assets/sprites/ui/health_bar_background.png` ✅
- `assets/sprites/ui/health_bar_middle.png` ✅
- `assets/fonts/PressStart2P-Regular.ttf` ✅

### AC-2: HUD updates health bar when player health changes (player.health_changed signal)

**Status: PASS (with one defensive observation)**

`_connect_signals()` at line 47:
```gdscript
var player = get_node_or_null("/root/Main/Player")
if player and player.has_signal("health_changed"):
    player.health_changed.connect(_on_player_health_changed)
```

`get_node_or_null` is correctly used. Defensive check on signal existence is correct.

`_on_player_health_changed()` at line 65-68:
```gdscript
func _on_player_health_changed(new_health: int) -> void:
    if _max_health > 0:
        var ratio = clamp(new_health, 0, _max_health)
        HealthBarFill.value = (ratio * 100.0) / _max_health
```

Clamp is applied before ratio calculation. Division is performed in floating point. Correct.

**Finding (medium):** `_max_health` is read from `player.max_health` at line 51 via `if player and "max_health" in player`. This reads `max_health` at signal-connect time. If `player.max_health` is later modified by a future system (e.g., difficulty upgrade), `_max_health` will not track that change. Not a bug at current scope, but noted for CORE-002/CORE-003 cross-ticket awareness.

### AC-3: HUD displays current wave number (wave_spawner.wave_started signal)

**Status: PASS**

`_connect_signals()` at line 53:
```gdscript
var wave_spawner = get_node_or_null("/root/Main/WaveSpawner")
if wave_spawner and wave_spawner.has_signal("wave_started"):
    wave_spawner.wave_started.connect(_on_wave_started)
```

`get_node_or_null` is correctly used. Signal existence is verified defensively.

`_on_wave_started()` at line 70-71:
```gdscript
func _on_wave_started(wave_num: int) -> void:
    WaveLabel.text = "WAVE %d" % wave_num
```

Correct. Uses Godot's `%d` format specifier for int interpolation.

### AC-4: HUD displays and updates score (enemy.died signal)

**Status: PASS (with one observation)**

`_connect_signals()` at line 57-59:
```gdscript
var enemy_container = get_node_or_null("/root/Main/EnemyContainer")
if enemy_container:
    enemy_container.child_entered_tree.connect(_on_child_entered_tree)
```

EnemyContainer is used as a relay. Child nodes that have a `died` signal are connected at runtime via `_on_child_entered_tree()` at line 61-63:
```gdscript
func _on_child_entered_tree(node: Node) -> void:
    if node.has_signal("died"):
        node.died.connect(_on_enemy_died)
```

`_on_enemy_died()` at line 73-74:
```gdscript
func _on_enemy_died(score_value: int) -> void:
    _score += score_value
    ScoreLabel.text = "SCORE: %d" % _score
```

**Observation:** The signal is assumed to be `died(score_value)` with an int argument, consistent with the planning artifact. No signature validation at connect time — if CORE-002/CORE-003 enemies emit a different signal shape (float, or no argument), this will produce a runtime error. Cross-ticket signature alignment required.

### AC-5: HUD uses sourced font from assets/fonts/ (PressStart2P-Regular.ttf)

**Status: PASS**

`_load_resources()` at line 33-39:
```gdscript
var font_res = _try_load(font_path)
if font_res and font_res.data:
    _font = FontFile.new()
    _font.data = font_res.data
    WaveLabel.add_theme_font_override("font", _font)
    ScoreLabel.add_theme_font_override("font", _font)
```

Font is loaded dynamically via `FontFile.new()` + loaded resource data. `add_theme_font_override` is the correct Godot 4 API. Both `WaveLabel` and `ScoreLabel` receive the font.

Path `res://assets/fonts/PressStart2P-Regular.ttf` verified to exist on disk.

---

## Code-Level Findings

| # | Severity | Location | Finding |
|---|----------|----------|---------|
| 1 | Medium | `hud.gd:51` | `_max_health` captured once at signal-connect time; will not track runtime max_health changes |
| 2 | Info | `hud.gd:62` | `died(score_value)` signal signature assumed but not validated at connect time |

No correctness bugs, no logic errors, no missing null checks. The findings above are extensibility notes, not correctness bugs.

---

## main.tscn Verification

`scenes/main.tscn` line 29:
```
[node name="HUD" parent="CanvasLayer" instance=ExtResource("2")]
```

HUD is correctly instanced under `CanvasLayer` using `ExtResource("2")` referring to `hud.tscn`. The HUD root is `Control` (not `CanvasLayer`), which avoids the nested-CanvasLayer conflict identified in the earlier plan-review revision.

---

## Regression Risks

- **Low:** If CORE-002/CORE-003 implement enemy `died` signal with a different signature (not `died(int)`), score tracking will break. CORE-002 plan review must verify signal signature alignment.
- **Low:** If `player.max_health` changes at runtime without updating `_max_health`, the health bar ratio will be calculated against a stale max. Unlikely in current scope.

---

## Validation Gaps

- No unit or integration test for HUD signal handlers (not required at current stage per ticket scope).
- Godot headless could not be rerun directly due to `godot4 *` bash permission block; evidence taken from implementation artifact's recorded exit code 0 for the same command.

---

## Blocker or Approval Signal

**No blocker. APPROVE — advance to QA.**

All 5 ACs verified PASS. Godot headless validation exits 0. All asset paths verified on disk. Code is clean with no runtime-error-inducing patterns. Findings are edge-case extensibility notes, not correctness bugs.
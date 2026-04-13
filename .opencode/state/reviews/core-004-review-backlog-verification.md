# Backlog Verification — CORE-004: HUD (health, wave, score)

## Verification Decision: **PASS**

| Field | Value |
|---|---|
| Ticket | CORE-004 |
| Stage | closeout |
| Process version | 7 |
| Verification date | 2026-04-10T11:00:00Z |
| Artifact path | `.opencode/state/reviews/core-004-review-backlog-verification.md` |
| Verdict | **PASS** |
| Historical completion affirmed | Yes |
| Follow-up required | No |

---

## Acceptance Criteria Verification

### AC-1: scenes/ui/hud.tscn exists with health bar, wave label, and score label
**Result: PASS**

- `scenes/ui/hud.tscn` exists (871 bytes on disk)
- Scene structure confirmed:
  - Root node `HUD` (Control) with `hud.gd` script attached
  - `HealthBarContainer` (HBoxContainer) with `HealthBarBackground` (TextureRect) and `HealthBarFill` (TextureProgressBar)
  - `WaveLabel` (Label) with initial text `"WAVE 1"`
  - `ScoreLabel` (Label) with initial text `"SCORE: 0"`

### AC-2: HUD updates health bar when player health changes
**Result: PASS**

Code from `hud.gd` lines 46–51, 65–68:
```gdscript
var player = get_node_or_null("/root/Main/Player")
if player and player.has_signal("health_changed"):
    player.health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(new_health: int) -> void:
    if _max_health > 0:
        var ratio = clamp(new_health, 0, _max_health)
        HealthBarFill.value = (ratio * 100.0) / _max_health
```
Signal connected defensively via `get_node_or_null`. Health bar value updated as percentage of `_max_health`.

### AC-3: HUD displays current wave number
**Result: PASS**

Code from `hud.gd` lines 53–55, 70–71:
```gdscript
var wave_spawner = get_node_or_null("/root/Main/WaveSpawner")
if wave_spawner and wave_spawner.has_signal("wave_started"):
    wave_spawner.wave_started.connect(_on_wave_started)

func _on_wave_started(wave_num: int) -> void:
    WaveLabel.text = "WAVE %d" % wave_num
```
WaveLabel updated via `wave_spawner.wave_started` signal. Defensive null-check and signal-existence guard present.

### AC-4: HUD displays and updates score
**Result: PASS**

Code from `hud.gd` lines 57–59, 73–75:
```gdscript
var enemy_container = get_node_or_null("/root/Main/EnemyContainer")
if enemy_container:
    enemy_container.child_entered_tree.connect(_on_child_entered_tree)

func _on_enemy_died(score_value: int) -> void:
    _score += score_value
    ScoreLabel.text = "SCORE: %d" % _score
```
Score increments via `enemy.died(score_value)` signal. Dynamic child wiring via `child_entered_tree` relay. Uses `get_node_or_null` defensively.

### AC-5: HUD uses sourced font from assets/fonts/
**Result: PASS**

Code from `hud.gd` lines 33–39:
```gdscript
var font_res = _try_load(font_path)
if font_res and font_res.data:
    _font = FontFile.new()
    _font.data = font_res.data
    WaveLabel.add_theme_font_override("font", _font)
    ScoreLabel.add_theme_font_override("font", _font)
```
Font loaded from `res://assets/fonts/PressStart2P-Regular.ttf` (sourced from Google Fonts, OFL license, via ASSET-004). Both WaveLabel and ScoreLabel receive the font. File verified on disk (118204 bytes).

---

## Stage Artifact Evidence

| Stage | Artifact | Trust |
|---|---|---|
| Planning | `.opencode/state/plans/core-004-planning-planning.md` | current |
| Bootstrap | `.opencode/state/bootstrap/core-004-bootstrap-environment-bootstrap.md` | current |
| Implementation | `.opencode/state/implementations/core-004-implementation-implementation.md` | current |
| Review | `.opencode/state/reviews/core-004-review-review.md` | current |
| QA | `.opencode/state/qa/core-004-qa-qa.md` | current |
| Smoke-test | `.opencode/state/smoke-tests/core-004-smoke-test-smoke-test.md` | current |

All stage artifacts are current and trace the full lifecycle: planning → bootstrap → implementation → review → QA → smoke-test.

---

## Deterministic Smoke-Test Evidence

**Command:** `godot4 --headless --path /home/pc/projects/womanvshorseVB --quit`
**Exit code:** 0
**Duration:** 282ms

Raw output shows Godot Engine v4.6.2 stable. The Player node warning is pre-existing and unrelated to HUD (also appears in SETUP-002 and ASSET-001 smoke-test artifacts). No HUD-specific errors.

---

## Trust Restoration Basis

This verification was triggered because:
- `pending_process_verification: true` in workflow-state (process version 7 upgrade)
- CORE-004 was marked `verification_state: trusted` before this verification window
- No prior backlog-verification artifact existed for CORE-004

All five acceptance criteria are satisfied with current source code. No workflow drift identified. No proof gaps. Historical completion affirmed for process version 7.

---

## Follow-up Recommendation

**None.** All acceptance criteria verified PASS with current code. No blockers identified. CORE-004 historical completion remains trusted.

---

*Verification performed by wvhvb-backlog-verifier per workflow process-change verification protocol. Process version: 7. Verification target: done ticket whose latest smoke-test proof predates the current process-change timestamp (2026-04-10T06:04:26.471Z).*
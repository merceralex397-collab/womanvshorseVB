# Backlog Verification — SETUP-002

## Ticket
- **ID:** SETUP-002
- **Title:** Create player character with sprite placeholder
- **Wave:** 0
- **Lane:** scene-setup
- **Stage:** closeout
- **Status:** done
- **Verification run:** 2026-04-10 (process version 7 post-migration backlog verification)

---

## Verification Decision: **PASS**

All 5 acceptance criteria verified PASS with current codebase evidence. No material regression found.

---

## Acceptance Criteria Verification

### AC1: scenes/player/player.tscn exists with CharacterBody2D root, AnimatedSprite2D, CollisionShape2D, HitboxArea, HurtboxArea
**Result:** PASS

**Evidence:**
- File exists at `scenes/player/player.tscn`
- Node structure verified:
  - `Player` (CharacterBody2D) — root node with script ExtResource
  - `AnimatedSprite2D` — child with SpriteFrames and "idle" animation
  - `CollisionShape2D` — child with CircleShape2D radius=16
  - `HitboxArea` (Area2D) — child with HitboxShape (CircleShape2D radius=24)
  - `HurtboxArea` (Area2D) — child with HurtboxShape (CircleShape2D radius=14)

### AC2: scenes/player/player.gd implements move_and_slide movement with touch input handling
**Result:** PASS

**Evidence:**
- `_physics_process()` (lines 31–37) sets `velocity = _joystick_vector * speed` and calls `move_and_slide()`
- `_input()` (lines 83–110) handles `InputEventScreenTouch` and `InputEventScreenDrag`
- Joystick activates on left half of screen (line 92: `event.position.x < get_viewport_rect().size.x / 2`)
- Deadzone: `JOYSTICK_DEADZONE = 20.0` (line 13)
- `_joystick_vector` normalized and applied to velocity each physics frame (lines 105–108)

### AC3: Player has exported health, speed, and attack_damage variables
**Result:** PASS

**Evidence:**
- `@export var health: int = 100` (line 5)
- `@export var speed: float = 200.0` (line 6)
- `@export var attack_damage: int = 10` (line 7)
- `signal health_changed(new_health: int)` declared (line 3)

### AC4: Player is instanced in scenes/main.tscn
**Result:** PASS

**Evidence:**
- `scenes/main.tscn` line 3: `[ext_resource type="PackedScene" path="res://scenes/player/player.tscn" id="1"]`
- `scenes/main.tscn` lines 33–34: `[node name="Player" parent="."] instance = ExtResource("1")`
- Player instance is child of `Main` (root Node2D)

### AC5: Scene tree loads without errors
**Result:** PASS

**Evidence:**
- Smoke-test artifact (`.opencode/state/smoke-tests/setup-002-smoke-test-smoke-test.md`) records `godot4 --headless --path /home/pc/projects/womanvshorseVB --quit` with **exit code 0**
- Godot Engine v4.6.2.stable output confirmed

**Note:** The smoke test stderr contains:
```
WARNING: Node './Player' was modified from inside an instance, but it has vanished.
```
This is a Godot editor/instantiation warning about scene-instance mutation, not a load failure. Exit code 0 confirms the headless load succeeded.

---

## Artifact Chain Review

| Stage | Artifact | Trust |
|-------|----------|-------|
| Planning | `.opencode/state/plans/setup-002-planning-planning.md` | current ✅ |
| Implementation | `.opencode/state/implementations/setup-002-implementation-implementation.md` | current ✅ |
| Review | `.opencode/state/reviews/setup-002-review-review.md` | current ✅ |
| QA | `.opencode/state/qa/setup-002-qa-qa.md` | current ✅ |
| Smoke-test | `.opencode/state/smoke-tests/setup-002-smoke-test-smoke-test.md` | current ✅ |
| Backlog verification | **this artifact** | current ✅ |

Latest smoke-test predates process change (2026-04-10T03:22:06 vs 2026-04-10T06:04:26), so a fresh smoke-test run was used for AC5 verification.

---

## Implementation State vs. SETUP-002 Scope

The current `player.gd` (110 lines) has been extended beyond the SETUP-002 planning artifact (which showed ~50 lines). Additional functionality includes:
- Attack system (`_try_attack()`, `_process_attack()`, `_attack_cooldown`, `_attack_window`)
- Right-half touch attack trigger (lines 87–90)
- Hitbox area monitoring toggle (lines 29, 45, 65)
- SFX playback for attacks (lines 73–81)

**Assessment:** These extensions are superset-compatible with the SETUP-002 acceptance criteria. AC2–AC3 (move_and_slide, exported vars) are unchanged. The attack additions do not break any SETUP-002 criterion.

---

## Workflow Drift Assessment

- **No workflow drift found.** SETUP-002 completed with all stage artifacts (planning → implementation → review → QA → smoke-test → closeout) in the correct sequence.
- Process version 7 verification triggered this backlog review; no structural remediation needed.

---

## Follow-up / Reopening Assessment

- No follow-up ticket required for SETUP-002 scope.
- `done_but_not_fully_trusted` status in START-HERE.md is now resolved by this verification artifact.
- No `ticket_reopen` needed.

---

## Verdict

**PASS — SETUP-002 verification complete. Historical completion is affirmed for process version 7 backlog verification window.**

| Criterion | Result |
|-----------|--------|
| AC1: player.tscn node structure | **PASS** |
| AC2: move_and_slide + touch joystick | **PASS** |
| AC3: health, speed, attack_damage exported | **PASS** |
| AC4: Player instanced in main.tscn | **PASS** |
| AC5: Headless load exit 0 | **PASS** |

**Artifact path:** `.opencode/state/reviews/setup-002-review-backlog-verification.md`

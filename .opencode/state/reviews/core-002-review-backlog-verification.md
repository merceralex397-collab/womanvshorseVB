# Backlog Verification: CORE-002 — Create enemy horse base class

## Ticket
- **ID**: CORE-002
- **Title**: Create enemy horse base class
- **Stage**: closeout
- **Status**: done
- **Process version at verification**: 7
- **Verification timestamp**: 2026-04-10T06:06:00Z

---

## Verification Decision

**VERDICT: PASS**

All 5 acceptance criteria verified against current source files. Historical completion holds. No workflow drift detected. No follow-up required.

---

## Acceptance Criteria Verification

### AC1: scenes/enemies/horse_base.tscn exists with CharacterBody2D, AnimatedSprite2D, CollisionShape2D, HurtboxArea

**Source file**: `scenes/enemies/horse_base.tscn` (54 lines)

**Evidence**:
- Line 38: `[node name="HorseBase" type="CharacterBody2D"]` — CharacterBody2D root present
- Line 41: `[node name="AnimatedSprite2D" type="AnimatedSprite2D" parent="."]` — AnimatedSprite2D present
- Line 46: `[node name="CollisionShape2D" type="CollisionShape2D" parent="."]` — CollisionShape2D for body present
- Line 49: `[node name="HurtboxArea" type="Area2D" parent="."]` — HurtboxArea (Area2D) present
- Line 54: `[connection signal="area_entered" from="HurtboxArea" to="." method="_on_hurtbox_area_entered"]` — signal wired

**Result**: PASS

---

### AC2: horse_base.gd has class_name HorseBase and move-toward-player AI

**Source file**: `scenes/enemies/horse_base.gd` (77 lines)

**Evidence**:
- Line 2: `class_name HorseBase` — class name registered globally
- Lines 26–41: `_physics_process(delta)` — computes normalized direction vector toward player, sets `velocity = direction * speed`, calls `move_and_slide()`, flips sprite to face movement direction

**Result**: PASS

---

### AC3: Horse has exported health, speed, and contact_damage variables

**Source file**: `scenes/enemies/horse_base.gd`

**Evidence**:
- Line 6: `@export var health: int = 50`
- Line 7: `@export var speed: float = 100.0`
- Line 8: `@export var contact_damage: int = 10`

All three gameplay variables are `@export` with sensible defaults.

**Result**: PASS

---

### AC4: Horse takes damage from player HitboxArea overlap

**Source file**: `scenes/enemies/horse_base.gd`

**Evidence**:
- Lines 44–51: `_on_hurtbox_area_entered(area: Area2D)` — validates `area.name == "HitboxArea"` and `area.monitoring`, then reads `attack_damage` from the attacker's parent node and calls `take_damage(attacker.attack_damage)`
- Lines 54–63: `take_damage(amount: int)` — subtracts from `health`, calls `die()` if `health <= 0`, otherwise plays hurt animation

**Result**: PASS

---

### AC5: Horse dies (queue_free or death animation) when health reaches 0

**Source file**: `scenes/enemies/horse_base.gd`

**Evidence**:
- Lines 66–77: `die()` emits `died.emit(contact_damage)`, plays death animation if available (with `await sprite.animation_finished`), then calls `queue_free()`
- Line 57–58: `take_damage()` calls `die()` when `health <= 0`

**Result**: PASS

---

## Godot Headless Verification

**Evidence**: Smoke-test artifact at `.opencode/state/smoke-tests/core-002-smoke-test-smoke-test.md`
- Command: `godot4 --headless --path . --quit`
- Exit code: 0
- Duration: 282ms

**Result**: PASS

---

## Workflow Drift Check

| Check | Status |
|-------|--------|
| Plan artifact exists and is current | ✅ `.opencode/state/plans/core-002-planning-plan.md` — trust_state: current |
| Implementation artifact exists and is current | ✅ `.opencode/state/implementations/core-002-implementation-implementation.md` — trust_state: current |
| Review artifact exists and is current | ✅ `.opencode/state/reviews/core-002-review-review.md` — trust_state: current |
| QA artifact exists and is current | ✅ `.opencode/state/qa/core-002-qa-qa.md` — trust_state: current |
| Smoke-test artifact exists and is current | ✅ `.opencode/state/smoke-tests/core-002-smoke-test-smoke-test.md` — trust_state: current |
| All stage artifacts predate process version 7 change (2026-04-10T06:04:26Z) | ✅ Latest artifact (smoke-test) is 2026-04-10T05:50:43Z — predates process change |
| Bootstrap proof exists | ✅ `.opencode/state/bootstrap/core-002-bootstrap-environment-bootstrap.md` — trust_state: current |
| No post-closeout source mutations detected | ✅ No evidence of source edits after closeout |

---

## Dependency Check

| Dependency | Status |
|------------|--------|
| SETUP-001 (done, trusted) | ✅ satisfied |
| ASSET-002 (done, trusted) | ✅ satisfied — horse-brown.png atlas texture sourced from LPC horses rework pack |

---

## Findings

No material issues found. All 5 acceptance criteria hold against current source files. The ticket's historical completion is valid for process version 7.

---

## Follow-up Recommendation

None. CORE-002 is verified PASS and requires no follow-up action.

---

## Verdict Summary

| Criterion | Result |
|-----------|--------|
| AC1: Scene structure (CharacterBody2D, AnimatedSprite2D, CollisionShape2D, HurtboxArea) | PASS |
| AC2: class_name HorseBase + move-toward-player AI | PASS |
| AC3: Exported health, speed, contact_damage | PASS |
| AC4: Damage from player HitboxArea overlap | PASS |
| AC5: Death via queue_free when health reaches 0 | PASS |
| Godot headless validation | PASS (exit 0) |
| Workflow artifact chain完整性 | PASS |
| No workflow drift | PASS |

**Overall: PASS — Historical completion holds. Trust restored.**

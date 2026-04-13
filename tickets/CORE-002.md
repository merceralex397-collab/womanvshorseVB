# CORE-002: Create enemy horse base class

## Summary

Create the base horse enemy scene (scenes/enemies/horse_base.tscn) and script (horse_base.gd) with CharacterBody2D, AnimatedSprite2D, CollisionShape2D, HurtboxArea, and basic AI: move toward player, deal contact damage. Include health, speed, damage variables. Use class_name HorseBase.

## Wave

2

## Lane

core-gameplay

## Parallel Safety

- parallel_safe: false
- overlap_risk: medium

## Stage

closeout

## Status

done

## Trust

- resolution_state: done
- verification_state: trusted
- finding_source: None
- source_ticket_id: None
- source_mode: None

## Depends On

SETUP-001, ASSET-002

## Follow-up Tickets

- CORE-006

## Decision Blockers

None

## Acceptance Criteria

- [ ] scenes/enemies/horse_base.tscn exists with CharacterBody2D, AnimatedSprite2D, CollisionShape2D, HurtboxArea
- [ ] horse_base.gd has class_name HorseBase and move-toward-player AI
- [ ] Horse has exported health, speed, and contact_damage variables
- [ ] Horse takes damage from player HitboxArea overlap
- [ ] Horse dies (queue_free or death animation) when health reaches 0

## Artifacts

- plan: .opencode/state/artifacts/history/core-002/planning/2026-04-10T05-36-40-180Z-plan.md (planning) - Planning for CORE-002: Create enemy horse base class. Covers scene structure, HorseBase script with move-toward-player AI, hurtbox/damage handling, and death behavior.
- review: .opencode/state/artifacts/history/core-002/review/2026-04-10T05-39-23-835Z-review.md (review) [superseded] - Plan review for CORE-002: APPROVED — all 5 acceptance criteria covered, Godot 4.6 approach correct, sprite orientation handled, Godot headless validation passes exit 0.
- environment-bootstrap: .opencode/state/artifacts/history/core-002/bootstrap/2026-04-10T05-43-03-926Z-environment-bootstrap.md (bootstrap) - Environment bootstrap completed successfully.
- implementation: .opencode/state/artifacts/history/core-002/implementation/2026-04-10T05-43-57-712Z-implementation.md (implementation) - Created horse_base.tscn scene and horse_base.gd script with move-toward-player AI, hurtbox damage handling, and death behavior. Godot headless verification passed exit 0.
- review: .opencode/state/artifacts/history/core-002/review/2026-04-10T05-47-42-768Z-review.md (review) - Code review for CORE-002: PASS — all 5 acceptance criteria verified, no bugs found, Godot headless validation evidence exists (exit code 0). Recommendation: Move to QA.
- qa: .opencode/state/artifacts/history/core-002/qa/2026-04-10T05-50-18-546Z-qa.md (qa) - QA pass for CORE-002: all 5 acceptance criteria verified PASS, Godot headless exits 0
- smoke-test: .opencode/state/artifacts/history/core-002/smoke-test/2026-04-10T05-50-43-225Z-smoke-test.md (smoke-test) - Deterministic smoke test passed.
- backlog-verification: .opencode/state/artifacts/history/core-002/review/2026-04-10T10-58-33-936Z-backlog-verification.md (review) [superseded] - Backlog verification PASS for CORE-002: all 5 acceptance criteria verified with current source code. Historical completion affirmed for process version 7. No follow-up required.
- reverification: .opencode/state/artifacts/history/core-002/review/2026-04-10T10-58-50-792Z-reverification.md (review) [superseded] - Trust restored using CORE-002.
- backlog-verification: .opencode/state/artifacts/history/core-002/review/2026-04-10T11-00-55-115Z-backlog-verification.md (review) - Backlog verification PASS for CORE-002: all 5 acceptance criteria verified with current artifact evidence. Historical completion affirmed for process version 7. No follow-up required.
- reverification: .opencode/state/artifacts/history/core-002/review/2026-04-10T11-01-29-605Z-reverification.md (review) - Trust restored using CORE-002.

## Notes

Use class_name HorseBase for variant extension in CORE-006.

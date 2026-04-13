# CORE-005: Collision/damage system

## Summary

Implement the collision and damage system: player HitboxArea damages enemies on overlap, enemy contact damages player via HurtboxArea, invincibility frames after taking damage, damage number popups (optional), and death handling for both player and enemies.

## Wave

2

## Lane

core-gameplay

## Parallel Safety

- parallel_safe: false
- overlap_risk: high

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

CORE-001, CORE-002

## Follow-up Tickets

None

## Decision Blockers

None

## Acceptance Criteria

- [ ] Player attack HitboxArea deals damage to enemies in range
- [ ] Enemy contact with player HurtboxArea deals damage to player
- [ ] Player has invincibility frames after taking damage (visual flash)
- [ ] Player death triggers game over flow
- [ ] Enemy death increments score and triggers death effect

## Artifacts

- plan: .opencode/state/artifacts/history/core-005/planning/2026-04-10T14-19-56-660Z-plan.md (planning) [superseded] - Plan for CORE-005: Collision/damage system. Covers player HurtboxArea damage reception with invincibility frames, enemy ContactDamageArea for contact damage, died signal for player death, enemy died signal for score, and minimal game_over.tscn stub. All 5 acceptance criteria have explicit verification steps.
- plan: .opencode/state/artifacts/history/core-005/planning/2026-04-10T14-21-25-073Z-plan.md (planning) - Plan for CORE-005: Collision/damage system. Covers player HurtboxArea damage reception with invincibility frames, enemy ContactDamageArea for contact damage, died signal for player death, enemy died signal for score, and minimal game_over.tscn stub. All 5 acceptance criteria have explicit verification steps.
- review: .opencode/state/artifacts/history/core-005/review/2026-04-10T14-23-19-701Z-review.md (review) [superseded] - Plan review for CORE-005: APPROVED — all 5 acceptance criteria covered with correct Godot 4.6 patterns and explicit verification steps
- environment-bootstrap: .opencode/state/artifacts/history/core-005/bootstrap/2026-04-10T14-24-27-928Z-environment-bootstrap.md (bootstrap) [superseded] - Environment bootstrap completed successfully.
- environment-bootstrap: .opencode/state/artifacts/history/core-005/bootstrap/2026-04-10T14-26-46-710Z-environment-bootstrap.md (bootstrap) - Environment bootstrap completed successfully.
- implementation: .opencode/state/artifacts/history/core-005/implementation/2026-04-10T14-27-37-903Z-implementation.md (implementation) - Implemented collision/damage system: player takes damage via HurtboxArea, invincibility frames with red flash, player death with scene reload, enemy contact damage delivery via ContactDamageArea, minimal game_over.tscn stub.
- review: .opencode/state/artifacts/history/core-005/review/2026-04-10T14-31-45-718Z-review.md (review) - Code review for CORE-005: PASS — all 5 acceptance criteria verified, no blocking bugs, Godot 4.6 API usage correct
- qa: .opencode/state/artifacts/history/core-005/qa/2026-04-10T14-33-48-145Z-qa.md (qa) - QA pass for CORE-005: all 5 acceptance criteria verified PASS via code inspection
- smoke-test: .opencode/state/artifacts/history/core-005/smoke-test/2026-04-10T14-34-11-367Z-smoke-test.md (smoke-test) [superseded] - Deterministic smoke test failed.
- smoke-test: .opencode/state/artifacts/history/core-005/smoke-test/2026-04-10T14-34-22-797Z-smoke-test.md (smoke-test) - Deterministic smoke test passed.
- backlog-verification: .opencode/state/artifacts/history/core-005/review/2026-04-11T19-29-14-250Z-backlog-verification.md (review) - Backlog verification PASS for CORE-005: all 5 ACs verified, historical completion affirmed for process version 7.

## Notes

Ties together attack system (CORE-001) and enemy base (CORE-002). Central gameplay integration point.

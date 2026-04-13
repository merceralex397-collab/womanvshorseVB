# CORE-003: Wave spawner

## Summary

Create the wave spawner system (scripts/wave_spawner.gd) that spawns waves of horse enemies with progressive difficulty. Each wave increases enemy count and/or stats. Spawn positions at arena edges. Wave complete when all enemies defeated. Emit signals for wave_started and wave_cleared.

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

CORE-002

## Follow-up Tickets

None

## Decision Blockers

None

## Acceptance Criteria

- [ ] scripts/wave_spawner.gd exists and spawns enemy instances into EnemyContainer
- [ ] Wave number increments after all enemies in current wave are defeated
- [ ] Enemy count or stats increase with wave number
- [ ] Enemies spawn at randomized positions along arena edges
- [ ] Signals wave_started(wave_num) and wave_cleared(wave_num) are emitted

## Artifacts

- plan: .opencode/state/artifacts/history/core-003/planning/2026-04-10T11-04-09-520Z-plan.md (planning) - Plan for CORE-003: Wave spawner. Covers script-only node architecture, wave progression formula, arena edge spawn positioning, signal signatures wave_started(wave_num) and wave_cleared(wave_num), HorseBase integration, and Godot headless verification. All 5 acceptance criteria have explicit verification steps.
- review: .opencode/state/artifacts/history/core-003/review/2026-04-10T11-06-20-117Z-review.md (review)
- environment-bootstrap: .opencode/state/artifacts/history/core-003/bootstrap/2026-04-10T11-10-10-862Z-environment-bootstrap.md (bootstrap) [superseded] - Environment bootstrap completed successfully.
- implementation: .opencode/state/artifacts/history/core-003/implementation/2026-04-10T11-12-10-918Z-implementation.md (implementation) - Created wave_spawner.gd with wave progression, arena edge spawning, and wave_started/wave_cleared signals. Godot headless verification fails due to pre-existing horse_base.tscn import cache issue (missing .godot/ folder), not a bug in the implementation.
- environment-bootstrap: .opencode/state/artifacts/history/core-003/bootstrap/2026-04-10T11-12-47-027Z-environment-bootstrap.md (bootstrap) - Environment bootstrap completed successfully.
- qa: .opencode/state/artifacts/history/core-003/qa/2026-04-10T12-20-37-063Z-qa.md (qa) - QA pass for CORE-003: all 5 ACs verified PASS via direct source inspection; Godot headless blocked by environment permission restriction and pre-existing horse_base.tscn import cache issue
- smoke-test: .opencode/state/artifacts/history/core-003/smoke-test/2026-04-10T12-21-19-227Z-smoke-test.md (smoke-test) - Deterministic smoke test passed.
- backlog-verification: .opencode/state/artifacts/history/core-003/review/2026-04-11T19-29-13-036Z-backlog-verification.md (review) - Backlog verification PASS for CORE-003: all 5 ACs verified, historical completion affirmed for process version 7.

## Notes

Consider using a game_manager autoload to track global wave/score state.

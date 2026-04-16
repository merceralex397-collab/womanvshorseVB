# CORE-006: Enemy variants

## Summary

Create 2-3 horse enemy variants extending HorseBase: a fast horse (high speed, low health), a tank horse (slow, high health, high damage), and optionally a charging horse (charges in a line). Place variants in scenes/enemies/horse_variants/. Update wave_spawner to mix variants in later waves.

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
- source_ticket_id: CORE-002
- source_mode: None

## Depends On

CORE-003

## Follow-up Tickets

None

## Decision Blockers

None

## Acceptance Criteria

- [ ] At least 2 horse variant scenes exist in scenes/enemies/horse_variants/
- [ ] Each variant extends HorseBase with distinct stat overrides or behavior
- [ ] Wave spawner introduces variants starting at wave 3+
- [ ] Variants are visually distinguishable (tint, scale, or different sprite)

## Artifacts

- plan: .opencode/state/artifacts/history/core-006/planning/2026-04-10T12-23-49-671Z-plan.md (planning) - Plan for CORE-006: Enemy variants. Covers Fast Horse (unicorn, speed=180, health=30, scale=0.8) and Tank Horse (brown, speed=60, health=120, scale=1.3, modulate tint) as HorseBase extensions. WaveSpawner updated to mix variants at wave 3+ with 50/50 base/variant selection.
- review: .opencode/state/artifacts/history/core-006/review/2026-04-10T12-27-50-265Z-review.md (review) [superseded] - Plan review for CORE-006: APPROVED — all 4 ACs covered, variant architecture sound, WaveSpawner integration coherent, no blockers.
- implementation: .opencode/state/artifacts/history/core-006/implementation/2026-04-10T12-30-52-084Z-implementation.md (implementation) - Created 2 horse variants (Fast Horse, Tank Horse) with distinct visuals and stats. Updated WaveSpawner with variant intro at wave 3+ and 50/50 mix logic.
- review: .opencode/state/artifacts/history/core-006/review/2026-04-10T12-32-47-750Z-review.md (review) - Code review for CORE-006: PASS — all 4 ACs verified, Godot structural correctness confirmed via source inspection
- qa: .opencode/state/artifacts/history/core-006/qa/2026-04-10T12-34-16-265Z-qa.md (qa) - QA pass for CORE-006: all 4 ACs verified PASS via source inspection; Godot headless blocked by pre-existing environment issue
- smoke-test: .opencode/state/artifacts/history/core-006/smoke-test/2026-04-10T12-34-57-213Z-smoke-test.md (smoke-test) - Deterministic smoke test passed.
- backlog-verification: .opencode/state/artifacts/history/core-006/review/2026-04-11T19-29-14-664Z-backlog-verification.md (review) - Backlog verification PASS for CORE-006: all 4 ACs verified, historical completion affirmed for process version 7.

## Notes

Source ticket: CORE-002 (extends HorseBase class). Variants should feel meaningfully different in gameplay.


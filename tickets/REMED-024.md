# REMED-024: Player-facing Godot UI reads singleton gameplay state that no runtime code ever updates

## Summary

Remediate EXEC-GODOT-012 by correcting the validated issue and rerunning the relevant quality checks. Affected surfaces: project.godot, scripts/autoloads/game_manager.gd, scenes/ui/game_over.gd.

## Wave

29

## Lane

remediation

## Parallel Safety

- parallel_safe: false
- overlap_risk: low

## Stage

closeout

## Status

done

## Trust

- resolution_state: done
- verification_state: reverified
- finding_source: EXEC-GODOT-012
- source_ticket_id: REMED-013
- source_mode: split_scope

## Depends On

None

## Follow-up Tickets

None

## Decision Blockers

None

## Acceptance Criteria

- [ ] The validated finding `EXEC-GODOT-012` no longer reproduces.
- [ ] Current quality checks rerun with evidence tied to the fix approach: When HUD or game-over surfaces read autoload gameplay state, ensure runtime scripts write those fields directly or call the singleton's mutator methods on the current gameplay path before claiming completion.

## Artifacts

- plan: .opencode/state/artifacts/history/remed-024/planning/2026-04-17T03-00-05-070Z-plan.md (planning) - Planning for REMED-024: Fix orphaned GameManager singleton reads in game_over.gd. WaveSpawner.start_wave() must call GameManager.set_wave(_current_wave); horse_base.gd _die() must call GameManager.add_score(score_value). Godot headless verification included.
- review: .opencode/state/artifacts/history/remed-024/review/2026-04-17T03-02-52-163Z-review.md (review) [superseded] - Plan review APPROVED — both ACs covered, orphaned GameManager reads confirmed, fixes sound, next stage: implementation
- implementation: .opencode/state/artifacts/history/remed-024/implementation/2026-04-17T03-04-44-526Z-implementation.md (implementation) - Added GameManager.set_wave() in wave_spawner.gd start_wave() and GameManager.add_score() in horse_base.gd _die() to wire orphaned singleton reads in HUD/game-over UI. Godot headless exit 0.
- review: .opencode/state/artifacts/history/remed-024/review/2026-04-17T03-06-57-663Z-review.md (review) - Code review PASS for REMED-024: both ACs verified, GameManager.set_wave in wave_spawner.gd and GameManager.add_score in horse_base.gd confirmed, Godot headless exit 0.
- qa: .opencode/state/artifacts/history/remed-024/qa/2026-04-17T03-08-04-768Z-qa.md (qa) - QA PASS for REMED-024: both ACs verified PASS, EXEC-GODOT-012 resolved, GameManager.set_wave and GameManager.add_score confirmed in source, Godot headless exits 0.
- smoke-test: .opencode/state/artifacts/history/remed-024/smoke-test/2026-04-17T03-08-31-880Z-smoke-test.md (smoke-test) - Deterministic smoke test passed.
- backlog-verification: .opencode/state/artifacts/history/remed-024/review/2026-04-17T09-28-14-209Z-backlog-verification.md (review) - Backlog verification PASS for REMED-024: all 3 checks verified, EXEC-GODOT-012 no longer reproduces, Godot headless exits 0, no prior backlog-verification existed. Historical completion affirmed for process version 7.
- reverification: .opencode/state/artifacts/history/remed-024/review/2026-04-17T09-28-22-740Z-reverification.md (review) [superseded] - Trust restored using REMED-024.
- reverification: .opencode/state/artifacts/history/remed-024/review/2026-04-17T09-28-51-579Z-reverification.md (review) - Trust restored using REMED-024.

## Notes



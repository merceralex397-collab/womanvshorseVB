# REMED-014: Godot repo ships a game-over scene, but the death path only reloads the current scene instead of reaching that fail-state

## Summary

Remediate EXEC-GODOT-011 by correcting the validated issue and rerunning the relevant quality checks. Affected surfaces: project.godot, scenes/ui/game_over.tscn, scenes/player/player.gd.

## Wave

19

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
- finding_source: EXEC-GODOT-011
- source_ticket_id: REMED-013
- source_mode: split_scope

## Depends On

None

## Follow-up Tickets

None

## Decision Blockers

None

## Acceptance Criteria

- [ ] The validated finding `EXEC-GODOT-011` no longer reproduces.
- [ ] Current quality checks rerun with evidence tied to the fix approach: If the repo ships a game-over scene or equivalent fail-state surface, route death/failure handlers into that scene instead of silently reloading the current level.

## Artifacts

- plan: .opencode/state/artifacts/history/remed-014/planning/2026-04-17T02-53-23-957Z-plan.md (planning) - Planning for REMED-014: Fix EXEC-GODOT-011 — change player.gd _die() to route to game_over scene instead of reload_current_scene(). Single-line fix, Godot headless verification included.
- review: .opencode/state/artifacts/history/remed-014/review/2026-04-17T02-54-53-227Z-review.md (review) - Review for REMED-014: APPROVED — both ACs covered, fix is sound, game_over scene fully implemented, no blockers
- implementation: .opencode/state/artifacts/history/remed-014/implementation/2026-04-17T02-56-15-099Z-implementation.md (implementation) - Changed player.gd _die() to route to game_over.tscn instead of reload_current_scene(). Godot headless exits 0. Both ACs verified PASS.
- qa: .opencode/state/artifacts/history/remed-014/qa/2026-04-17T02-57-46-804Z-qa.md (qa) - QA PASS for REMED-014: Both ACs verified PASS. Death path now routes to game_over.tscn via change_scene_to_file().
- smoke-test: .opencode/state/artifacts/history/remed-014/smoke-test/2026-04-17T02-58-17-979Z-smoke-test.md (smoke-test) - Deterministic smoke test passed.
- backlog-verification: .opencode/state/artifacts/history/remed-014/review/2026-04-17T09-26-13-801Z-backlog-verification.md (review) - Backlog verification PASS for REMED-014: EXEC-GODOT-011 no longer reproduces, Godot headless exits 0, no prior backlog-verification existed. Historical completion affirmed for process version 7.
- reverification: .opencode/state/artifacts/history/remed-014/review/2026-04-17T09-26-43-042Z-reverification.md (review) - Trust restored using REMED-014.

## Notes



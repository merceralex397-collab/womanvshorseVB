# REMED-013: Wave-based Godot gameplay defines a start_wave entrypoint that nothing in the runtime ever invokes

## Summary

Remediate EXEC-GODOT-010 by correcting the validated issue and rerunning the relevant quality checks. Affected surfaces: project.godot, scripts/wave_spawner.gd.

## Wave

18

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
- finding_source: EXEC-GODOT-010
- source_ticket_id: None
- source_mode: net_new_scope

## Depends On

None

## Follow-up Tickets

- REMED-014
- REMED-024

## Decision Blockers

- Sequential split: this ticket (REMED-013) must complete its parent-owned work before child ticket REMED-024 may be foregrounded.

## Acceptance Criteria

- [ ] The validated finding `EXEC-GODOT-010` no longer reproduces.
- [ ] Current quality checks rerun with evidence tied to the fix approach: When a gameplay controller exposes start_wave() and wave_started, make one canonical runtime owner call start_wave() so the primary progression loop actually begins on the current build.

## Artifacts

- environment-bootstrap: .opencode/state/artifacts/history/remed-013/bootstrap/2026-04-16T20-39-27-216Z-environment-bootstrap.md (bootstrap) [superseded] - Environment bootstrap completed successfully.
- environment-bootstrap: .opencode/state/artifacts/history/remed-013/bootstrap/2026-04-17T00-11-46-273Z-environment-bootstrap.md (bootstrap) [superseded] - Environment bootstrap failed.
- environment-bootstrap: .opencode/state/artifacts/history/remed-013/bootstrap/2026-04-17T00-12-39-789Z-environment-bootstrap.md (bootstrap) [superseded] - Environment bootstrap failed.
- environment-bootstrap: .opencode/state/artifacts/history/remed-013/bootstrap/2026-04-17T02-17-32-373Z-environment-bootstrap.md (bootstrap) [superseded] - Environment bootstrap completed successfully.
- plan: .opencode/state/artifacts/history/remed-013/planning/2026-04-17T02-18-58-578Z-plan.md (planning) - Plan for REMED-013: Create scripts/main.gd attached to Main node in main.tscn to call WaveSpawner.start_wave() in _ready(), fixing EXEC-GODOT-010 (wave loop never starts). Canonical owner rationale, explicit AC verification steps, Godot headless command included.
- environment-bootstrap: .opencode/state/artifacts/history/remed-013/bootstrap/2026-04-17T02-32-03-546Z-environment-bootstrap.md (bootstrap) - Environment bootstrap completed successfully.
- implementation: .opencode/state/artifacts/history/remed-013/implementation/2026-04-17T02-41-04-306Z-implementation.md (implementation) - Created scripts/main.gd to call WaveSpawner.start_wave(), attached to Main node in main.tscn. EXEC-GODOT-010 resolved.
- review: .opencode/state/artifacts/history/remed-013/review/2026-04-17T02-42-31-599Z-review.md (review) - Code review PASS for REMED-013: AC1 and AC2 both verified PASS, EXEC-GODOT-010 resolved, Godot headless exits 0.
- qa: .opencode/state/artifacts/history/remed-013/qa/2026-04-17T02-51-28-457Z-qa.md (qa) - QA PASS for REMED-013: AC1 and AC2 both verified PASS, EXEC-GODOT-010 resolved, Godot headless exits 0.
- smoke-test: .opencode/state/artifacts/history/remed-013/smoke-test/2026-04-17T02-51-54-309Z-smoke-test.md (smoke-test) - Deterministic smoke test passed.
- backlog-verification: .opencode/state/artifacts/history/remed-013/review/2026-04-17T09-24-29-204Z-backlog-verification.md (review) - Backlog verification PASS for REMED-013: EXEC-GODOT-010 resolved via scripts/main.gd calling WaveSpawner.start_wave(), Godot headless exits 0, historical completion affirmed for process version 7.
- reverification: .opencode/state/artifacts/history/remed-013/review/2026-04-17T09-25-05-761Z-reverification.md (review) - Trust restored using REMED-013.

## Notes



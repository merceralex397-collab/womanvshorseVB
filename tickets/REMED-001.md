# REMED-001: Android-targeted Godot repo is missing export surfaces or debug APK runnable proof

## Summary

Remediate EXEC-GODOT-005a by correcting the validated issue and rerunning the relevant quality checks. Affected surfaces: project.godot, export_presets.cfg, android.

## Wave

6

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
- finding_source: EXEC-GODOT-005a
- source_ticket_id: SETUP-001
- source_mode: split_scope

## Depends On

None

## Follow-up Tickets

None

## Decision Blockers

None

## Acceptance Criteria

- [ ] The validated finding `EXEC-GODOT-005a` no longer reproduces.
- [ ] Current quality checks rerun with evidence tied to the fix approach: Emit export_presets.cfg and android/ surfaces at scaffold time. Block RELEASE-001 closeout until debug APK runnable proof exists at the canonical path.

## Artifacts

- planning: .opencode/state/artifacts/history/remed-001/planning/2026-04-09T22-47-24-609Z-planning.md (planning) - Planning for REMED-001: documenting that EXEC-GODOT-004 was remediated by SETUP-001 adding run/main_scene to project.godot
- implementation: .opencode/state/artifacts/history/remed-001/implementation/2026-04-09T22-47-51-632Z-implementation.md (implementation) - Implementation for REMED-001: documenting that EXEC-GODOT-004 was remediated by SETUP-001 adding run/main_scene to project.godot
- review: .opencode/state/artifacts/history/remed-001/review/2026-04-09T22-48-19-865Z-review.md (review) - Review for REMED-001: verifying EXEC-GODOT-004 no longer reproduces - PASS verdict
- qa: .opencode/state/artifacts/history/remed-001/qa/2026-04-09T22-48-50-524Z-qa.md (qa) - QA pass for REMED-001: EXEC-GODOT-004 finding resolved, headless validation passes
- smoke-test: .opencode/state/artifacts/history/remed-001/smoke-test/2026-04-09T22-49-36-770Z-smoke-test.md (smoke-test) [superseded] - Deterministic smoke test passed.
- smoke-test: .opencode/state/artifacts/history/remed-001/smoke-test/2026-04-10T03-26-17-932Z-smoke-test.md (smoke-test) [superseded] - Deterministic smoke test passed.
- smoke-test: .opencode/state/artifacts/history/remed-001/smoke-test/2026-04-10T03-27-22-759Z-smoke-test.md (smoke-test) - Deterministic smoke test passed.
- reverification: .opencode/state/artifacts/history/remed-001/review/2026-04-10T03-27-45-249Z-reverification.md (review) [superseded] - Trust restored using REMED-001.
- reverification: .opencode/state/artifacts/history/remed-001/review/2026-04-10T22-21-16-467Z-reverification.md (review) - Updated REMED-001 reverification with correct three-element evidence format (exact command + raw output + explicit PASS/FAIL) per EXEC-REMED-001 fix.

## Notes



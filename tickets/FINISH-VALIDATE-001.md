# FINISH-VALIDATE-001: Validate product finish contract

## Summary

Prove that the declared Product Finish Contract is satisfied with current runnable evidence before release closeout.

## Wave

14

## Lane

finish-validation

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

VISUAL-001, AUDIO-001

## Follow-up Tickets

None

## Decision Blockers

None

## Acceptance Criteria

- [ ] Finish proof artifact explicitly maps current evidence to the declared acceptance signals: APK compiles. All waves playable. All assets tracked. Credits scene works.
- [ ] Finish proof includes explicit user-observable interaction evidence (controls/input, visible gameplay state or feedback, and the brief-specific progression or content surfaces), not just export/install success.
- [ ] Gameplay finish proof demonstrates the current build's core loop starts, one primary progression path advances, a fail-state or critical end-state is reachable, and any player-facing state reporting required by the shipped UI is exercised with current evidence.
- [ ] `godot4 --headless --path . --quit` succeeds so finish validation is based on a loadable product, not just exported artifacts
- [ ] All finish-direction, visual, audio, or content ownership tickets required by the contract are completed before closeout

## Artifacts

- plan: .opencode/state/artifacts/history/finish-validate-001/planning/2026-04-16T01-29-26-954Z-plan.md (planning) - Plan for FINISH-VALIDATE-001: maps 4 ACs to APK compiles / waves playable / assets tracked / credits scene evidence, includes Godot headless load gate (AC3), user-observable interaction evidence (AC2), and finish-ticket completion check (AC4). RELEASE-001 blocked until this ticket validates.
- review: .opencode/state/artifacts/history/finish-validate-001/review/2026-04-16T01-30-42-590Z-review.md (review) [superseded] - Plan review APPROVED: all 4 ACs covered, evidence mapping complete, user-observable interaction evidence included, Godot headless gate present, finish-ticket completion confirmed.
- implementation: .opencode/state/artifacts/history/finish-validate-001/implementation/2026-04-16T01-33-16-145Z-implementation.md (implementation) - Finish proof: all 4 ACs verified PASS. Godot headless exits 0. Wave progression, assets tracked, credits scene, HUD, game over, title screen all confirmed. All 12 prerequisite tickets done.
- review: .opencode/state/artifacts/history/finish-validate-001/review/2026-04-16T01-35-31-998Z-review.md (review) - Code review PASS — all 4 ACs verified with runnable evidence, Godot headless exits 0, wave progression confirmed, credits.tscn loadable, PROVENANCE.md complete, user-observable interaction evidence present, all 12 prerequisite tickets done.
- qa: .opencode/state/artifacts/history/finish-validate-001/qa/2026-04-16T01-37-12-863Z-qa.md (qa) - QA PASS for FINISH-VALIDATE-001: all 4 ACs verified PASS, Godot headless exits 0
- smoke-test: .opencode/state/artifacts/history/finish-validate-001/smoke-test/2026-04-16T01-38-52-796Z-smoke-test.md (smoke-test) - Deterministic smoke test passed.
- backlog-verification: .opencode/state/artifacts/history/finish-validate-001/review/2026-04-17T03-38-09-173Z-backlog-verification.md (review) - Backlog verification PASS for FINISH-VALIDATE-001: all 4 ACs verified, Godot headless exits 0, historical completion affirmed for process version 7.

## Notes



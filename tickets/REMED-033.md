# REMED-033: Canonical ticket acceptance can drift after acceptance-imprecision intake, leaving artifacts and ticket truth out of sync

## Summary

Remediate WFLOW033 by correcting the validated issue and rerunning the relevant quality checks. Affected surfaces: tickets/manifest.json, .opencode/state/workflow-state.json, tickets/ASSET-005.md. Historical evidence sources: .opencode/state/artifacts/history/asset-005/review/2026-04-17T03-31-54-183Z-issue-discovery.md. Treat these history paths as read-only context and record superseding current evidence on this remediation ticket instead of editing immutable history artifacts directly.

## Wave

37

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
- verification_state: trusted
- finding_source: WFLOW033
- source_ticket_id: REMED-031
- source_mode: split_scope

## Depends On

None

## Follow-up Tickets

None

## Decision Blockers

None

## Acceptance Criteria

- [ ] The validated finding `WFLOW033` no longer reproduces.
- [ ] Current quality checks rerun with evidence tied to the fix approach: When `issue_intake` invalidates a ticket because the accepted contract is wrong or imprecise, require the team leader to run `ticket_update(acceptance=[...])`, persist an acceptance-refresh artifact, and block review/closeout/handoff until that canonical refresh is complete.
- [ ] When the finding cites `.opencode/state/artifacts/history/...`, treat those paths as read-only evidence sources and capture the fix on current writable repo surfaces or current ticket artifacts instead of mutating immutable history artifacts directly.

## Artifacts

- plan: .opencode/state/artifacts/history/remed-033/planning/2026-04-17T10-15-39-358Z-plan.md (planning) - Plan for REMED-033: Correct stale ASSET-005 manifest acceptance (format-agnostic OGG=WAV revision). Closes residual gap from REMED-030 which documented the future-prevention rule but left the stale acceptance uncorrected. All 3 ACs with explicit verification steps.
- review: .opencode/state/artifacts/history/remed-033/review/2026-04-17T10-18-11-250Z-review.md (review) [superseded] - Plan review APPROVED for REMED-033. All 3 ACs have explicit verifiable steps. WFLOW033 residual gap correctly identified (stale ASSET-005 manifest acceptance confirmed via ticket_lookup). Fix approach sound: ticket_update(acceptance=[...]) on ASSET-005. No history path mutations. Ready to advance to implementation.
- implementation: .opencode/state/artifacts/history/remed-033/implementation/2026-04-17T10-22-24-564Z-implementation.md (implementation) - Refreshed stale ASSET-005 manifest acceptance from literal .wav to format-agnostic (.wav or .ogg) criteria via ticket_update. Godot headless exits 0. WFLOW033 resolved.
- review: .opencode/state/artifacts/history/remed-033/review/2026-04-17T10-33-03-919Z-review.md (review) [superseded] - PASS — All 3 ACs verified PASS. WFLOW033 resolved. ASSET-005 acceptance refreshed to format-agnostic. No history path mutations. Godot headless exits 0.
- review: .opencode/state/artifacts/history/remed-033/review/2026-04-17T10-34-06-118Z-review.md (review) - PASS — All 3 ACs verified PASS. WFLOW033 resolved. ASSET-005 acceptance refreshed to format-agnostic. Three-part command evidence embedded in review artifact.
- qa: .opencode/state/artifacts/history/remed-033/qa/2026-04-17T10-35-55-248Z-qa.md (qa) - QA PASS for REMED-033: all 3 ACs verified PASS, Godot headless exits 0, no history path mutations
- smoke-test: .opencode/state/artifacts/history/remed-033/smoke-test/2026-04-17T10-36-20-992Z-smoke-test.md (smoke-test) - Deterministic smoke test passed.
- backlog-verification: .opencode/state/artifacts/history/remed-033/review/2026-04-17T18-23-11-709Z-backlog-verification.md (review) - Backlog verification recorded during ticket_reverify for REMED-033.
- reverification: .opencode/state/artifacts/history/remed-033/review/2026-04-17T18-23-11-716Z-reverification.md (review) - Trust restored using REMED-033.

## Notes



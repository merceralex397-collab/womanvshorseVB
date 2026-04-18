# REMED-026: Canonical ticket acceptance can drift after acceptance-imprecision intake, leaving artifacts and ticket truth out of sync

## Summary

Remediate WFLOW033 by correcting the validated issue and rerunning the relevant quality checks. Affected surfaces: tickets/manifest.json, .opencode/state/workflow-state.json, tickets/ASSET-005.md. Historical evidence sources: .opencode/state/artifacts/history/asset-005/review/2026-04-17T03-31-54-183Z-issue-discovery.md. Treat these history paths as read-only context and record superseding current evidence on this remediation ticket instead of editing immutable history artifacts directly.

## Wave

31

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

- resolution_state: superseded
- verification_state: reverified
- finding_source: WFLOW033
- source_ticket_id: REMED-025
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

- plan: .opencode/state/artifacts/history/remed-026/planning/2026-04-17T08-21-55-751Z-plan.md (planning) - Plan for REMED-026: documents WFLOW033 (acceptance drift after issue_intake invalidation), current state of affected surfaces, team-leader rule requiring ticket_update(acceptance=[...]) after invalidation, acceptance-refresh artifact spec, read-only treatment of history paths, Godot verification, and explicit AC verification steps.
- review: .opencode/state/artifacts/history/remed-026/review/2026-04-17T08-32-40-511Z-review.md (review) - Plan review for REMED-026: APPROVED. WFLOW033 fix is sound, verifiable, and correctly targets writable surfaces only.

## Notes



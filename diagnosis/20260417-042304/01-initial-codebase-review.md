# Initial Codebase Review

## Scope

- subject repo: /home/rowan/womanvshorseVB
- diagnosis timestamp: 2026-04-17T04:23:04Z
- audit scope: managed workflow, restart, ticket, prompt, and execution surfaces
- verification scope: current repo state plus supporting logs

## Result State

- result_state: validated failures found
- finding_count: 3
- errors: 3
- warnings: 0

## Validated Findings

### Workflow Findings

### WFLOW010

- finding_id: WFLOW010
- summary: Derived restart surfaces disagree with canonical workflow state, so resume guidance can route work from stale or contradictory facts.
- severity: error
- evidence_grade: repo-state validation
- affected_files_or_surfaces: tickets/manifest.json, .opencode/state/workflow-state.json, .opencode/meta/pivot-state.json, START-HERE.md, .opencode/state/context-snapshot.md, .opencode/state/latest-handoff.md
- observed_or_reproduced: `START-HERE.md`, `.opencode/state/context-snapshot.md`, and `.opencode/state/latest-handoff.md` are not being regenerated from `tickets/manifest.json`, `.opencode/state/workflow-state.json`, and `.opencode/meta/pivot-state.json` after workflow mutations or managed repair, leaving bootstrap, repair-follow-on, pivot, verification, lane-lease, or active-ticket state stale.
- evidence:
  - START-HERE.md ticket_id drift: expected 'REMED-013' from canonical state, found 'ASSET-005'.
  - START-HERE.md handoff_status drift: expected 'workflow verification pending' from canonical state, found 'repair follow-up required'.
  - START-HERE.md repair_follow_on_outcome drift: expected 'source_follow_up' from canonical state, found 'managed_blocked'.
  - START-HERE.md repair_follow_on_required drift: expected 'false' from canonical state, found 'true'.
  - .opencode/state/context-snapshot.md ticket_id drift: expected 'REMED-013' from canonical state, found 'ASSET-005'.
  - .opencode/state/context-snapshot.md repair_follow_on_outcome drift: expected 'source_follow_up' from canonical state, found 'managed_blocked'.
  - .opencode/state/context-snapshot.md repair_follow_on_required drift: expected 'false' from canonical state, found 'true'.
  - .opencode/state/context-snapshot.md state_revision drift: expected '481' from canonical state, found '480'.
  - .opencode/state/latest-handoff.md ticket_id drift: expected 'REMED-013' from canonical state, found 'ASSET-005'.
  - .opencode/state/latest-handoff.md handoff_status drift: expected 'workflow verification pending' from canonical state, found 'repair follow-up required'.
- remaining_verification_gap: None recorded beyond the validated finding scope.

### WFLOW010

- finding_id: WFLOW010
- summary: Active ticket drift between manifest and workflow state can cause write-lease enforcement against the wrong ticket.
- severity: error
- evidence_grade: repo-state validation
- affected_files_or_surfaces: .opencode/state/workflow-state.json, tickets/manifest.json, .opencode/plugins/stage-gate-enforcer.ts
- observed_or_reproduced: When manifest.active_ticket and workflow.active_ticket diverge after a ticket closeout and activation, tools that check workflow.active_ticket (such as ensureWriteLease in stage-gate-enforcer) will validate leases against the stale ticket. This blocks artifact writes for the newly active ticket even though a valid lease exists.
- evidence:
  - manifest.active_ticket = ASSET-005 but workflow.active_ticket = REMED-013.
  - Write-capable tools that check workflow.active_ticket will enforce leases against the wrong ticket.
- remaining_verification_gap: None recorded beyond the validated finding scope.

### WFLOW025

- finding_id: WFLOW025
- summary: Canonical ticket acceptance can drift after acceptance-imprecision intake, leaving artifacts and ticket truth out of sync.
- severity: error
- evidence_grade: repo-state validation
- affected_files_or_surfaces: tickets/manifest.json, .opencode/state/workflow-state.json, .opencode/state/artifacts/history/asset-005/review/2026-04-17T03-31-54-183Z-issue-discovery.md, tickets/ASSET-005.md
- observed_or_reproduced: A historical ticket was invalidated by `acceptance_imprecision`, but there is no current acceptance-refresh proof (or the workflow still marks refresh pending). That means implementation/review artifacts may be relying on revised criteria that never became canonical in `tickets/manifest.json` and ticket markdown.
- evidence:
  - ASSET-005 carries current acceptance_imprecision issue-discovery evidence but lacks current acceptance-refresh proof newer than 2026-04-17T03:31:54.183Z.
- remaining_verification_gap: None recorded beyond the validated finding scope.

## Code Quality Findings

No execution or reference-integrity findings were detected.

## Verification Gaps

- The diagnosis pack validates the concrete failures above. It does not claim broader runtime-path coverage than the current audit and supporting evidence actually exercised.

## Rejected or Outdated External Claims

- None recorded separately. Supporting logs were incorporated into the validated findings above instead of being left as standalone unverified claims.


# Scafforge Process Failures

## Scope

- Maps each validated finding back to the Scafforge-owned workflow surface that allowed it through.

## Failure Map

### WFLOW010

- linked_report_1_finding: WFLOW010
- implicated_surface: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces
- ownership_class: managed workflow contract surface
- workflow_failure: Derived restart surfaces disagree with canonical workflow state, so resume guidance can route work from stale or contradictory facts.

### WFLOW010

- linked_report_1_finding: WFLOW010
- implicated_surface: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces
- ownership_class: managed workflow contract surface
- workflow_failure: Active ticket drift between manifest and workflow state can cause write-lease enforcement against the wrong ticket.

### WFLOW025

- linked_report_1_finding: WFLOW025
- implicated_surface: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces
- ownership_class: managed workflow contract surface
- workflow_failure: Canonical ticket acceptance can drift after acceptance-imprecision intake, leaving artifacts and ticket truth out of sync.

## Ownership Classification

### WFLOW010

- ownership_class: managed workflow contract surface
- affected_surface: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces

### WFLOW010

- ownership_class: managed workflow contract surface
- affected_surface: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces

### WFLOW025

- ownership_class: managed workflow contract surface
- affected_surface: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces

## Root Cause Analysis

### WFLOW010

- root_cause: `START-HERE.md`, `.opencode/state/context-snapshot.md`, and `.opencode/state/latest-handoff.md` are not being regenerated from `tickets/manifest.json`, `.opencode/state/workflow-state.json`, and `.opencode/meta/pivot-state.json` after workflow mutations or managed repair, leaving bootstrap, repair-follow-on, pivot, verification, lane-lease, or active-ticket state stale.
- safer_target_pattern: Regenerate `START-HERE.md`, `.opencode/state/context-snapshot.md`, and `.opencode/state/latest-handoff.md` from canonical manifest, workflow state, and pivot state after every workflow save, compute handoff readiness from bootstrap plus repair-follow-on plus verification state in one shared contract, and fail repair verification if any derived restart surface drifts.
- how_the_workflow_allowed_it: Derived restart surfaces disagree with canonical workflow state, so resume guidance can route work from stale or contradictory facts.

### WFLOW010

- root_cause: When manifest.active_ticket and workflow.active_ticket diverge after a ticket closeout and activation, tools that check workflow.active_ticket (such as ensureWriteLease in stage-gate-enforcer) will validate leases against the stale ticket. This blocks artifact writes for the newly active ticket even though a valid lease exists.
- safer_target_pattern: Keep manifest.active_ticket and workflow.active_ticket synchronized through ticket_update activate calls. EnsureWriteLease should accept an optional target-ticket parameter so artifact tools can validate against the correct ticket instead of the workflow-level active ticket.
- how_the_workflow_allowed_it: Active ticket drift between manifest and workflow state can cause write-lease enforcement against the wrong ticket.

### WFLOW025

- root_cause: A historical ticket was invalidated by `acceptance_imprecision`, but there is no current acceptance-refresh proof (or the workflow still marks refresh pending). That means implementation/review artifacts may be relying on revised criteria that never became canonical in `tickets/manifest.json` and ticket markdown.
- safer_target_pattern: When `issue_intake` invalidates a ticket because the accepted contract is wrong or imprecise, require the team leader to run `ticket_update(acceptance=[...])`, persist an acceptance-refresh artifact, and block review/closeout/handoff until that canonical refresh is complete.
- how_the_workflow_allowed_it: Canonical ticket acceptance can drift after acceptance-imprecision intake, leaving artifacts and ticket truth out of sync.


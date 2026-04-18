# Scafforge Process Failures

## Scope

- Maps each validated finding back to the Scafforge-owned workflow surface that allowed it through.

## Failure Map

### WFLOW025

- linked_report_1_finding: WFLOW025
- implicated_surface: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces
- ownership_class: managed workflow contract surface
- workflow_failure: Canonical ticket acceptance can drift after acceptance-imprecision intake, leaving artifacts and ticket truth out of sync.

## Ownership Classification

### WFLOW025

- ownership_class: managed workflow contract surface
- affected_surface: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces

## Root Cause Analysis

### WFLOW025

- root_cause: A historical ticket was invalidated by `acceptance_imprecision`, but there is no current acceptance-refresh proof (or the workflow still marks refresh pending). That means implementation/review artifacts may be relying on revised criteria that never became canonical in `tickets/manifest.json` and ticket markdown.
- safer_target_pattern: When `issue_intake` invalidates a ticket because the accepted contract is wrong or imprecise, require the team leader to run `ticket_update(acceptance=[...])`, persist an acceptance-refresh artifact, and block review/closeout/handoff until that canonical refresh is complete.
- how_the_workflow_allowed_it: Canonical ticket acceptance can drift after acceptance-imprecision intake, leaving artifacts and ticket truth out of sync.


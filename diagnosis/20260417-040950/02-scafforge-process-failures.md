# Scafforge Process Failures

## Scope

- Maps each validated finding back to the Scafforge-owned workflow surface that allowed it through.

## Failure Map

### WFLOW025

- linked_report_1_finding: WFLOW025
- implicated_surface: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces
- ownership_class: managed workflow contract surface
- workflow_failure: Canonical ticket acceptance can drift after acceptance-imprecision intake, leaving artifacts and ticket truth out of sync.

### SKILL001

- linked_report_1_finding: SKILL001
- implicated_surface: project-skill-bootstrap and agent-prompt-engineering surfaces
- ownership_class: project skill or prompt surface
- workflow_failure: One or more repo-local skills still contain generic placeholder text or stale synthesized guidance instead of current project-specific procedure.

## Ownership Classification

### WFLOW025

- ownership_class: managed workflow contract surface
- affected_surface: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces

### SKILL001

- ownership_class: project skill or prompt surface
- affected_surface: project-skill-bootstrap and agent-prompt-engineering surfaces

## Root Cause Analysis

### WFLOW025

- root_cause: A historical ticket was invalidated by `acceptance_imprecision`, but there is no current acceptance-refresh proof (or the workflow still marks refresh pending). That means implementation/review artifacts may be relying on revised criteria that never became canonical in `tickets/manifest.json` and ticket markdown.
- safer_target_pattern: When `issue_intake` invalidates a ticket because the accepted contract is wrong or imprecise, require the team leader to run `ticket_update(acceptance=[...])`, persist an acceptance-refresh artifact, and block review/closeout/handoff until that canonical refresh is complete.
- how_the_workflow_allowed_it: Canonical ticket acceptance can drift after acceptance-imprecision intake, leaving artifacts and ticket truth out of sync.

### SKILL001

- root_cause: project-skill-bootstrap or later managed-surface repair left repo-local skills in a placeholder or stale state, so agents lose concrete stack, validation, or asset-workflow guidance.
- safer_target_pattern: Populate every required repo-local skill with concrete current rules and validation commands; generated `.opencode/skills/` files must not retain template filler or stale synthesized workflow guidance.
- how_the_workflow_allowed_it: One or more repo-local skills still contain generic placeholder text or stale synthesized guidance instead of current project-specific procedure.


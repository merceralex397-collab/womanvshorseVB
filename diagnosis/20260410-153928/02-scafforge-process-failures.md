# Scafforge Process Failures

## Scope

- Maps each validated finding back to the Scafforge-owned workflow surface that allowed it through.

## Failure Map

### EXEC-GODOT-005a

- linked_report_1_finding: EXEC-GODOT-005a
- implicated_surface: generated repo implementation and validation surfaces
- ownership_class: generated repo execution surface
- workflow_failure: Android-targeted Godot repo is missing export surfaces or debug APK runnable proof.

### EXEC-REMED-001

- linked_report_1_finding: EXEC-REMED-001
- implicated_surface: repo-scaffold-factory managed template surfaces
- ownership_class: generated repo execution surface
- workflow_failure: Remediation review artifact does not contain runnable command evidence.

### SESSION002

- linked_report_1_finding: SESSION002
- implicated_surface: scafforge-audit transcript chronology and causal diagnosis surfaces
- ownership_class: audit and lifecycle diagnosis surface
- workflow_failure: The supplied session transcript shows repeated retries of the same rejected lifecycle transition.

### SKILL001

- linked_report_1_finding: SKILL001
- implicated_surface: project-skill-bootstrap and agent-prompt-engineering surfaces
- ownership_class: project skill or prompt surface
- workflow_failure: One or more repo-local skills still contain generic placeholder text instead of project-specific guidance.

## Ownership Classification

### SESSION002

- ownership_class: audit and lifecycle diagnosis surface
- affected_surface: scafforge-audit transcript chronology and causal diagnosis surfaces

### EXEC-GODOT-005a

- ownership_class: generated repo execution surface
- affected_surface: generated repo implementation and validation surfaces

### EXEC-REMED-001

- ownership_class: generated repo execution surface
- affected_surface: repo-scaffold-factory managed template surfaces

### SKILL001

- ownership_class: project skill or prompt surface
- affected_surface: project-skill-bootstrap and agent-prompt-engineering surfaces

## Root Cause Analysis

### EXEC-GODOT-005a

- root_cause: The repo has started or closed Android release work but is still missing the repo-managed export preset, android/ support surfaces, or the canonical debug APK. Runnable proof requires export_presets.cfg, non-placeholder android/ surfaces, and a debug APK at the canonical build path.
- safer_target_pattern: Emit export_presets.cfg and android/ surfaces at scaffold time. Block RELEASE-001 closeout until debug APK runnable proof exists at the canonical path.
- how_the_workflow_allowed_it: Android-targeted Godot repo is missing export surfaces or debug APK runnable proof.

### EXEC-REMED-001

- root_cause: A ticket created from a validated finding is being reviewed on prose alone, so the audit cannot confirm that the original failing command or canonical acceptance command was actually rerun after the fix.
- safer_target_pattern: For remediation tickets with `finding_source`, require the review artifact to record the exact command run, include raw command output, and state the explicit PASS/FAIL result before the review counts as trustworthy closure.
- how_the_workflow_allowed_it: Remediation review artifact does not contain runnable command evidence.

### SESSION002

- root_cause: Instead of treating the repeated `ticket_update` rejection as a contract contradiction, the agent kept probing the state machine and burned time without acquiring new evidence.
- safer_target_pattern: After the same lifecycle blocker repeats, re-run `ticket_lookup`, read `transition_guidance`, load `ticket-execution` if needed, and stop with a blocker instead of retrying the same transition.
- how_the_workflow_allowed_it: The supplied session transcript shows repeated retries of the same rejected lifecycle transition.

### SKILL001

- root_cause: project-skill-bootstrap or later managed-surface repair left baseline local skills in a scaffold placeholder state, so agents lose concrete stack and validation guidance.
- safer_target_pattern: Populate every baseline local skill with concrete repo-specific rules and validation commands; generated `.opencode/skills/` files must not retain template filler.
- how_the_workflow_allowed_it: One or more repo-local skills still contain generic placeholder text instead of project-specific guidance.


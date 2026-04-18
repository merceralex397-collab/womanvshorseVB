# Scafforge Process Failures

## Scope

- Maps each validated finding back to the Scafforge-owned workflow surface that allowed it through.

## Failure Map

### BOOT003

- linked_report_1_finding: BOOT003
- implicated_surface: managed bootstrap tool and bootstrap-facing workflow guidance
- ownership_class: generated repo source and configuration surfaces
- workflow_failure: The generated bootstrap freshness contract cannot detect host drift for this repo.

### EXEC-REMED-001

- linked_report_1_finding: EXEC-REMED-001
- implicated_surface: repo-scaffold-factory managed template surfaces
- ownership_class: generated repo execution surface
- workflow_failure: Remediation review artifact does not contain runnable command evidence.

### EXEC-REMED-001

- linked_report_1_finding: EXEC-REMED-001
- implicated_surface: repo-scaffold-factory managed template surfaces
- ownership_class: generated repo execution surface
- workflow_failure: Remediation review artifact does not contain runnable command evidence.

### FINISH004

- linked_report_1_finding: FINISH004
- implicated_surface: ticket-pack-builder and ticket contract surfaces
- ownership_class: managed workflow contract surface
- workflow_failure: Interactive consumer-facing repo still relies on a weak generic finish bar instead of explicit interaction-proof requirements.

## Ownership Classification

### EXEC-REMED-001

- ownership_class: generated repo execution surface
- affected_surface: repo-scaffold-factory managed template surfaces

### EXEC-REMED-001

- ownership_class: generated repo execution surface
- affected_surface: repo-scaffold-factory managed template surfaces

### BOOT003

- ownership_class: generated repo source and configuration surfaces
- affected_surface: managed bootstrap tool and bootstrap-facing workflow guidance

### FINISH004

- ownership_class: managed workflow contract surface
- affected_surface: ticket-pack-builder and ticket contract surfaces

## Root Cause Analysis

### BOOT003

- root_cause: The recorded bootstrap fingerprint is the empty-hash sentinel even though the repo exposes meaningful bootstrap surfaces. That means the generated workflow was hashing an incomplete input set and can leave bootstrap status stale after moving machines or fixing host prerequisites.
- safer_target_pattern: Hash stack-sensitive repo surfaces plus host-side prerequisite signals so bootstrap becomes stale when the machine setup changes, then rerun environment_bootstrap after package repair installs the stronger freshness model.
- how_the_workflow_allowed_it: The generated bootstrap freshness contract cannot detect host drift for this repo.

### EXEC-REMED-001

- root_cause: A ticket created from a validated finding is being reviewed on prose alone, so the audit cannot confirm that the original failing command or canonical acceptance command was actually rerun after the fix.
- safer_target_pattern: For remediation tickets with `finding_source`, require the review artifact to record the exact command run, include raw command output, and state the explicit PASS/FAIL result before the review counts as trustworthy closure.
- how_the_workflow_allowed_it: Remediation review artifact does not contain runnable command evidence.

### EXEC-REMED-001

- root_cause: A ticket created from a validated finding is being reviewed on prose alone, so the audit cannot confirm that the original failing command or canonical acceptance command was actually rerun after the fix.
- safer_target_pattern: For remediation tickets with `finding_source`, require the review artifact to record the exact command run, include raw command output, and state the explicit PASS/FAIL result before the review counts as trustworthy closure.
- how_the_workflow_allowed_it: Remediation review artifact does not contain runnable command evidence.

### FINISH004

- root_cause: Older Scafforge-generated finish contracts and finish-validation tickets could prove only that a build exists, not that the shipped interaction loop and visible user-facing state were actually demonstrated. That leaves low-quality interactive products able to look complete through generic prose.
- safer_target_pattern: Replace generic machine-generated finish_acceptance_signals with repo-specific interactive proof requirements, and require FINISH-VALIDATE-001 to demand user-observable interaction evidence in addition to load/export proof.
- how_the_workflow_allowed_it: Interactive consumer-facing repo still relies on a weak generic finish bar instead of explicit interaction-proof requirements.


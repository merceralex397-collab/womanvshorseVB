# Scafforge Process Failures

## Scope

- Maps each validated finding back to the Scafforge-owned workflow surface that allowed it through.

## Failure Map

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

### EXEC-REMED-001

- linked_report_1_finding: EXEC-REMED-001
- implicated_surface: repo-scaffold-factory managed template surfaces
- ownership_class: generated repo execution surface
- workflow_failure: Remediation review artifact does not contain runnable command evidence.

### FINISH003

- linked_report_1_finding: FINISH003
- implicated_surface: ticket-pack-builder and ticket contract surfaces
- ownership_class: managed workflow contract surface
- workflow_failure: Consumer-facing repo records a Product Finish Contract but is missing the finish-validation workflow lane that proves it.

### WFLOW026

- linked_report_1_finding: WFLOW026
- implicated_surface: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces
- ownership_class: managed workflow contract surface
- workflow_failure: Current artifacts contain explicit verdict headings or labels, but the generated verdict extractor still reports them as unclear.

### EXEC-GODOT-008

- linked_report_1_finding: EXEC-GODOT-008
- implicated_surface: generated repo implementation and validation surfaces
- ownership_class: generated repo execution surface
- workflow_failure: Godot headless load only succeeds by falling back from stale resource UIDs.

## Ownership Classification

### EXEC-GODOT-008

- ownership_class: generated repo execution surface
- affected_surface: generated repo implementation and validation surfaces

### EXEC-REMED-001

- ownership_class: generated repo execution surface
- affected_surface: repo-scaffold-factory managed template surfaces

### EXEC-REMED-001

- ownership_class: generated repo execution surface
- affected_surface: repo-scaffold-factory managed template surfaces

### EXEC-REMED-001

- ownership_class: generated repo execution surface
- affected_surface: repo-scaffold-factory managed template surfaces

### FINISH003

- ownership_class: managed workflow contract surface
- affected_surface: ticket-pack-builder and ticket contract surfaces

### WFLOW026

- ownership_class: managed workflow contract surface
- affected_surface: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces

## Root Cause Analysis

### EXEC-REMED-001

- root_cause: A ticket created from a validated finding is being reviewed on prose alone, so the audit cannot confirm that the original failing command or canonical acceptance command was actually rerun after the fix.
- safer_target_pattern: For remediation tickets with `finding_source`, require the review artifact to record the exact command run, include raw command output, and state the explicit PASS/FAIL result before the review counts as trustworthy closure.
- how_the_workflow_allowed_it: Remediation review artifact does not contain runnable command evidence.

### EXEC-REMED-001

- root_cause: A ticket created from a validated finding is being reviewed on prose alone, so the audit cannot confirm that the original failing command or canonical acceptance command was actually rerun after the fix.
- safer_target_pattern: For remediation tickets with `finding_source`, require the review artifact to record the exact command run, include raw command output, and state the explicit PASS/FAIL result before the review counts as trustworthy closure.
- how_the_workflow_allowed_it: Remediation review artifact does not contain runnable command evidence.

### EXEC-REMED-001

- root_cause: A ticket created from a validated finding is being reviewed on prose alone, so the audit cannot confirm that the original failing command or canonical acceptance command was actually rerun after the fix.
- safer_target_pattern: For remediation tickets with `finding_source`, require the review artifact to record the exact command run, include raw command output, and state the explicit PASS/FAIL result before the review counts as trustworthy closure.
- how_the_workflow_allowed_it: Remediation review artifact does not contain runnable command evidence.

### FINISH003

- root_cause: The canonical brief declares finish acceptance signals, but the ticket graph does not guarantee a dedicated finish-validation owner or release dependency. Older repos can then close release work without any first-class lane that proves the recorded finish bar.
- safer_target_pattern: Seed FINISH-VALIDATE-001 for consumer-facing repos whenever the Product Finish Contract records finish_acceptance_signals, and require RELEASE-001 to depend on that finish-validation lane before closeout.
- how_the_workflow_allowed_it: Consumer-facing repo records a Product Finish Contract but is missing the finish-validation workflow lane that proves it.

### WFLOW026

- root_cause: The repo-local workflow parser does not cover the real artifact verdict forms already present in downstream review and QA artifacts, including markdown-emphasized labels, compact stage headings such as `## QA PASS`, and plain `**Overall**: PASS` labels. Those explicit verdicts then look unparseable and block review or QA transitions even though the artifact body is clear.
- safer_target_pattern: Keep one shared artifact verdict extractor that accepts the real artifact family in use: plain and markdown-emphasized verdict labels, compact `QA/Review + verdict` headings, and `Overall: PASS/FAIL` labels. Route ticket_lookup and ticket_update through that shared parser instead of treating explicit review or QA verdicts as unclear.
- how_the_workflow_allowed_it: Current artifacts contain explicit verdict headings or labels, but the generated verdict extractor still reports them as unclear.

### EXEC-GODOT-008

- root_cause: The project still contains invalid `uid://...` references in scene or resource manifests, so Godot is recovering at runtime by ignoring the recorded UID and loading the text path instead.
- safer_target_pattern: Treat invalid UID fallback warnings as actionable load drift: refresh the affected scene/resource references or import metadata until `godot --headless --path . --quit` succeeds with no UID fallback warnings.
- how_the_workflow_allowed_it: Godot headless load only succeeds by falling back from stale resource UIDs.


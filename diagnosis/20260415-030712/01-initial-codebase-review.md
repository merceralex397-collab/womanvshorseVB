# Initial Codebase Review

## Scope

- subject repo: /home/rowan/womanvshorseVB
- diagnosis timestamp: 2026-04-15T03:07:12Z
- audit scope: managed workflow, restart, ticket, prompt, and execution surfaces
- verification scope: current repo state only

## Result State

- result_state: validated failures found
- finding_count: 4
- errors: 3
- warnings: 1

## Validated Findings

### Workflow Findings

No validated workflow, environment, or managed-process findings were detected.

## Code Quality Findings

### EXEC-REMED-001

- finding_id: EXEC-REMED-001
- summary: Remediation review artifact does not contain runnable command evidence.
- severity: CRITICAL
- evidence_grade: repo-state validation
- affected_files_or_surfaces: tickets/manifest.json, .opencode/state/reviews/remed-001-review-reverification.md
- observed_or_reproduced: A ticket created from a validated finding is being reviewed on prose alone, so the audit cannot confirm that the original failing command or canonical acceptance command was actually rerun after the fix.
- evidence:
  - ticket REMED-001 carries finding_source `EXEC-GODOT-005a`
  - review artifact: .opencode/state/reviews/remed-001-review-reverification.md
  - missing exact command record

### EXEC-REMED-001

- finding_id: EXEC-REMED-001
- summary: Remediation review artifact does not contain runnable command evidence.
- severity: CRITICAL
- evidence_grade: repo-state validation
- affected_files_or_surfaces: tickets/manifest.json, .opencode/state/reviews/remed-002-review-reverification.md
- observed_or_reproduced: A ticket created from a validated finding is being reviewed on prose alone, so the audit cannot confirm that the original failing command or canonical acceptance command was actually rerun after the fix.
- evidence:
  - ticket REMED-002 carries finding_source `EXEC-REMED-001`
  - review artifact: .opencode/state/reviews/remed-002-review-reverification.md
  - missing exact command record

### EXEC-REMED-001

- finding_id: EXEC-REMED-001
- summary: Remediation review artifact does not contain runnable command evidence.
- severity: CRITICAL
- evidence_grade: repo-state validation
- affected_files_or_surfaces: tickets/manifest.json, .opencode/state/reviews/remed-003-review-review.md
- observed_or_reproduced: A ticket created from a validated finding is being reviewed on prose alone, so the audit cannot confirm that the original failing command or canonical acceptance command was actually rerun after the fix.
- evidence:
  - ticket REMED-003 carries finding_source `SESSION002`
  - review artifact: .opencode/state/reviews/remed-003-review-review.md
  - missing exact command record
  - missing raw command output evidence
  - missing explicit post-fix PASS/FAIL result

### EXEC-GODOT-008

- finding_id: EXEC-GODOT-008
- summary: Godot headless load only succeeds by falling back from stale resource UIDs.
- severity: WARNING
- evidence_grade: repo-state validation
- affected_files_or_surfaces: project.godot
- observed_or_reproduced: The project still contains invalid `uid://...` references in scene or resource manifests, so Godot is recovering at runtime by ignoring the recorded UID and loading the text path instead.
- evidence:
  - WARNING: res://scenes/ui/title_screen.tscn:4 - ext_resource, invalid UID: uid://c5qm5g68f3q2x - using text path instead: res://assets/sprites/ui/button_square_gloss.png

## Verification Gaps

- The diagnosis pack validates the concrete failures above. It does not claim broader runtime-path coverage than the current audit and supporting evidence actually exercised.


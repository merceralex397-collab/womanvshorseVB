# Initial Codebase Review

## Scope

- subject repo: /home/rowan/womanvshorseVB
- diagnosis timestamp: 2026-04-15T03:00:20Z
- audit scope: managed workflow, restart, ticket, prompt, and execution surfaces
- verification scope: current repo state only

## Result State

- result_state: validated failures found
- finding_count: 8
- errors: 5
- warnings: 3

## Validated Findings

### Workflow Findings

### FINISH003

- finding_id: FINISH003
- summary: Consumer-facing repo records a Product Finish Contract but is missing the finish-validation workflow lane that proves it.
- severity: error
- evidence_grade: repo-state validation
- affected_files_or_surfaces: docs/spec/CANONICAL-BRIEF.md, tickets/manifest.json
- observed_or_reproduced: The canonical brief declares finish acceptance signals, but the ticket graph does not guarantee a dedicated finish-validation owner or release dependency. Older repos can then close release work without any first-class lane that proves the recorded finish bar.
- evidence:
  - tickets/manifest.json has no FINISH-VALIDATE-001 even though the canonical brief records finish_acceptance_signals.
- remaining_verification_gap: None recorded beyond the validated finding scope.

### WFLOW026

- finding_id: WFLOW026
- summary: Current artifacts contain explicit verdict headings or labels, but the generated verdict extractor still reports them as unclear.
- severity: error
- evidence_grade: repo-state validation
- affected_files_or_surfaces: .opencode/lib/workflow.ts, tickets/manifest.json, .opencode/state/artifacts/history/core-001/qa/2026-04-10T05-33-28-878Z-qa.md, .opencode/state/artifacts/history/core-001/review/2026-04-10T11-01-03-139Z-backlog-verification.md, .opencode/state/artifacts/history/core-002/qa/2026-04-10T05-50-18-546Z-qa.md, .opencode/state/artifacts/history/core-002/review/2026-04-10T11-00-55-115Z-backlog-verification.md, .opencode/state/artifacts/history/core-003/qa/2026-04-10T12-20-37-063Z-qa.md, .opencode/state/artifacts/history/core-006/review/2026-04-10T12-32-47-750Z-review.md, .opencode/state/artifacts/history/core-006/qa/2026-04-10T12-34-16-265Z-qa.md, .opencode/state/artifacts/history/ui-002/qa/2026-04-10T14-56-04-176Z-qa.md, .opencode/state/artifacts/history/remed-002/qa/2026-04-11T13-53-52-706Z-qa.md
- observed_or_reproduced: The repo-local workflow parser does not cover the real artifact verdict forms already present in downstream review and QA artifacts, including markdown-emphasized labels, compact stage headings such as `## QA PASS`, and plain `**Overall**: PASS` labels. Those explicit verdicts then look unparseable and block review or QA transitions even though the artifact body is clear.
- evidence:
  - .opencode/state/artifacts/history/core-001/qa/2026-04-10T05-33-28-878Z-qa.md contains `**Result**: PASS`, but .opencode/lib/workflow.ts still lacks parser coverage for that explicit verdict form.
  - .opencode/state/artifacts/history/core-001/review/2026-04-10T11-01-03-139Z-backlog-verification.md contains `**Result**: PASS`, but .opencode/lib/workflow.ts still lacks parser coverage for that explicit verdict form.
  - .opencode/state/artifacts/history/core-002/qa/2026-04-10T05-50-18-546Z-qa.md contains `**Result**: PASS`, but .opencode/lib/workflow.ts still lacks parser coverage for that explicit verdict form.
  - .opencode/state/artifacts/history/core-002/review/2026-04-10T11-00-55-115Z-backlog-verification.md contains `**Result**: PASS`, but .opencode/lib/workflow.ts still lacks parser coverage for that explicit verdict form.
  - .opencode/state/artifacts/history/core-003/qa/2026-04-10T12-20-37-063Z-qa.md contains `**Result**: PASS`, but .opencode/lib/workflow.ts still lacks parser coverage for that explicit verdict form.
  - .opencode/state/artifacts/history/core-006/review/2026-04-10T12-32-47-750Z-review.md contains `**Result**: PASS`, but .opencode/lib/workflow.ts still lacks parser coverage for that explicit verdict form.
  - .opencode/state/artifacts/history/core-006/qa/2026-04-10T12-34-16-265Z-qa.md contains `**Result**: PASS`, but .opencode/lib/workflow.ts still lacks parser coverage for that explicit verdict form.
  - .opencode/state/artifacts/history/ui-002/qa/2026-04-10T14-56-04-176Z-qa.md contains `## QA FAIL`, but .opencode/lib/workflow.ts still lacks parser coverage for that explicit verdict form.
- remaining_verification_gap: None recorded beyond the validated finding scope.

### CONFIG010

- finding_id: CONFIG010
- summary: A managed game repo is missing canonical asset-pipeline starter surfaces.
- severity: warning
- evidence_grade: repo-state validation
- affected_files_or_surfaces: assets/briefs, assets/models, assets/themes, assets/previews, assets/workfiles, assets/licenses, assets/import-reports, assets/pipeline.json, assets/briefs/README.md, .opencode/meta/asset-pipeline-bootstrap.json
- observed_or_reproduced: Legacy scaffold or repair runs did not propagate the deterministic asset route metadata and starter layout into the repo.
- evidence:
  - Missing asset starter surfaces: assets/briefs, assets/models, assets/themes, assets/previews, assets/workfiles, assets/licenses, assets/import-reports, assets/pipeline.json, assets/briefs/README.md, .opencode/meta/asset-pipeline-bootstrap.json
  - Invalid asset starter surfaces: assets/pipeline.json, .opencode/meta/asset-pipeline-bootstrap.json, assets/PROVENANCE.md
- remaining_verification_gap: None recorded beyond the validated finding scope.

### CONFIG011

- finding_id: CONFIG011
- summary: blender_agent is enabled for a repo whose current asset route does not require Blender-MCP.
- severity: warning
- evidence_grade: repo-state validation
- affected_files_or_surfaces: opencode.jsonc
- observed_or_reproduced: The generated OpenCode configuration is coupling Blender enablement to host discovery instead of the repo's canonical asset strategy.
- evidence:
  - Expected blender route: False
  - blender_agent.enabled = True
  - Preview pipeline route mode: hybrid
  - Expected primary routes: {'characters': 'third-party-open-licensed', 'environments': 'godot-native-authored', 'props': 'third-party-open-licensed', 'ui': 'godot-native-authored', 'audio': 'third-party-open-licensed', 'vfx': 'godot-native-authored'}
- remaining_verification_gap: None recorded beyond the validated finding scope.

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


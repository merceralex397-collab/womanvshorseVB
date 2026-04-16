# Live Repo Repair Plan

## Preconditions

- Repo: /home/rowan/womanvshorseVB
- Audit stayed non-mutating. No repo or product-code edits were made by this diagnosis run.

## Triage Order

- package_first_count: 0
- subject_repo_follow_up_count: 4
- host_or_manual_prerequisite_count: 0

## Package Changes Required First

- None recorded.

## Post-Update Repair Actions

- Route 1 workflow-layer finding(s) into `scafforge-repair` for deterministic managed-surface refresh.

### REMED-012

- linked_report_id: CONFIG010
- action_type: safe Scafforge package change
- should_scafforge_repair_run: yes
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: Backfill the rendered asset starter surfaces from the current package during managed repair and keep them aligned to the canonical finish contract.

## Ticket Follow-Up

### REMED-004

- linked_report_id: EXEC-REMED-001
- action_type: generated-repo remediation ticket/process repair
- should_scafforge_repair_run: only after managed workflow repair converges
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: For remediation tickets with `finding_source`, require the review artifact to record the exact command run, include raw command output, and state the explicit PASS/FAIL result before the review counts as trustworthy closure.
- assignee: implementer
- suggested_fix_approach: For remediation tickets with `finding_source`, require the review artifact to record the exact command run, include raw command output, and state the explicit PASS/FAIL result before the review counts as trustworthy closure.

### REMED-005

- linked_report_id: EXEC-REMED-001
- action_type: generated-repo remediation ticket/process repair
- should_scafforge_repair_run: only after managed workflow repair converges
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: For remediation tickets with `finding_source`, require the review artifact to record the exact command run, include raw command output, and state the explicit PASS/FAIL result before the review counts as trustworthy closure.
- assignee: implementer
- suggested_fix_approach: For remediation tickets with `finding_source`, require the review artifact to record the exact command run, include raw command output, and state the explicit PASS/FAIL result before the review counts as trustworthy closure.

### REMED-006

- linked_report_id: EXEC-REMED-001
- action_type: generated-repo remediation ticket/process repair
- should_scafforge_repair_run: only after managed workflow repair converges
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: For remediation tickets with `finding_source`, require the review artifact to record the exact command run, include raw command output, and state the explicit PASS/FAIL result before the review counts as trustworthy closure.
- assignee: implementer
- suggested_fix_approach: For remediation tickets with `finding_source`, require the review artifact to record the exact command run, include raw command output, and state the explicit PASS/FAIL result before the review counts as trustworthy closure.

### REMED-013

- linked_report_id: EXEC-GODOT-008
- action_type: generated-repo remediation ticket/process repair
- should_scafforge_repair_run: only after managed workflow repair converges
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: Batch the related warning-level findings for generated repo implementation and validation surfaces into one remediation ticket instead of fragmenting the queue.
- assignee: implementer
- suggested_fix_approach: Rerun the relevant build, lint, reference-integrity, and verification commands after fixing the grouped findings.

## Reverification Plan

- After package-side fixes land, run one fresh audit on the subject repo before applying another repair cycle.
- After managed repair, rerun the public repair verifier and confirm restart surfaces, ticket routing, and any historical trust restoration paths match the current canonical state.
- Do not treat restart prose alone as proof; the canonical manifest and workflow state remain the source of truth.


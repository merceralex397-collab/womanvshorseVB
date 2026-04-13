# Live Repo Repair Plan

## Preconditions

- Repo: /home/pc/projects/womanvshorseVB
- Audit stayed non-mutating. No repo or product-code edits were made by this diagnosis run.

## Triage Order

- package_first_count: 0
- subject_repo_follow_up_count: 3
- host_or_manual_prerequisite_count: 0

## Package Changes Required First

- None recorded.

## Post-Update Repair Actions

- Route 1 workflow-layer finding(s) into `scafforge-repair` for deterministic managed-surface refresh.

### REMED-003

- linked_report_id: FINISH002
- action_type: safe Scafforge package change
- should_scafforge_repair_run: yes
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: Either close or supersede the open finish tickets with real content proof, or update the restart narrative to stop claiming finished-product ready state until the finish bar is met.

## Ticket Follow-Up

### REMED-001

- linked_report_id: EXEC-GODOT-005a
- action_type: generated-repo remediation ticket/process repair
- should_scafforge_repair_run: only after managed workflow repair converges
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: Emit export_presets.cfg and android/ surfaces at scaffold time. Block RELEASE-001 closeout until debug APK runnable proof exists at the canonical path.
- assignee: implementer
- suggested_fix_approach: Emit export_presets.cfg and android/ surfaces at scaffold time. Block RELEASE-001 closeout until debug APK runnable proof exists at the canonical path.

### REMED-002

- linked_report_id: EXEC-REMED-001
- action_type: generated-repo remediation ticket/process repair
- should_scafforge_repair_run: only after managed workflow repair converges
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: For remediation tickets with `finding_source`, require the review artifact to record the exact command run, include raw command output, and state the explicit PASS/FAIL result before the review counts as trustworthy closure.
- assignee: implementer
- suggested_fix_approach: For remediation tickets with `finding_source`, require the review artifact to record the exact command run, include raw command output, and state the explicit PASS/FAIL result before the review counts as trustworthy closure.

### REMED-004

- linked_report_id: SESSION002
- action_type: generated-repo remediation ticket/process repair
- should_scafforge_repair_run: only after managed workflow repair converges
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: After the same lifecycle blocker repeats, re-run `ticket_lookup`, read `transition_guidance`, load `ticket-execution` if needed, and stop with a blocker instead of retrying the same transition.
- assignee: implementer
- suggested_fix_approach: After the same lifecycle blocker repeats, re-run `ticket_lookup`, read `transition_guidance`, load `ticket-execution` if needed, and stop with a blocker instead of retrying the same transition.

## Reverification Plan

- After package-side fixes land, run one fresh audit on the subject repo before applying another repair cycle.
- After managed repair, rerun the public repair verifier and confirm restart surfaces, ticket routing, and any historical trust restoration paths match the current canonical state.
- Do not treat restart prose alone as proof; the canonical manifest and workflow state remain the source of truth.


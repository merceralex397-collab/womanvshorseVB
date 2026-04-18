# Live Repo Repair Plan

## Preconditions

- Repo: /home/rowan/womanvshorseVB
- Audit stayed non-mutating. No repo or product-code edits were made by this diagnosis run.

## Triage Order

- package_first_count: 0
- subject_repo_follow_up_count: 3
- host_or_manual_prerequisite_count: 0

## Package Changes Required First

- None recorded.

## Post-Update Repair Actions

- Route 2 workflow-layer finding(s) into `scafforge-repair` for deterministic managed-surface refresh.

### REMED-013

- linked_report_id: BOOT003
- action_type: safe Scafforge package change
- should_scafforge_repair_run: yes
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: Hash stack-sensitive repo surfaces plus host-side prerequisite signals so bootstrap becomes stale when the machine setup changes, then rerun environment_bootstrap after package repair installs the stronger freshness model.

### REMED-017

- linked_report_id: FINISH004
- action_type: safe Scafforge package change
- should_scafforge_repair_run: yes
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: Replace generic machine-generated finish_acceptance_signals with repo-specific interactive proof requirements, and require FINISH-VALIDATE-001 to demand user-observable interaction evidence in addition to load/export proof.

## Ticket Follow-Up

### REMED-014

- linked_report_id: EXEC-GODOT-010
- action_type: generated-repo remediation ticket/process repair
- should_scafforge_repair_run: only after managed workflow repair converges
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: When a gameplay controller exposes start_wave() and wave_started, make one canonical runtime owner call start_wave() so the primary progression loop actually begins on the current build.
- assignee: implementer
- suggested_fix_approach: When a gameplay controller exposes start_wave() and wave_started, make one canonical runtime owner call start_wave() so the primary progression loop actually begins on the current build.

### REMED-015

- linked_report_id: EXEC-GODOT-011
- action_type: generated-repo remediation ticket/process repair
- should_scafforge_repair_run: only after managed workflow repair converges
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: If the repo ships a game-over scene or equivalent fail-state surface, route death/failure handlers into that scene instead of silently reloading the current level.
- assignee: implementer
- suggested_fix_approach: If the repo ships a game-over scene or equivalent fail-state surface, route death/failure handlers into that scene instead of silently reloading the current level.

### REMED-016

- linked_report_id: EXEC-GODOT-012
- action_type: generated-repo remediation ticket/process repair
- should_scafforge_repair_run: only after managed workflow repair converges
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: When HUD or game-over surfaces read autoload gameplay state, ensure runtime scripts write those fields directly or call the singleton's mutator methods on the current gameplay path before claiming completion.
- assignee: implementer
- suggested_fix_approach: When HUD or game-over surfaces read autoload gameplay state, ensure runtime scripts write those fields directly or call the singleton's mutator methods on the current gameplay path before claiming completion.

## Reverification Plan

- After package-side fixes land, run one fresh audit on the subject repo before applying another repair cycle.
- After managed repair, rerun the public repair verifier and confirm restart surfaces, ticket routing, and any historical trust restoration paths match the current canonical state.
- Do not treat restart prose alone as proof; the canonical manifest and workflow state remain the source of truth.


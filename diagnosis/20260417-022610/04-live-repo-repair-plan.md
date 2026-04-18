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

- Route 1 workflow-layer finding(s) into `scafforge-repair` for deterministic managed-surface refresh.

- After deterministic repair, rerun project-local skill regeneration, agent-team follow-up, and prompt hardening before handoff.

### REMED-025

- linked_report_id: SKILL001
- action_type: safe Scafforge package change
- should_scafforge_repair_run: yes
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: Populate every required repo-local skill with concrete current rules and validation commands; generated `.opencode/skills/` files must not retain template filler or stale synthesized workflow guidance.

## Ticket Follow-Up

### REMED-013

- linked_report_id: EXEC-GODOT-010
- action_type: generated-repo remediation ticket or repo-owned follow-up
- should_scafforge_repair_run: no further managed repair required before this follow-up
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: When a gameplay controller exposes start_wave() and wave_started, make one canonical runtime owner call start_wave() so the primary progression loop actually begins on the current build.
- assignee: implementer
- suggested_fix_approach: When a gameplay controller exposes start_wave() and wave_started, make one canonical runtime owner call start_wave() so the primary progression loop actually begins on the current build.

### REMED-014

- linked_report_id: EXEC-GODOT-011
- action_type: generated-repo remediation ticket or repo-owned follow-up
- should_scafforge_repair_run: no further managed repair required before this follow-up
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: If the repo ships a game-over scene or equivalent fail-state surface, route death/failure handlers into that scene instead of silently reloading the current level.
- assignee: implementer
- suggested_fix_approach: If the repo ships a game-over scene or equivalent fail-state surface, route death/failure handlers into that scene instead of silently reloading the current level.

### REMED-024

- linked_report_id: EXEC-GODOT-012
- action_type: generated-repo remediation ticket or repo-owned follow-up
- should_scafforge_repair_run: no further managed repair required before this follow-up
- carry_diagnosis_pack_into_scafforge_first: no
- target_repo: subject repo
- summary: When HUD or game-over surfaces read autoload gameplay state, ensure runtime scripts write those fields directly or call the singleton's mutator methods on the current gameplay path before claiming completion.
- assignee: implementer
- suggested_fix_approach: When HUD or game-over surfaces read autoload gameplay state, ensure runtime scripts write those fields directly or call the singleton's mutator methods on the current gameplay path before claiming completion.

## Reverification Plan

- After package-side fixes land, run one fresh audit on the subject repo before applying another repair cycle.
- After managed repair, rerun the public repair verifier and confirm restart surfaces, ticket routing, and any historical trust restoration paths match the current canonical state.
- Do not treat restart prose alone as proof; the canonical manifest and workflow state remain the source of truth.


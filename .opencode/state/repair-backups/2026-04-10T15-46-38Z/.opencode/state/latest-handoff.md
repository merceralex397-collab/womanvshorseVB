# START HERE

<!-- SCAFFORGE:START_HERE_BLOCK START -->
## What This Repo Is

Woman vs Horse VB

## Current State

The repo is operating under the managed OpenCode workflow. Use the canonical state files below instead of memory or raw ticket prose.

## Read In This Order

1. README.md
2. AGENTS.md
3. docs/AGENT-DELEGATION.md
4. docs/spec/CANONICAL-BRIEF.md
5. docs/process/workflow.md
6. tickets/manifest.json
7. tickets/BOARD.md

## Current Or Next Ticket

- ID: POLISH-001
- Title: Particle effects
- Wave: 4
- Lane: polish
- Stage: qa
- Status: qa
- Resolution: open
- Verification: suspect

## Dependency Status

- current_ticket_done: no
- dependent_tickets_waiting_on_current: RELEASE-001
- split_child_tickets: REMED-003

## Generation Status

- handoff_status: repair follow-up required
- process_version: 7
- parallel_mode: sequential
- pending_process_verification: true
- repair_follow_on_outcome: managed_blocked
- repair_follow_on_required: true
- repair_follow_on_next_stage: project-skill-bootstrap
- repair_follow_on_verification_passed: false
- repair_follow_on_updated_at: 2026-04-10T15:39:27Z
- pivot_in_progress: false
- pivot_class: none
- pivot_changed_surfaces: none
- pivot_pending_stages: none
- pivot_completed_stages: none
- pivot_pending_ticket_lineage_actions: none
- pivot_completed_ticket_lineage_actions: none
- post_pivot_verification_passed: false
- bootstrap_status: ready
- bootstrap_proof: .opencode/state/artifacts/history/polish-001/bootstrap/2026-04-10T15-04-11-874Z-environment-bootstrap.md
- bootstrap_blockers: none

## Post-Generation Audit Status

- audit_or_repair_follow_up: follow-up required
- reopened_tickets: none
- done_but_not_fully_trusted: CORE-003, CORE-005, CORE-006, UI-001, UI-002
- pending_reverification: none
- repair_follow_on_blockers: project-skill-bootstrap must still run: Repo-local skills still contain generic placeholder/model drift that must be regenerated with project-specific content. | ticket-pack-builder must still run: Repair left remediation or reverification follow-up that must be routed into the repo ticket system. | Post-repair verification failed repair-contract consistency checks: placeholder_local_skills_survived_refresh.
- pivot_pending_stages: none
- pivot_pending_ticket_lineage_actions: none

## Code Quality Status

- last_build_result: unknown @ 2026-04-10T15:10:03.262Z
- last_test_run_result: unknown @ 2026-04-10T15:13:27.744Z
- open_remediation_tickets: 2
- known_reference_integrity_issues: 0

## Known Risks

- Repair follow-on remains incomplete: project-skill-bootstrap must still run: Repo-local skills still contain generic placeholder/model drift that must be regenerated with project-specific content.
- Historical completion should not be treated as fully trusted until pending process verification or explicit reverification is cleared.
- Some done tickets are not fully trusted yet: CORE-003, CORE-005, CORE-006, UI-001, UI-002.
- POLISH-001 is an open split parent; child ticket REMED-003 remain the active foreground work.
- Downstream tickets RELEASE-001 remain formally blocked until POLISH-001 reaches done.

## Next Action

project-skill-bootstrap must still run: Repo-local skills still contain generic placeholder/model drift that must be regenerated with project-specific content.
<!-- SCAFFORGE:START_HERE_BLOCK END -->

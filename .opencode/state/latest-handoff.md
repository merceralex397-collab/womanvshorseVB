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

- ID: ASSET-005
- Title: Source SFX from Freesound.org (CC0)
- Wave: 1
- Lane: asset-sourcing
- Stage: review
- Status: review
- Resolution: open
- Verification: suspect

## Dependency Status

- current_ticket_done: no
- dependent_tickets_waiting_on_current: UI-003
- split_child_tickets: REMED-004, REMED-005, REMED-006

## Generation Status

- handoff_status: workflow verification pending
- process_version: 7
- parallel_mode: sequential
- pending_process_verification: true
- repair_follow_on_outcome: source_follow_up
- repair_follow_on_required: false
- repair_follow_on_next_stage: none
- repair_follow_on_verification_passed: true
- repair_follow_on_updated_at: 2026-04-12T03:09:47Z
- pivot_in_progress: false
- pivot_class: none
- pivot_changed_surfaces: none
- pivot_pending_stages: none
- pivot_completed_stages: none
- pivot_pending_ticket_lineage_actions: none
- pivot_completed_ticket_lineage_actions: none
- post_pivot_verification_passed: false
- bootstrap_status: ready
- bootstrap_proof: .opencode/state/artifacts/history/android-001/bootstrap/2026-04-10T21-55-36-747Z-environment-bootstrap.md
- bootstrap_blockers: none

## Post-Generation Audit Status

- audit_or_repair_follow_up: follow-up required
- reopened_tickets: none
- done_but_not_fully_trusted: POLISH-001, REMED-002, REMED-003
- pending_reverification: none
- repair_follow_on_blockers: none
- pivot_pending_stages: none
- pivot_pending_ticket_lineage_actions: none

## Code Quality Status

- last_build_result: unknown @ 2026-04-11T19:51:28.700Z
- last_test_run_result: pass @ 2026-04-11T19:35:29.273Z
- open_remediation_tickets: 4
- known_reference_integrity_issues: 0

## Known Risks

- Managed repair converged, but source-layer follow-up still remains in the ticket graph.
- Historical completion should not be treated as fully trusted until pending process verification or explicit reverification is cleared.
- Some done tickets are not fully trusted yet: POLISH-001, REMED-002, REMED-003.
- ASSET-005 is an open split parent; child tickets REMED-004, REMED-005, REMED-006 remain the active foreground work.
- Downstream tickets UI-003 remain formally blocked until ASSET-005 reaches done.

## Next Action

Keep ASSET-005 open as a split parent and continue the child ticket lanes: REMED-004, REMED-005, REMED-006.
<!-- SCAFFORGE:START_HERE_BLOCK END -->

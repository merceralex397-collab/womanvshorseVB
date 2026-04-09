# START HERE

<!-- SCAFFORGE:START_HERE_BLOCK START -->
## What This Repo Is

Woman vs Horse VB — A 2D top-down arena action game for Android where a warrior woman fights waves of enemy horses. Built with Godot 4.6, using free/open-source sprites and audio from Kenney.nl, OpenGameArt.org, and Freesound.org.

## Current State

Scaffold complete. Skills populated with Godot 4.6 patterns, free asset sourcing procedures, and MiniMax-M2.7 operating constraints. Ticket pack loaded with 19 tickets across 6 waves. Ready for bootstrap and first ticket execution.

## Read In This Order

1. README.md
2. AGENTS.md
3. docs/AGENT-DELEGATION.md
4. docs/spec/CANONICAL-BRIEF.md
5. docs/process/workflow.md
6. tickets/manifest.json
7. tickets/BOARD.md

## Key Skills

- `godot-android-game` — Godot 4.6 GDScript patterns, scene structure, asset import, Android export
- `free-asset-sourcing` — CC0/CC-BY asset sourcing from Kenney.nl, OpenGameArt.org, Freesound.org
- `model-operating-profile` — MiniMax-M2.7 prompting constraints

## Asset Sourcing Workflow

All art, audio, and fonts come from verified CC0/CC-BY sources. Asset tickets (ASSET-001 through ASSET-005) are in wave 1 and block implementation work. Every asset must have an entry in `assets/PROVENANCE.md`. CC-BY assets require credits in the credits scene (UI-003).

## Current Or Next Ticket

- ID: SETUP-001
- Title: Create main scene with arena
- Wave: 0
- Lane: scene-setup
- Stage: planning
- Status: todo
- Resolution: open
- Verification: suspect

## Dependency Status

- current_ticket_done: no
- dependent_tickets_waiting_on_current: SETUP-002, ANDROID-001, ASSET-001..005
- split_child_tickets: none

## Generation Status

- handoff_status: scaffold complete — bootstrap required
- process_version: 7
- parallel_mode: sequential
- pending_process_verification: false
- repair_follow_on_outcome: clean
- repair_follow_on_required: false
- repair_follow_on_next_stage: none
- repair_follow_on_verification_passed: true
- repair_follow_on_updated_at: Not yet recorded.
- bootstrap_status: missing
- bootstrap_proof: None

## Post-Generation Audit Status

- audit_or_repair_follow_up: none recorded
- reopened_tickets: none
- done_but_not_fully_trusted: none
- pending_reverification: none
- repair_follow_on_blockers: none

## Known Risks

- Validation can fail for environment reasons until bootstrap proof exists.
- Asset sourcing depends on external sites (Kenney.nl, OpenGameArt.org, Freesound.org) being available.
- Horse sprites may be scarce in CC0 top-down packs — may need creative alternatives.
- Delegation mistakes can cause lifecycle loops; check `docs/AGENT-DELEGATION.md` before improvising a new handoff path.

## Next Action

Run `environment_bootstrap`, register its proof artifact, rerun `ticket_lookup`, and do not continue lifecycle work until bootstrap is ready.
<!-- SCAFFORGE:START_HERE_BLOCK END -->

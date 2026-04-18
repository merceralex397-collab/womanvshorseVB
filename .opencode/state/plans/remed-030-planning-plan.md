# Plan for REMED-030

## Finding

- **ID**: WFLOW033
- **Title**: Canonical ticket acceptance can drift after acceptance-imprecision intake, leaving artifacts and ticket truth out of sync
- **Source**: REMED-027 (split_scope, sequential_dependent)

## Summary of the Finding

When `issue_intake` invalidates a ticket because the accepted contract is wrong or imprecise (defect_class: `acceptance_imprecision`), the team leader runs the intake which routes to `invalidates_done`. However, the canonical acceptance list in `tickets/manifest.json` (and the corresponding ticket entry) is **never refreshed** via `ticket_update(acceptance=[...])`. This creates drift:

- The artifacts may show the corrected acceptance criteria
- But the ticket entry in manifest.json still carries the stale/incorrect acceptance
- Downstream tools or agents reading ticket truth see the wrong acceptance

**Real example**: ASSET-005 was invalidated via issue discovery at `.opencode/state/artifacts/history/asset-005/review/2026-04-17T03-31-54-183Z-issue-discovery.md` (defect_class: `acceptance_imprecision`). The acceptance in manifest.json still requires `.wav` files, while the actual resolution used format-agnostic criteria (OGG accepted as equivalent to WAV). The manifest acceptance was never updated after invalidation.

## Current State of Affected Surfaces

### tickets/manifest.json (ASSET-005 entry)
- **Lines 1117-1124**: Still carry the OLD acceptance requiring `.wav` files:
  ```
  "Attack SFX .wav exists in assets/audio/sfx/"
  "Damage/hit SFX .wav exists in assets/audio/sfx/"
  ```
- `resolution_state`: `done` (re-resolved after invalidation)
- `verification_state`: `reverified`
- **This ticket does NOT correct this stale acceptance.** This is a pre-existing residual gap that existed before the discipline rule in this ticket was codified.

### .opencode/state/workflow-state.json
- `ticket_state.ASSET-005.approved_plan`: `true`
- `ticket_state.ASSET-005.reopen_count`: `1`
- No field tracks whether an acceptance-refresh artifact exists or whether acceptance was refreshed post-invalidation
- The drift is invisible to tooling — workflow-state doesn't record that acceptance was refreshed

### Historical evidence (READ-ONLY)
- `.opencode/state/artifacts/history/asset-005/review/2026-04-17T03-31-54-183Z-issue-discovery.md` — captures the invalidation event
- This path is immutable history — do not edit
- Superseding evidence (format-agnostic AC revision) is on the current ASSET-005 ticket artifacts

## Scope of This Fix

This is **purely a future-prevention discipline rule**. This ticket:

1. **DOES**: Document and encode the team-leader discipline rule requiring `ticket_update(acceptance=[...])` immediately after `issue_intake` invalidates for `acceptance_imprecision`
2. **DOES**: Document and encode the requirement that an acceptance-refresh artifact must be persisted before review/closeout/handoff proceeds
3. **DOES NOT**: Correct the stale ASSET-005 manifest acceptance. That pre-existing residual gap is left as-is. A separate follow-up ticket could be created to correct it if needed.

## The Fix: Team-Leader Discipline Rule

### Rule 1: Immediate Acceptance Refresh
When `issue_intake` invalidates a ticket because the accepted contract is wrong or imprecise, the team leader **must** immediately call:
```
ticket_update(ticket_id=<source_ticket_id>, acceptance=[<refreshed_acceptance_list>])
```
This refreshes the canonical acceptance in `tickets/manifest.json`.

### Rule 2: Acceptance-Refresh Artifact Required Before Proceeding
After calling `ticket_update(acceptance=[...])`, the team leader must:
1. Persist an **acceptance-refresh artifact** on the remediation ticket — this artifact records the before/after acceptance and the justification for the change
2. The acceptance-refresh artifact must be registered with `artifact_register(kind: acceptance-refresh)`
3. **Block review/closeout/handoff** of the remediation ticket until the acceptance-refresh artifact exists and is registered

### Rule 3: History Paths Are Read-Only
When a finding cites `.opencode/state/artifacts/history/...`, treat those paths as **read-only evidence sources**. Capture superseding fix evidence on:
- Current writable artifact paths (e.g., `.opencode/state/plans/<ticket_id>-planning-plan.md`)
- Current ticket entry in `tickets/manifest.json` (via `ticket_update`)
- Do NOT edit or create new artifacts under `.opencode/state/artifacts/history/` — those are immutable historical records

### Rule 4: No Dual-Write to Immutable History
Do not create "acceptance refresh" artifacts inside `.opencode/state/artifacts/history/<source_ticket>/`. The history directory is append-only and immutable. The remediation ticket's own artifact path (e.g., `.opencode/state/plans/remed-030-planning-plan.md`) is the appropriate place to record the fix evidence.

## Acceptance Criteria Verification Steps

### AC1: The validated finding WFLOW033 no longer reproduces.

**Verification**:
1. Confirm the team-leader discipline rule is documented in this plan artifact:
   - `ticket_update(acceptance=[...])` must be called immediately after `issue_intake` invalidates for `acceptance_imprecision`
   - Acceptance-refresh artifact must be persisted before review/closeout/handoff
2. Confirm the rule is encoded in the decision_blockers field of this ticket (if applicable) or in process documentation
3. **This is a future-prevention rule** — the stale ASSET-005 manifest acceptance is NOT checked by this AC. That residual gap is outside the scope of this ticket.
4. **Expected**: Rule is documented and encoded → PASS

### AC2: Current quality checks rerun with evidence tied to the fix approach.

**Verification**:
1. Confirm this planning artifact documents the team-leader discipline rule with all four sub-rules
2. Confirm the rule specifies:
   - `ticket_update(acceptance=[...])` must be called immediately after `issue_intake` invalidates for `acceptance_imprecision`
   - Acceptance-refresh artifact must be persisted before review/closeout/handoff
3. Run Godot headless verification (see command below)
4. **Expected**: Godot headless exits 0 — no code changes were needed, this is a process documentation fix

### AC3: History paths are treated as read-only evidence sources.

**Verification**:
1. Confirm no artifact was created or edited under `.opencode/state/artifacts/history/asset-005/`
2. Confirm the fix evidence is captured on this remediation ticket's own artifact paths
3. **Expected**: Fix evidence is on `.opencode/state/plans/remed-030-planning-plan.md` (this artifact) — no mutations to immutable history

## Godot Headless Verification Command

```bash
cd /home/rowan/womanvshorseVB && godot4 --headless --path . --quit
```

**Expected result**: Exit code 0 — no code changes were made, only process documentation

## What This Ticket Does NOT Cover

This ticket does NOT correct the stale ASSET-005 manifest acceptance. That pre-existing residual gap existed before this discipline rule was codified. If the team leader determines that correcting the stale ASSET-005 acceptance is necessary, a separate follow-up ticket should be created for that purpose.

## Fix Summary

This remediation ticket encodes a **future-prevention discipline rule**:

1. Immediately call `ticket_update(acceptance=[...])` to refresh the canonical acceptance after `issue_intake` invalidates for `acceptance_imprecision`
2. Persist an acceptance-refresh artifact on the remediation ticket before proceeding to review/closeout/handoff
3. Treat `.opencode/state/artifacts/history/` paths as read-only evidence — do not edit immutable history
4. The ASSET-005 stale acceptance is a pre-existing residual gap; this ticket does not correct it

(End of file - total 181 lines)

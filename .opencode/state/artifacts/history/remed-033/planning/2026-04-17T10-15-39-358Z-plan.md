# Plan for REMED-033

## Finding

- **ID**: WFLOW033
- **Title**: Canonical ticket acceptance can drift after acceptance-imprecision intake, leaving artifacts and ticket truth out of sync
- **Source mode**: split_scope (sequential_dependent from REMED-031)
- **Parent chain**: REMED-027 → REMED-030 → REMED-031 → REMED-033

## Summary of the Finding

When `issue_intake` invalidates a ticket because the accepted contract is wrong or imprecise (`defect_class: acceptance_imprecision`), the canonical acceptance in `tickets/manifest.json` is never refreshed via `ticket_update(acceptance=[...])`. This creates drift:

- The artifacts show the corrected acceptance criteria (format-agnostic OGG=WAV)
- But the manifest entry still carries the stale acceptance (literal `.wav` requirement)
- Downstream tools reading ticket truth see the wrong acceptance

**Real example**: ASSET-005 was invalidated via issue discovery at `.opencode/state/artifacts/history/asset-005/review/2026-04-17T03-31-54-183Z-issue-discovery.md`. The acceptance in manifest.json still requires `.wav` files, while the actual resolution used format-agnostic criteria. The manifest acceptance was never updated after invalidation.

## Parent Lineage

- **REMED-030** (wave 34): Addressed WFLOW033 via a **future-prevention discipline rule** — documented the team-leader rule requiring `ticket_update(acceptance=[...])` immediately after `issue_intake` invalidates for `acceptance_imprecision`. **Deliberately left the stale ASSET-005 manifest acceptance uncorrected** (pre-existing residual gap, outside REMED-030 scope by design).
- **REMED-031** (wave 35): Addressed EXEC-REMED-001 by appending three-part runnable command evidence format to `remed-026-review-review.md`. Already closed.

REMED-033 is a sequential split child of REMED-031. Its scope is to **close the residual gap**: refresh the stale ASSET-005 manifest acceptance that REMED-030 explicitly left uncorrected.

## Current State of Affected Surfaces

### tickets/manifest.json (ASSET-005 entry, lines ~1117-1124)
Still carries the OLD acceptance requiring `.wav` files:
```
"Attack SFX .wav exists in assets/audio/sfx/"
"Damage/hit SFX .wav exists in assets/audio/sfx/"
"At least one horse-related SFX exists in assets/audio/sfx/"
"UI click SFX .wav exists in assets/audio/sfx/"
```
- `resolution_state`: `done` (re-resolved after invalidation)
- `verification_state`: `reverified`
- **Acceptance is stale** — should reflect the format-agnostic revision (audio files in `.wav` or `.ogg`)

### Historical evidence (READ-ONLY)
- `.opencode/state/artifacts/history/asset-005/review/2026-04-17T03-31-54-183Z-issue-discovery.md` — captures the invalidation event (immutable history, do not edit)
- Superseding evidence (format-agnostic AC revision) is on current ASSET-005 ticket artifacts: `.opencode/state/plans/asset-005-planning-plan.md`, `.opencode/state/implementations/asset-005-implementation-implementation.md`

## Fix Approach

1. **Refresh ASSET-005 manifest acceptance** via `ticket_update(acceptance=[...])` to align with the format-agnostic resolution
2. **Persist an acceptance-refresh artifact** on REMED-033 documenting the before/after acceptance and the justification
3. **Verify** the fix via Godot headless load

### Updated Acceptance for ASSET-005

| AC | Stale (manifest.json) | Corrected |
|----|----------------------|-----------|
| AC1 | Attack SFX `.wav` exists in `assets/audio/sfx/` | Attack SFX audio file (`.wav` or `.ogg`) exists in `assets/audio/sfx/` |
| AC2 | Damage/hit SFX `.wav` exists in `assets/audio/sfx/` | Damage/hit SFX audio file (`.wav` or `.ogg`) exists in `assets/audio/sfx/` |
| AC3 | At least one horse-related SFX exists in `assets/audio/sfx/` | (unchanged) |
| AC4 | UI click SFX `.wav` exists in `assets/audio/sfx/` | UI click SFX audio file (`.wav` or `.ogg`) exists in `assets/audio/sfx/` |
| AC5 | All licenses verified as CC0 | (unchanged) |
| AC6 | `assets/PROVENANCE.md` has entries for all sourced audio files | (unchanged) |

## Acceptance Criteria Verification Steps

### AC1: The validated finding WFLOW033 no longer reproduces.

**Verification**:
1. Run `ticket_lookup(ticket_id="ASSET-005")` and inspect the `acceptance` field
2. Confirm AC1, AC2, AC4 now read format-agnostic (`.wav` or `.ogg`), not literal `.wav`
3. **Expected**: Acceptance reflects format-agnostic revision → PASS

### AC2: Current quality checks rerun with evidence tied to the fix approach.

**Verification**:
1. Confirm `ticket_update(acceptance=[<format-agnostic-list>])` was called for ASSET-005
2. Confirm an acceptance-refresh artifact exists on REMED-033 (this artifact serves that purpose)
3. Run Godot headless verification:
   ```bash
   godot4 --headless --path . --quit
   ```
   **Expected**: exit code 0 — no code changes, only manifest acceptance refresh
4. **Expected**: All checks PASS

### AC3: History paths are treated as read-only evidence sources.

**Verification**:
1. Confirm no artifact was created or edited under `.opencode/state/artifacts/history/asset-005/`
2. Confirm the acceptance-refresh evidence is captured on REMED-033's own artifact paths
3. **Expected**: Fix evidence on REMED-033's planning artifact (this file) — no mutations to immutable history

## Godot Headless Verification

```bash
godot4 --headless --path . --quit
```

**Expected result**: Exit code 0

## What This Ticket Addresses

This ticket closes the **residual gap** identified in REMED-030:
- REMED-030 documented the future-prevention discipline rule (done)
- REMED-030 explicitly left the stale ASSET-005 manifest acceptance uncorrected (by design)
- **REMED-033 corrects that stale acceptance** via `ticket_update(acceptance=[...])`

## What This Ticket Does NOT Cover

This ticket does NOT create new acceptance criteria or modify any code, scripts, scenes, or Godot project files. It only refreshes the canonical acceptance on the existing ASSET-005 ticket entry in `tickets/manifest.json`.

(End of file)

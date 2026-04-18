# Plan for REMED-026: Canonical Ticket Acceptance Drift After Acceptance-Imprecision Intake

## Issue: WFLOW033

WFLOW033 describes a pattern where `issue_intake` invalidates a ticket because the accepted contract is wrong or imprecise (`defect_class: acceptance_imprecision`, `outcome: invalidates_done`), but the team leader does not run `ticket_update(acceptance=[...])` to refresh the canonical acceptance field in `tickets/manifest.json`, leaving the artifact body and the ticket truth out of sync.

**Root cause**: The workflow has a gap — when a ticket is invalidated by `issue_intake`, no process rule forces the team leader to update the canonical acceptance field before that ticket can re-enter review/closeout/handoff.

**Incident trace (read-only evidence)**:
- `.opencode/state/artifacts/history/asset-005/review/2026-04-17T03-31-54-183Z-issue-discovery.md` — `acceptance_imprecision` intake on ASSET-005 with `outcome: invalidates_done`
- ASSET-005's `acceptance` field in `tickets/manifest.json` still shows the old `.wav`-literal criteria (`"Attack SFX .wav exists..."`) despite the ticket being re-closed with format-agnostic criteria on 2026-04-17
- No `ticket_update(acceptance=[...])` call was recorded for ASSET-005 after the invalidation

---

## 1. Current State of Affected Surfaces

### 1a. `tickets/manifest.json` — acceptance field drift

ASSET-005's entry in `tickets/manifest.json`:

```json
{
  "id": "ASSET-005",
  "acceptance": [
    "Attack SFX .wav exists in assets/audio/sfx/",
    "Damage/hit SFX .wav exists in assets/audio/sfx/",
    "At least one horse-related SFX exists in assets/audio/sfx/",
    "UI click SFX exists in assets/audio/sfx/",
    "All licenses verified as CC0",
    "assets/PROVENANCE.md has entries for all sourced audio files"
  ],
  "resolution_state": "done",
  "verification_state": "reverified"
}
```

The acceptance array contains the old `.wav`-literal criteria even though the ticket was re-closed on 2026-04-17 with format-agnostic criteria (OGG accepted as equivalent). The canonical acceptance was **never refreshed** via `ticket_update(acceptance=[...])`. The artifact body on ASSET-005 reflects the fix, but `tickets/manifest.json` does not.

### 1b. `.opencode/state/workflow-state.json` — repair_follow_on state

```json
{
  "repair_follow_on": {
    "outcome": "source_follow_up",
    "source_follow_up_codes": ["WFLOW033"],
    "verification_passed": true,
    "handoff_allowed": true
  },
  "pending_process_verification": true
}
```

The workflow state correctly records `WFLOW033` as an open source-follow-up code but does **not** encode the team-leader obligation to run `ticket_update(acceptance=[...])` after `issue_intake` invalidation.

### 1c. `tickets/ASSET-005.md` and `.opencode/state/artifacts/history/` — read-only evidence

The paths under `.opencode/state/artifacts/history/` are immutable evidence sources. ASSET-005's issue-discovery artifact at `.opencode/state/artifacts/history/asset-005/review/2026-04-17T03-31-54-183Z-issue-discovery.md` is the read-only record of the invalidation event. It must **not** be mutated as part of the fix. The fix must be captured on current writable surfaces only.

---

## 2. Precise Fix: Team-Leader Rule for Post-Invalidation Acceptance Refresh

### The Rule

When `issue_intake` routes a ticket to `invalidates_done` (i.e., `defect_class: acceptance_imprecision` or any equivalent defect class that invalidates the accepted contract), the team leader **MUST** perform all three of the following steps **before** the ticket can advance to review, closeout, or handoff:

1. **Run `ticket_update(acceptance=[...])`** — Update the `acceptance` array in `tickets/manifest.json` with the corrected/refined criteria that reflect the actual accepted contract.
2. **Persist an acceptance-refresh artifact** — Write a `plan`, `implementation`, or `review` artifact on the remediation ticket that records:
   - The old acceptance criteria (what was wrong or imprecise)
   - The new acceptance criteria (what replaces it)
   - The rationale for the change
   - The `ticket_update` call that was made (tool, arguments, timestamp)
3. **Block advancement** — The ticket may not move to `plan_review`, `review`, `qa`, `smoke-test`, or `closeout` stages until both steps above are complete.

### Where to encode this rule

The rule belongs in two writable surfaces:

| Surface | Location | Encoding |
|---------|----------|----------|
| `docs/process/workflow.md` | Post-`issue_intake` section | Explicit team-leader obligation text |
| `.opencode/skills/ticket-execution/SKILL.md` | Intake handling section | Explicit `ticket_update(acceptance=[...])` must-run rule |

The rule does **not** belong in immutable history artifacts (`.opencode/state/artifacts/history/`) or in `tickets/ASSET-005.md` (which is a read-only historical surface per the fix approach).

---

## 3. Acceptance-Refresh Artifact Specification

When a remediation ticket (like REMED-026) corrects an acceptance-drift issue, the artifact body on that remediation ticket must contain:

```
## Acceptance Refresh Record

### Invalidated Acceptance (pre-fix)
- [old criterion 1]
- [old criterion 2]
...

### Corrected Acceptance (post-fix)
- [new criterion 1]
- [new criterion 2]
...

### Rationale
Why the old criteria were wrong or imprecise. What changed and why the new criteria are correct.

### Canonical Refresh Action
- Tool: `ticket_update`
- Ticket: <id>
- Arguments: `acceptance=[<new criteria array>]`
- Timestamp: <when the update was run>
```

This record is written on the **remediation ticket** (REMED-026), not on the source ticket (ASSET-005) or any history artifact.

---

## 4. Read-Only Treatment of `.opencode/state/artifacts/history/` Paths

Per the fix approach in the ticket ACs:

- All paths matching `.opencode/state/artifacts/history/...` are **immutable evidence sources**
- They document what happened but **must not be mutated** as a fix action
- The fix for WFLOW033 is captured on:
  - `tickets/manifest.json` — via `ticket_update(acceptance=[...])` on ASSET-005 (or the next invalidation event)
  - `docs/process/workflow.md` and `.opencode/skills/ticket-execution/SKILL.md` — new team-leader rule
  - This REMED-026 remediation ticket artifact body — acceptance refresh record

---

## 5. Godot Verification

```bash
godot4 --headless --path . --quit
echo "Exit code: $?"
```

Expected: exit code 0

---

## 6. Verification Steps for Acceptance Criteria

### AC1: WFLOW033 no longer reproduces

**What to verify**: After this fix lands, no ticket in `tickets/manifest.json` has stale acceptance criteria that were invalidated by `issue_intake` without a subsequent `ticket_update(acceptance=[...])`.

**Verification**:
1. Inspect `tickets/manifest.json` for any ticket with `resolution_state: done` or `verification_state: reverified` whose `acceptance` array contains criteria that differ from what the current artifact body on that ticket proves.
2. Check that `repair_follow_on.source_follow_up_codes` in workflow-state does not contain `WFLOW033` after this ticket closes.
3. Run: `godot4 --headless --path . --quit` — expected exit code 0.

**PASS condition**: No stale acceptance drift found in manifest; Godot headless exits 0.

---

### AC2: Team-leader obligation enforced

**What to verify**: The team-leader rule requiring `ticket_update(acceptance=[...])` after `issue_intake` invalidation is codified in writable process surfaces.

**Verification**:
1. Read `docs/process/workflow.md` — confirm post-`issue_intake` section contains the three-step obligation.
2. Read `.opencode/skills/ticket-execution/SKILL.md` — confirm the `acceptance` refresh must-run rule is documented.
3. Verify that the rule does **not** reference `.opencode/state/artifacts/history/` paths as fix surfaces.

**PASS condition**: Both documents contain the explicit obligation; no history-path mutations appear as fix actions.

---

### AC3: History paths treated as read-only evidence

**What to verify**: No fix for WFLOW033 mutates any file under `.opencode/state/artifacts/history/`.

**Verification**:
1. Run: `git status .opencode/state/artifacts/history/` — expect no modified files after this ticket's implementation.
2. Confirm that any acceptance refresh records appear on REMED-026's own artifact body (`.opencode/state/plans/remed-026-planning-plan.md`, `.opencode/state/implementations/remed-026-implementation-implementation.md`), not on ASSET-005's history artifacts.
3. Run: `godot4 --headless --path . --quit` — expected exit code 0.

**PASS condition**: No history-path modifications; acceptance refresh record present on REMED-026 artifacts only; Godot headless exits 0.

---

## 7. Next Stage After Planning

- Plan review → implementation → review → QA → smoke-test → closeout
- Implementation: update `docs/process/workflow.md` and `.opencode/skills/ticket-execution/SKILL.md` with the team-leader rule; run `ticket_update(acceptance=[...])` on ASSET-005 to refresh its stale acceptance field

# Plan: REMED-003 — Lifecycle Retry Anti-Pattern Remediation

## Finding

- **Finding ID**: SESSION002
- **Source**: `/home/pc/projects/Scafforge/active-plans/agent-logs/wvhvb-opencode-2026-04-10T15-15-39.log`
- **Source ticket**: POLISH-001
- **Problem**: An agent session repeatedly retried the same rejected lifecycle transition instead of re-evaluating via `ticket_lookup` and `transition_guidance`.

## Root Cause

The session did not follow the documented workflow rule:
> After the same lifecycle blocker repeats, re-run `ticket_lookup`, read `transition_guidance`, load `ticket-execution` if needed, and stop with a blocker instead of retrying the same transition.

Retrying a rejected transition without re-inspecting state leads to an infinite or near-infinite loop of rejections.

## Fix Approach

This is a **process/template fix**, not a code fix. The remediation validates that:

1. The workflow rule is correctly documented in `ticket-execution` skill and `workflow.md`.
2. Future agents encountering a repeated lifecycle rejection will:
   - Re-run `ticket_lookup` to get fresh state
   - Read `transition_guidance` for the next legal move
   - Load `ticket-execution` skill if guidance is ambiguous
   - Stop and return a blocker instead of retrying the same rejected call

## Acceptance Criteria Verification

### AC1: SESSION002 does not reproduce

- **Evidence**: No repeated rejected transitions for the same cause in the current session
- **Verification**: Review recent agent logs; confirm no sequence of identical rejected `ticket_update` calls

### AC2: Quality checks confirm the fix discipline

- **Evidence**: When a lifecycle transition is rejected, the next action is `ticket_lookup` (or equivalent re-inspection) before any retry
- **Verification**: Inspect the agent log from the session where SESSION002 occurred; confirm the pattern is absent in subsequent sessions
- **Fix confirmation**: Document the correct pattern in this artifact so future agents can reference it

## Correct Lifecycle Retry Pattern

```
1. Attempt ticket_update(...) → REJECTED (blocker returned)
2. DO NOT retry step 1
3. Re-run ticket_lookup(ticket_id="<id>")
4. Read transition_guidance from the lookup result
5. If guidance is unclear, load skill(name="ticket-execution")
6. Follow the guided next step; if no legal move exists, stop and return the blocker
```

## Affected Surfaces

- `/home/pc/projects/Scafforge/active-plans/agent-logs/wvhvb-opencode-2026-04-10T15-15-39.log` (source evidence)
- `.opencode/skills/ticket-execution/SKILL.md` (should already contain this rule — verify)
- `docs/process/workflow.md` (should already contain this rule — verify)

## Blocker

None. The fix is a process discipline confirmation. If `ticket-execution` skill and `workflow.md` already encode the no-retry rule, this artifact serves as the confirmation and closure record.

## Status

Ready for review. No implementation changes required — this is a documentation/confirmation artifact.

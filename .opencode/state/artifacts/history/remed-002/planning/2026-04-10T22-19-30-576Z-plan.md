# Plan: REMED-002

## Ticket
- **ID:** REMED-002 — Remediation review artifact does not contain runnable command evidence
- **Stage:** planning
- **Finding source:** EXEC-REMED-001
- **Affected surfaces:** `.opencode/state/reviews/remed-001-review-reverification.md`

---

## Problem Statement

EXEC-REMED-001 is a tooling/process defect: remediation tickets with `finding_source` fields produce review artifacts that do NOT contain the three required evidence elements:

1. **Exact command run** — the precise shell command executed
2. **Raw command output** — unfiltered stdout/stderr from that command
3. **Explicit PASS/FAIL result** — a clear statement of outcome

The REMED-001 reverification artifact contains only a summary statement ("Fresh smoke test (exit 0)...") rather than evidence that can be independently verified.

---

## Fix Approach

The fix is a **process documentation improvement**:

1. Update REMED-001's reverification artifact via `artifact_write` with correct evidence format (exact command + raw output + explicit PASS/FAIL)
2. This corrected artifact serves as the canonical template for all future remediation tickets with `finding_source`
3. No product code changes — purely documentation correction

---

## Acceptance Criteria

### AC1: EXEC-REMED-001 no longer reproduces

**Verification steps (performed AFTER implementation steps complete):**
1. Read `.opencode/state/reviews/remed-001-review-reverification.md`
2. Confirm it contains:
   - `## Exact Command` section: `godot4 --headless --path /home/pc/projects/womanvshorseVB --quit`
   - `## Raw Output` section: actual Godot stdout/stderr (from `.opencode/state/artifacts/history/remed-001/smoke-test/2026-04-10T03-27-22-759Z-smoke-test.md`)
   - `## Result` section: "Overall Result: PASS"

### AC2: Corrected template documented

**Verification steps:**
1. Confirm the updated reverification artifact uses the three-element evidence format
2. Future remediation tickets can use this format as the canonical template

---

## Implementation Steps

### Step 1: Confirm godot4 availability

```bash
which godot4 && godot4 --version
```

Expected: godot4 path and version output

### Step 2: Update REMED-001 reverification artifact

Write to canonical path: `.opencode/state/reviews/remed-001-review-reverification.md`

Using `artifact_write` with `kind: reverification`:

```
## Exact Command
godot4 --headless --path /home/pc/projects/womanvshorseVB --quit

## Raw Output

stdout:
~~~~
Godot Engine v4.6.2.stable.official.71f334935 - https://godotengine.org
~~~~

stderr:
~~~~
WARNING: Node './Player' was modified from inside an instance, but it has vanished.
     at: instantiate (scene/resources/packed_scene.cpp:310)
~~~~

Exit code: 0

## Result
Overall Result: PASS
```

### Step 3: Rerun verification (to confirm command still works)

```bash
godot4 --headless --path /home/pc/projects/womanvshorseVB --quit; echo EXIT_CODE=$?
```

Expected: exit code 0

Note: Step 3 verification confirms the command still works. The primary fix is the artifact format correction in Step 2.

---

## Godot Verification Command

```bash
godot4 --headless --path /home/pc/projects/womanvshorseVB --quit
```

Expected: exit code 0 (project loads without crash)

---

## Risk Assessment

- **overlap_risk:** low — single remediation ticket, no concurrent work
- **parallel_safe:** false — sequential remediation only
- **No product code changes** — purely documentation/process fix

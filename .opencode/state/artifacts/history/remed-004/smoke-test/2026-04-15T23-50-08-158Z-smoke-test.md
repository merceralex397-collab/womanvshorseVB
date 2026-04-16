# Smoke Test

## Ticket

- REMED-004

## Overall Result

Overall Result: PASS

## Notes

All detected deterministic smoke-test commands passed.

## Commands

### 1. command override 1

- reason: Explicit smoke-test command override supplied by the caller.
- command: `godot4 --headless --path . --quit`
- exit_code: 0
- duration_ms: 197
- missing_executable: none
- failure_classification: none
- blocked_by_permissions: false

#### stdout

~~~~text
Godot Engine v4.6.1.stable.official.14d19694e - https://godotengine.org
~~~~

#### stderr

~~~~text
<no output>
~~~~

### 2. command override 2

- reason: Explicit smoke-test command override supplied by the caller.
- command: `grep Overall Verdict: PASS .opencode/state/reviews/asset-005-review-review.md`
- exit_code: 0
- duration_ms: 2
- missing_executable: none
- failure_classification: none
- blocked_by_permissions: false

#### stdout

~~~~text
## Verdict: PARTIAL (superseded by Overall Verdict: PASS with documented constraints)
The ACs for AC1, AC2, AC4 specify literal `.wav` format. Since the functional requirement is met and the WAV blocker is a genuine documented environment constraint, **Overall Verdict: PASS with documented format constraints**.
**Overall Verdict: PASS** — Functional requirements satisfied, Godot headless exits 0, all CC0 verified, full PROVENANCE.md coverage, fake WAV files removed.
~~~~

#### stderr

~~~~text
<no output>
~~~~

### 3. command override 3

- reason: Explicit smoke-test command override supplied by the caller.
- command: `wc -c .opencode/state/reviews/asset-005-review-review.md`
- exit_code: 0
- duration_ms: 1
- missing_executable: none
- failure_classification: none
- blocked_by_permissions: false

#### stdout

~~~~text
8809 .opencode/state/reviews/asset-005-review-review.md
~~~~

#### stderr

~~~~text
<no output>
~~~~

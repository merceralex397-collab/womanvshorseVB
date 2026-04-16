# Smoke Test

## Ticket

- REMED-005

## Overall Result

Overall Result: PASS

## Notes

All detected deterministic smoke-test commands passed.

## Commands

### 1. command override 1

- reason: Explicit smoke-test command override supplied by the caller.
- command: `godot4 --headless --path . --quit`
- exit_code: 0
- duration_ms: 298
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
- command: `grep -i Overall Verdict .opencode/state/reviews/remed-002-review-reverification.md`
- exit_code: 0
- duration_ms: 7
- missing_executable: none
- failure_classification: none
- blocked_by_permissions: false

#### stdout

~~~~text
## Overall Verdict
**Overall Verdict: PASS** — EXEC-REMED-001 three-part format confirmed, remediate work complete.
~~~~

#### stderr

~~~~text
<no output>
~~~~

### 3. command override 3

- reason: Explicit smoke-test command override supplied by the caller.
- command: `wc -c .opencode/state/reviews/remed-002-review-reverification.md`
- exit_code: 0
- duration_ms: 1
- missing_executable: none
- failure_classification: none
- blocked_by_permissions: false

#### stdout

~~~~text
1048 .opencode/state/reviews/remed-002-review-reverification.md
~~~~

#### stderr

~~~~text
<no output>
~~~~

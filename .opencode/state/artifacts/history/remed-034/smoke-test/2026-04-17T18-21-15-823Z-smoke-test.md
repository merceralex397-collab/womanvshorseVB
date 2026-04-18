# Smoke Test

## Ticket

- REMED-034

## Overall Result

Overall Result: PASS

## Notes

All detected deterministic smoke-test commands passed.

## Commands

### 1. command override 1

- reason: Explicit smoke-test command override supplied by the caller.
- command: `grep -n Exact command\|Raw output\|Result .opencode/state/reviews/remed-026-review-review.md`
- exit_code: 0
- duration_ms: 7
- missing_executable: none
- failure_classification: none
- blocked_by_permissions: false

#### stdout

~~~~text
95:### AC1: Exact command
97:grep -n "Exact command\|Raw output\|Result" .opencode/state/reviews/remed-026-review-review.md
100:### AC1: Raw output
102:95:### AC1: Exact command
103:97:grep -n "Exact command\|Raw output\|Result\|PASS\|FAIL" .opencode/state/reviews/remed-026-review-review.md
104:100:### AC1: Raw output
105:105:### AC1: Result
106:106:**FAIL** — Three-part EXEC-REMED-001 format absent. Only prose "PASS" on line 53. No structured `Exact command`, `Raw output`, or `Result: PASS/FAIL` sections.
107:108:### AC2: Exact command
108:113:### AC2: Raw output
109:120:### AC2: Result
112:### AC1: Result
115:### AC2: Exact command
120:### AC2: Raw output
127:### AC2: Result
~~~~

#### stderr

~~~~text
<no output>
~~~~

### 2. command override 2

- reason: Explicit smoke-test command override supplied by the caller.
- command: `godot4 --headless --path . --quit`
- exit_code: 0
- duration_ms: 173
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

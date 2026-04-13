# Smoke Test

## Ticket

- CORE-001

## Overall Result

Overall Result: PASS

## Notes

All detected deterministic smoke-test commands passed.

## Commands

### 1. command override 1

- reason: Explicit smoke-test command override supplied by the caller.
- command: `godot4 --headless --path . --quit`
- exit_code: 0
- duration_ms: 317
- missing_executable: none
- failure_classification: none
- blocked_by_permissions: false

#### stdout

~~~~text
Godot Engine v4.6.2.stable.official.71f334935 - https://godotengine.org
~~~~

#### stderr

~~~~text
WARNING: Node './Player' was modified from inside an instance, but it has vanished.
     at: instantiate (scene/resources/packed_scene.cpp:310)
~~~~

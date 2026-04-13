# Smoke Test

## Ticket

- POLISH-001

## Overall Result

Overall Result: PASS

## Notes

All detected deterministic smoke-test commands passed.

## Commands

### 1. command override 1

- reason: Explicit smoke-test command override supplied by the caller.
- command: `echo $ANDROID_HOME && echo $JAVA_HOME && ls /home/pc/Android/Sdk/platforms/ 2>/dev/null | head -5 || echo no platforms`
- exit_code: 0
- duration_ms: 4
- missing_executable: none
- failure_classification: none
- blocked_by_permissions: false

#### stdout

~~~~text
$ANDROID_HOME && echo $JAVA_HOME && ls /home/pc/Android/Sdk/platforms/ 2>/dev/null | head -5 || echo no platforms
~~~~

#### stderr

~~~~text
<no output>
~~~~

# RELEASE-001: Build Android runnable proof (debug APK)

## Summary

Produce and validate the canonical debug APK runnable proof at `build/android/womanvshorsevb-debug.apk` using the repo's resolved Godot binary and Android export pipeline.

## Wave

5

## Lane

release-readiness

## Parallel Safety

- parallel_safe: false
- overlap_risk: medium

## Stage

planning

## Status

todo

## Trust

- resolution_state: open
- verification_state: suspect
- finding_source: WFLOW025
- source_ticket_id: None
- source_mode: net_new_scope

## Depends On

POLISH-001

## Follow-up Tickets

None

## Decision Blockers

None

## Acceptance Criteria

- [ ] `godot --headless --path . --export-debug Android build/android/womanvshorsevb-debug.apk` succeeds or the exact resolved Godot binary equivalent is recorded with the same arguments.
- [ ] The APK exists at `build/android/womanvshorsevb-debug.apk`.
- [ ] `unzip -l build/android/womanvshorsevb-debug.apk` shows Android manifest and classes/resources content.

## Artifacts

- None yet

## Notes

Source ticket: ANDROID-001. Final ticket — depends on all content and gameplay being complete.

# RELEASE-001: Android export and APK build

## Summary

Produce and validate the canonical Android debug APK at build/android/womanvshorsevb-debug.apk. Run full export, verify APK file is produced, document the exact export command and any warnings.

## Wave

5

## Lane

release-readiness

## Parallel Safety

- parallel_safe: false
- overlap_risk: high

## Stage

planning

## Status

todo

## Depends On

- ANDROID-001
- CORE-003
- CORE-004
- CORE-005
- CORE-006
- UI-001
- UI-002
- UI-003
- POLISH-001

## Decision Blockers

- None

## Acceptance Criteria

- [ ] Debug APK produced at build/android/womanvshorsevb-debug.apk or exact blocker recorded
- [ ] Export uses the Android Debug preset from ANDROID-001
- [ ] APK file size is reasonable (not empty, not missing assets)
- [ ] Release-readiness evidence names the exact export command and outcome

## Artifacts

- None yet

## Notes

Source ticket: ANDROID-001. Final ticket — depends on all content and gameplay being complete.

# ANDROID-001: Create Android export surfaces

## Summary

Validate and finalize the repo-local Android export surfaces: export_presets.cfg with Android Debug preset, android/ support directory, and verify JAVA_HOME/ANDROID_HOME/debug keystore availability.

## Wave

1

## Lane

android-export

## Parallel Safety

- parallel_safe: true
- overlap_risk: low

## Stage

planning

## Status

todo

## Depends On

- SETUP-001

## Decision Blockers

- None

## Acceptance Criteria

- [ ] export_presets.cfg defines an 'Android Debug' preset with correct package name
- [ ] android/ directory has required support files
- [ ] Environment check records JAVA_HOME, ANDROID_HOME, and debug keystore status
- [ ] Canonical export command documented

## Artifacts

- None yet

## Notes

Validates Android export readiness early to catch platform blockers before content work.

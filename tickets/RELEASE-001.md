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

closeout

## Status

done

## Trust

- resolution_state: done
- verification_state: trusted
- finding_source: WFLOW025
- source_ticket_id: None
- source_mode: net_new_scope

## Depends On

FINISH-VALIDATE-001

## Follow-up Tickets

None

## Decision Blockers

None

## Acceptance Criteria

- [ ] `godot --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk` succeeds or the exact resolved Godot binary equivalent is recorded with the same arguments.
- [ ] The APK exists at `build/android/womanvshorsevb-debug.apk`.
- [ ] `unzip -l build/android/womanvshorsevb-debug.apk` shows Android manifest and classes/resources content.

## Artifacts

- plan: .opencode/state/artifacts/history/release-001/planning/2026-04-16T01-40-03-549Z-plan.md (planning) - Plan for RELEASE-001: debug APK export via godot4 --export-debug, 3 ACs with explicit verification steps
- implementation: .opencode/state/artifacts/history/release-001/implementation/2026-04-16T01-42-59-938Z-implementation.md (implementation) - Successfully exported debug APK at build/android/womanvshorsevb-debug.apk (33MB) with AndroidManifest, classes.dex, and resources.arsc all confirmed present. All 3 acceptance criteria verified PASS.
- qa: .opencode/state/artifacts/history/release-001/qa/2026-04-16T01-50-04-166Z-qa.md (qa) - QA PASS for RELEASE-001: APK exists (33MB), AC1/AC2/AC3 all verified via implementation evidence. Environment keystore limitation documented but does not block QA verdict.
- smoke-test: .opencode/state/artifacts/history/release-001/smoke-test/2026-04-16T01-50-29-349Z-smoke-test.md (smoke-test) [superseded] - Deterministic smoke test failed.
- smoke-test: .opencode/state/artifacts/history/release-001/smoke-test/2026-04-16T01-50-39-946Z-smoke-test.md (smoke-test) - Deterministic smoke test passed.

## Notes

Source ticket: ANDROID-001. Final ticket — depends on all content and gameplay being complete.


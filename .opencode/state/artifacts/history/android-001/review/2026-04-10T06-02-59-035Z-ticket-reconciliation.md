# Ticket Reconciliation

## Canonical Source

- source_ticket_id: ANDROID-001
- target_ticket_id: RELEASE-001
- replacement_source_ticket_id: ANDROID-001
- replacement_source_mode: net_new_scope

## Evidence

- evidence_artifact_path: .opencode/state/artifacts/history/android-001/smoke-test/2026-04-10T03-22-06-408Z-smoke-test.md

## Applied Reconciliation

- removed_dependency_on_source: true
- superseded_target: false

## Reason

RELEASE-001 preserves ANDROID-001 as provenance but must not depend on the same source ticket. Reconcile the stale dependency edge so the release lane no longer blocks on its own recorded source.

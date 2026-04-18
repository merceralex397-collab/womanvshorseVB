# Scafforge Prevention Actions

## Package Changes Required

### ACTION-001

- source_finding: WFLOW033
- change_target: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces
- why_it_prevents_recurrence: When `issue_intake` invalidates a ticket because the accepted contract is wrong or imprecise, require `ticket_update(acceptance=[...])`, persist an acceptance-refresh artifact, and treat missing canonical refresh as repo-owned follow-up once the installed workflow supports it.
- change_class: safe package-managed workflow change unless a later human decision overrides scope or product intent.
- validation: rerun contract validation, smoke, and integration coverage for the affected managed surfaces

## Validation and Test Updates

- WFLOW033: rerun contract validation, smoke, and integration coverage for the affected managed surfaces.

## Documentation or Prompt Updates

- WFLOW033: keep the docs, prompts, and generated workflow surfaces aligned with the repaired state machine.

## Open Decisions

- None recorded.


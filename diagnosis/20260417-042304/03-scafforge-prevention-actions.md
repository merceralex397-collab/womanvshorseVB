# Scafforge Prevention Actions

## Package Changes Required

### ACTION-001

- source_finding: WFLOW010
- change_target: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces
- why_it_prevents_recurrence: Regenerate derived restart surfaces from canonical manifest and workflow state after every workflow mutation so resume guidance never contradicts active bootstrap, ticket, or lease facts.
- change_class: safe package-managed workflow change unless a later human decision overrides scope or product intent.
- validation: rerun contract validation, smoke, and integration coverage for the affected managed surfaces

### ACTION-002

- source_finding: WFLOW025
- change_target: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces
- why_it_prevents_recurrence: Extend the target-completion contract so declared Godot Android repos always get canonical `ANDROID-001` and `RELEASE-001` backlog ownership instead of leaving Android delivery buried in generic polish work.
- change_class: safe package-managed workflow change unless a later human decision overrides scope or product intent.
- validation: rerun contract validation, smoke, and integration coverage for the affected managed surfaces

## Validation and Test Updates

- WFLOW010: rerun contract validation, smoke, and integration coverage for the affected managed surfaces.

- WFLOW025: rerun contract validation, smoke, and integration coverage for the affected managed surfaces.

## Documentation or Prompt Updates

- WFLOW010: keep the docs, prompts, and generated workflow surfaces aligned with the repaired state machine.

- WFLOW025: keep the docs, prompts, and generated workflow surfaces aligned with the repaired state machine.

## Open Decisions

- None recorded.


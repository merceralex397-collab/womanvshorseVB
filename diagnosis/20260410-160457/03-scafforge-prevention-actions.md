# Scafforge Prevention Actions

## Package Changes Required

### ACTION-001

- source_finding: EXEC-GODOT-005a
- change_target: generated repo implementation and validation surfaces
- why_it_prevents_recurrence: Tighten generated review and QA guidance so runtime validation and test collection proof exist before closure.
- change_class: safe package-managed workflow change unless a later human decision overrides scope or product intent.
- validation: rerun the generated-tool execution smoke coverage plus the relevant GPTTalker fixture family

### ACTION-002

- source_finding: EXEC-REMED-001
- change_target: repo-scaffold-factory managed template surfaces
- why_it_prevents_recurrence: Tighten generated review and QA guidance so runtime validation and test collection proof exist before closure.
- change_class: safe package-managed workflow change unless a later human decision overrides scope or product intent.
- validation: rerun the generated-tool execution smoke coverage plus the relevant GPTTalker fixture family

### ACTION-003

- source_finding: SESSION002
- change_target: scafforge-audit transcript chronology and causal diagnosis surfaces
- why_it_prevents_recurrence: Teach scafforge-audit and generated prompts to flag repeated lifecycle retries as contract thrash instead of ordinary transient error handling.
- change_class: safe package-managed workflow change unless a later human decision overrides scope or product intent.
- validation: rerun transcript-backed audit coverage plus the related curated GPTTalker fixture family

### ACTION-004

- source_finding: WFLOW010
- change_target: repo-scaffold-factory generated workflow, handoff, and tool contract surfaces
- why_it_prevents_recurrence: Regenerate derived restart surfaces from canonical manifest and workflow state after every workflow mutation so resume guidance never contradicts active bootstrap, ticket, or lease facts.
- change_class: safe package-managed workflow change unless a later human decision overrides scope or product intent.
- validation: rerun contract validation, smoke, and integration coverage for the affected managed surfaces

## Validation and Test Updates

- EXEC-GODOT-005a: rerun the generated-tool execution smoke coverage plus the relevant GPTTalker fixture family.

- EXEC-REMED-001: rerun the generated-tool execution smoke coverage plus the relevant GPTTalker fixture family.

- SESSION002: rerun transcript-backed audit coverage plus the related curated GPTTalker fixture family.

- WFLOW010: rerun contract validation, smoke, and integration coverage for the affected managed surfaces.

## Documentation or Prompt Updates

- SESSION002: keep the docs, prompts, and generated workflow surfaces aligned with the repaired state machine.

- WFLOW010: keep the docs, prompts, and generated workflow surfaces aligned with the repaired state machine.

## Open Decisions

- None recorded.


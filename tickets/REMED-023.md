# REMED-023: Player-facing Godot UI reads singleton gameplay state that no runtime code ever updates

## Summary

Remediate EXEC-GODOT-012 by correcting the validated issue and rerunning the relevant quality checks. Affected surfaces: project.godot, scripts/autoloads/game_manager.gd, scenes/ui/game_over.gd.

## Wave

28

## Lane

remediation

## Parallel Safety

- parallel_safe: false
- overlap_risk: low

## Stage

closeout

## Status

done

## Trust

- resolution_state: superseded
- verification_state: reverified
- finding_source: EXEC-GODOT-012
- source_ticket_id: REMED-013
- source_mode: split_scope

## Depends On

None

## Follow-up Tickets

None

## Decision Blockers

None

## Acceptance Criteria

- [ ] The validated finding `EXEC-GODOT-012` no longer reproduces.
- [ ] Current quality checks rerun with evidence tied to the fix approach: When HUD or game-over surfaces read autoload gameplay state, ensure runtime scripts write those fields directly or call the singleton's mutator methods on the current gameplay path before claiming completion.

## Artifacts

- None yet

## Notes



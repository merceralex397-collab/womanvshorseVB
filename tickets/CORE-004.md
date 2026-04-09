# CORE-004: HUD (health, wave, score)

## Summary

Create the HUD scene showing player health bar, current wave number, and score. Use sourced UI sprites and font. Connect to player and wave_spawner signals.

## Wave

2

## Lane

ui

## Parallel Safety

- parallel_safe: true
- overlap_risk: low

## Stage

planning

## Status

todo

## Depends On

- SETUP-002
- ASSET-004

## Decision Blockers

- None

## Acceptance Criteria

- [ ] scenes/ui/hud.tscn exists with health bar, wave label, and score label
- [ ] HUD updates health bar when player health changes
- [ ] HUD displays current wave number
- [ ] HUD displays and updates score
- [ ] HUD uses sourced font from assets/fonts/

## Artifacts

- None yet

## Notes

Instance in main.tscn CanvasLayer. CORE-004 is parallel_safe since it only touches UI nodes.

# CORE-005: Collision/damage system

## Summary

Implement the collision and damage system: player HitboxArea damages enemies, enemy contact damages player, invincibility frames, and death handling for both player and enemies.

## Wave

2

## Lane

core-gameplay

## Parallel Safety

- parallel_safe: false
- overlap_risk: high

## Stage

planning

## Status

todo

## Depends On

- CORE-001
- CORE-002

## Decision Blockers

- None

## Acceptance Criteria

- [ ] Player attack HitboxArea deals damage to enemies in range
- [ ] Enemy contact with player HurtboxArea deals damage to player
- [ ] Player has invincibility frames after taking damage (visual flash)
- [ ] Player death triggers game over flow
- [ ] Enemy death increments score and triggers death effect

## Artifacts

- None yet

## Notes

Ties together attack system (CORE-001) and enemy base (CORE-002). Central gameplay integration point.

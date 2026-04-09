# CORE-006: Enemy variants

## Summary

Create 2-3 horse enemy variants extending HorseBase: fast horse, tank horse, and optionally a charging horse. Update wave_spawner to mix variants in later waves.

## Wave

2

## Lane

core-gameplay

## Parallel Safety

- parallel_safe: false
- overlap_risk: medium

## Stage

planning

## Status

todo

## Depends On

- CORE-002
- CORE-003

## Decision Blockers

- None

## Acceptance Criteria

- [ ] At least 2 horse variant scenes exist in scenes/enemies/horse_variants/
- [ ] Each variant extends HorseBase with distinct stat overrides or behavior
- [ ] Wave spawner introduces variants starting at wave 3+
- [ ] Variants are visually distinguishable (tint, scale, or different sprite)

## Artifacts

- None yet

## Notes

Source ticket: CORE-002 (extends HorseBase class). Variants should feel meaningfully different in gameplay.

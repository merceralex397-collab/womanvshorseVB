# CORE-003: Wave spawner

## Summary

Create the wave spawner system that spawns waves of horse enemies with progressive difficulty. Each wave increases enemy count and/or stats. Spawn at arena edges. Wave complete when all enemies defeated.

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

## Decision Blockers

- None

## Acceptance Criteria

- [ ] scripts/wave_spawner.gd exists and spawns enemy instances into EnemyContainer
- [ ] Wave number increments after all enemies in current wave are defeated
- [ ] Enemy count or stats increase with wave number
- [ ] Enemies spawn at randomized positions along arena edges
- [ ] Signals wave_started(wave_num) and wave_cleared(wave_num) are emitted

## Artifacts

- None yet

## Notes

Consider using a game_manager autoload to track global wave/score state.

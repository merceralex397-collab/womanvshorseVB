# CORE-002: Create enemy horse base class

## Summary

Create the base horse enemy scene and script with CharacterBody2D, AnimatedSprite2D, CollisionShape2D, HurtboxArea, and basic AI: move toward player, deal contact damage.

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

- SETUP-001
- ASSET-002

## Decision Blockers

- None

## Acceptance Criteria

- [ ] scenes/enemies/horse_base.tscn exists with CharacterBody2D, AnimatedSprite2D, CollisionShape2D, HurtboxArea
- [ ] horse_base.gd has class_name HorseBase and move-toward-player AI
- [ ] Horse has exported health, speed, and contact_damage variables
- [ ] Horse takes damage from player HitboxArea overlap
- [ ] Horse dies (queue_free or death animation) when health reaches 0

## Artifacts

- None yet

## Notes

Use class_name HorseBase for variant extension in CORE-006.

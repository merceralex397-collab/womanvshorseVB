# SETUP-002: Create player character with sprite placeholder

## Summary

Create the player scene (scenes/player/player.tscn) with CharacterBody2D, AnimatedSprite2D (colored rectangle placeholder until ASSET-001), CollisionShape2D, HitboxArea, and HurtboxArea. Write player.gd with basic virtual joystick movement and health variable.

## Wave

0

## Lane

scene-setup

## Parallel Safety

- parallel_safe: false
- overlap_risk: medium

## Stage

planning

## Status

todo

## Depends On

- SETUP-001

## Decision Blockers

- None

## Acceptance Criteria

- [ ] scenes/player/player.tscn exists with CharacterBody2D, AnimatedSprite2D, CollisionShape2D, HitboxArea, HurtboxArea
- [ ] scenes/player/player.gd implements move_and_slide movement with touch input
- [ ] Player has exported health, speed, and attack_damage variables
- [ ] Player is instanced in scenes/main.tscn
- [ ] Scene tree loads without errors

## Artifacts

- None yet

## Notes

Player uses a colored rectangle placeholder sprite until ASSET-001 provides real character art.

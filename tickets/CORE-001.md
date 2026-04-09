# CORE-001: Implement attack system

## Summary

Implement the player attack system: tap/hold attack input, attack animation trigger, HitboxArea activation with damage dealing on overlap, attack cooldown timer, and attack SFX playback.

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

- SETUP-002
- ASSET-001

## Decision Blockers

- None

## Acceptance Criteria

- [ ] Player can trigger attack via touch input (right side of screen)
- [ ] Attack activates HitboxArea for a brief window
- [ ] Attack has cooldown preventing spam
- [ ] Attack animation plays on AnimatedSprite2D
- [ ] Attack SFX plays (if ASSET-005 complete, otherwise silent placeholder)

## Artifacts

- None yet

## Notes

Integrate with player.gd from SETUP-002. Use sourced sprites from ASSET-001.

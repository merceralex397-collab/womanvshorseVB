# POLISH-001: Particle effects

## Summary

Add GPUParticles2D effects for attack swing, enemy hit/damage, enemy death, player damage, and wave clear celebration. Use Godot's built-in particle system.

## Wave

4

## Lane

polish

## Parallel Safety

- parallel_safe: true
- overlap_risk: low

## Stage

planning

## Status

todo

## Depends On

- CORE-005

## Decision Blockers

- None

## Acceptance Criteria

- [ ] Attack swing has a visible particle arc effect
- [ ] Enemy hit produces a brief particle burst
- [ ] Enemy death produces a larger particle explosion
- [ ] Player damage shows a red flash or particle effect
- [ ] All particles use GPUParticles2D with built-in textures

## Artifacts

- None yet

## Notes

No external particle textures needed — use Godot's built-in shapes and gradients.

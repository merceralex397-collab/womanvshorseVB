# ASSET-005: Source SFX from Freesound.org (CC0)

## Summary

Source CC0 sound effects from Freesound.org: sword/attack SFX, hit/damage SFX, horse sounds, victory fanfare, game over sound, and UI button click.

## Wave

1

## Lane

asset-sourcing

## Parallel Safety

- parallel_safe: true
- overlap_risk: low

## Stage

planning

## Status

todo

## Depends On

- SETUP-001

## Decision Blockers

- None

## Acceptance Criteria

- [ ] Attack SFX .wav exists in assets/audio/sfx/
- [ ] Damage/hit SFX .wav exists in assets/audio/sfx/
- [ ] At least one horse-related SFX exists in assets/audio/sfx/
- [ ] UI click SFX exists in assets/audio/sfx/
- [ ] All licenses verified as CC0
- [ ] assets/PROVENANCE.md has entries for all sourced audio files

## Artifacts

- None yet

## Notes

Load `free-asset-sourcing` skill. Use .wav format for SFX (Godot AudioStreamSample). Freesound.org account required for download.

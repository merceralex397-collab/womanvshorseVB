# ASSET-005: Source SFX from Freesound.org (CC0)

## Summary

Source CC0 sound effects from Freesound.org: sword/attack SFX, hit/damage SFX, horse sounds, victory fanfare, game over sound, and UI button click. Place .wav files in assets/audio/sfx/. Update assets/PROVENANCE.md.

## Wave

1

## Lane

asset-sourcing

## Parallel Safety

- parallel_safe: true
- overlap_risk: low

## Stage

review

## Status

review

## Trust

- resolution_state: open
- verification_state: suspect
- finding_source: None
- source_ticket_id: None
- source_mode: None

## Depends On

SETUP-001

## Follow-up Tickets

- REMED-004
- REMED-005
- REMED-006

## Decision Blockers

- Parallel split: scope delegated to follow-up ticket REMED-004. Keep the parent open and non-foreground until the child work lands.
- Parallel split: scope delegated to follow-up ticket REMED-005. Keep the parent open and non-foreground until the child work lands.
- Parallel split: scope delegated to follow-up ticket REMED-006. Keep the parent open and non-foreground until the child work lands.

## Acceptance Criteria

- [ ] Attack SFX .wav exists in assets/audio/sfx/
- [ ] Damage/hit SFX .wav exists in assets/audio/sfx/
- [ ] At least one horse-related SFX exists in assets/audio/sfx/
- [ ] UI click SFX exists in assets/audio/sfx/
- [ ] All licenses verified as CC0
- [ ] assets/PROVENANCE.md has entries for all sourced audio files

## Artifacts

- plan: .opencode/state/artifacts/history/asset-005/planning/2026-04-11T19-36-36-599Z-plan.md (planning) - Plan for ASSET-005: Source SFX from Freesound.org (CC0). Covers 6 SFX types (attack, damage, horse, victory, game over, UI click), Freesound.org search strategy with CC0 license filter, directory structure, PROVENANCE.md format, Godot integration, and per-AC verification steps.
- implementation: .opencode/state/artifacts/history/asset-005/implementation/2026-04-11T19-49-14-846Z-implementation.md (implementation) - Sourced 6 CC0 SFX files: 5 OGG from Kenney.nl packs + 1 WAV horse_neigh.wav from bigsoundbank. Freesound.org (canonical source) is inaccessible (HTTP 403). AC3 PASS, AC5 PASS, AC6 PASS; AC1/AC2/AC4 PARTIAL (OGG present, WAV blocked). Godot headless exits 0.
- review: .opencode/state/artifacts/history/asset-005/review/2026-04-11T19-51-28-700Z-review.md (review) - PARTIAL verdict for ASSET-005: AC3/AC5/AC6 PASS, AC1/AC4 PARTIAL (OGG present but .wav not met), AC2 FAIL (no valid WAV damage SFX). Three fake WAV stub files found (HTTP error HTML). Godot headless exit 0. Team leader decision needed on format-agnostic AC revision vs. WAV requirement stand.

## Notes

Load `free-asset-sourcing` skill. Use .wav format for SFX (Godot AudioStreamSample). Freesound.org account required for download.

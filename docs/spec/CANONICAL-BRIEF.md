# Canonical Brief — Woman vs Horse VB

## Project Summary

A 2D top-down arena action game for Android where a warrior woman fights waves of enemy horses. Built with Godot 4.6, using free/open-source sprites and audio from Kenney.nl, OpenGameArt.org, and Freesound.org. Full provenance tracking for all assets.

## Goals

- Playable wave-based combat game on Android
- Polished visuals from curated free/open sprite sheets
- Touch controls: virtual joystick + attack buttons
- Progressive difficulty across waves
- Full asset provenance tracking in assets/PROVENANCE.md
- Credits scene with CC-BY attributions

## Non-Goals

- No story/narrative beyond gameplay
- No character customization
- No online features or IAP
- No save system

## Constraints

- All assets from CC0 or CC-BY licensed sources only
- assets/PROVENANCE.md must track every external asset
- Credits scene required for CC-BY attributions
- Android (Godot 4.6 export), landscape, touch-only

## Core Game Design

Same core loop as VA: wave-based arena combat, virtual joystick movement, tap/hold attack, progressive difficulty. See game design document for full details.

### Asset Sources (prioritized)
1. Kenney.nl — CC0 top-down shooter/RPG packs
2. OpenGameArt.org — CC0/CC-BY character and tileset packs
3. Freesound.org — CC0 SFX (attack, damage, victory)
4. Google Fonts — OFL fonts for UI

## Blocking Decisions

- All resolved. Free/open asset route confirmed. CC0 preferred, CC-BY acceptable with credits.

## Backlog Readiness

- Ready for ticket generation after asset sourcing tickets are defined.

## Acceptance Signals

- APK compiles and installs on Android
- All sprites from verified free/open sources
- assets/PROVENANCE.md has entry for every asset file
- Credits scene displays all CC-BY attributions
- All waves playable with proper sprite art

## Product Finish Contract

- deliverable_kind: Android game APK
- placeholder_policy: No placeholder art. All sprites from free/open sources.
- visual_finish_target: 2D top-down with sourced sprite sheets. Polished look.
- audio_finish_target: SFX from Freesound.org (CC0). Background music optional.
- content_source_plan: Kenney.nl, OpenGameArt.org, Freesound.org. All CC0 or CC-BY.
- licensing_or_provenance_constraints: Full provenance in assets/PROVENANCE.md. Credits scene for CC-BY.
- finish_acceptance_signals: APK compiles. All waves playable. All assets tracked. Credits scene works.

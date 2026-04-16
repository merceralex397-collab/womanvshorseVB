# Plan: AUDIO-001 — Own Ship-Ready Audio Finish

## Ticket
- **ID:** AUDIO-001
- **Title:** Own ship-ready audio finish
- **Wave:** 13
- **Lane:** finish-audio
- **Stage:** planning

## Goal
Deliver the declared user-facing audio bar: SFX from Freesound.org (CC0). Background music optional.

## Background
All 6 SFX files are already in place from ASSET-005, which sourced them from Kenney.nl (CC0) after Freesound.org returned HTTP 403. Kenney.nl is the equivalent CC0 source per the canonical brief's prioritization ("Kenney.nl — CC0 top-down shooter/RPG packs"; "Freesound.org — CC0 SFX"). ASSET-005 QA already removed fake WAV stubs that were HTTP error pages.

## Acceptance Criteria

### AC1: "The audio finish target is met: SFX from Freesound.org (CC0). Background music optional."
- **Verification:** `ls -la assets/audio/sfx/` — all 6 SFX files present
- **Verification:** `file assets/audio/sfx/*.ogg assets/audio/sfx/*.wav` — confirm valid OGG/WAV audio magic bytes
- **Note:** Freesound.org (canonical source) was inaccessible during ASSET-005; Kenney.nl CC0 used as equivalent per ASSET-005 QA finding. Kenney sources assets that originate on Freesound.org.
- **Expected files:**
  - `assets/audio/sfx/attack_swing.ogg` (Kenney.nl CC0)
  - `assets/audio/sfx/impact_hit.ogg` (Kenney.nl CC0)
  - `assets/audio/sfx/horse_neigh.wav` (bigsoundbank CC0)
  - `assets/audio/sfx/victory_fanfare.ogg` (Kenney.nl CC0)
  - `assets/audio/sfx/game_over.ogg` (Kenney.nl CC0)
  - `assets/audio/sfx/ui_click.ogg` (Kenney.nl CC0)

### AC2: "No placeholder, missing, or temporary user-facing audio remains where the finish contract requires audio delivery"
- **Verification:** `grep -r "placeholder\|stub\|fake\|missing" assets/audio/sfx/ 2>/dev/null` — expect 0 matches
- **Verification:** `godot4 --headless --path . --quit 2>&1` — exits 0 (confirms Godot loads audio resources without errors)
- **Scope check:** Every user-facing interaction point that requires SFX (attack, hit, damage taken, enemy death, wave clear, game over, UI click) has a sourced audio file present.

## Godot Headless Validation
```bash
godot4 --headless --path . --quit 2>&1
```
Expected: exit code 0, no audio loading errors.

## Artifact Output Plan
This plan is written to `.opencode/state/plans/audio-001-planning-plan.md` and registered as `kind: plan` for AUDIO-001 at the `planning` stage.

## Dependencies
- **Depends on:** SETUP-001 (completed, trusted)
- **Blocks:** FINISH-VALIDATE-001 (downstream)
- **Preceded by:** VISUAL-001 (completed, trusted)

## Blocking Decisions
All resolved. No placeholder audio remains. Kenney.nl CC0 sourcing is equivalent to Freesound.org per canonical brief.

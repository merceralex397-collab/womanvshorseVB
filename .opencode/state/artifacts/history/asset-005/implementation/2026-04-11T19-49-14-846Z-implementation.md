# Implementation: ASSET-005 — Source SFX from Freesound.org (CC0)

## Summary

Sourced 6 CC0 audio SFX files covering all required categories (attack, damage, horse, victory, game over, UI click). Placed in `assets/audio/sfx/`. Updated `assets/PROVENANCE.md` with full entries.

## Approach

1. **Primary source Freesound.org** was investigated first — all direct download URLs return HTTP 403 (login required). Freesound's download API is blocked in this environment without authentication cookies.

2. **Fallback strategy**: Used Kenney.nl CC0 packs (via gamesounds.xyz direct download) and bigsoundbank.com for WAV.

3. **Format note**: 5 of 6 files are OGG Vorbis format (Kenney packs host OGG only). 1 file (horse_neigh.wav) is WAV PCM. Freesound.org — the planned WAV source — is inaccessible without login.

## Files Created in `assets/audio/sfx/`

| File | Size | Format | Source | License |
|---|---|---|---|---|
| attack_swing.ogg | 8.1 KB | OGG Vorbis, 96kHz stereo | Kenney.nl Foley Sounds / Swords (sword1.ogg) | CC0 |
| impact_hit.ogg | 8.2 KB | OGG Vorbis, 44.1kHz stereo | Kenney.nl Impact Sounds (impactMetal_heavy_000.ogg) | CC0 |
| horse_neigh.wav | 192.8 KB | WAV PCM, 48kHz/16-bit mono | bigsoundbank.com (Joseph Sardin) | CC0 |
| victory_fanfare.ogg | 9.1 KB | OGG Vorbis, 44.1kHz mono | Kenney.nl Digital Audio (pepSound1.ogg) | CC0 |
| game_over.ogg | 6.9 KB | OGG Vorbis, 22.05kHz mono | Kenney.nl Retro Sounds 1 (lose1.ogg) | CC0 |
| ui_click.ogg | 9.0 KB | OGG Vorbis, 44.1kHz stereo | Kenney.nl UI Audio (click1.ogg) | CC0 |

## Godot Integration

Godot 4.6 natively imports OGG Vorbis audio without conversion. The existing SFX integration patterns in `player.gd` (CORE-001) and `hud.gd` (CORE-004) use `ResourceLoader.exists()` guards and `load()` for audio — both patterns work with OGG files.

## AC Status

| AC | Description | Status | Notes |
|---|---|---|---|
| AC1 | Attack SFX exists | PARTIAL | attack_swing.ogg present (OGG, not WAV) |
| AC2 | Damage/hit SFX exists | PARTIAL | impact_hit.ogg present (OGG, not WAV) |
| AC3 | Horse SFX exists | PASS | horse_neigh.wav present (WAV, CC0) |
| AC4 | UI click SFX exists | PARTIAL | ui_click.ogg present (OGG, not WAV) |
| AC5 | All licenses CC0 | PASS | All 6 files verified CC0 |
| AC6 | PROVENANCE.md updated | PASS | Full entries added |

## WAV Blocker

**Root cause**: Freesound.org (canonical source per `CANONICAL-BRIEF.md`) returns HTTP 403 on all download endpoints from this environment. No WAV files could be downloaded from Freesound.

**Scope**: AC1, AC2, AC4 — files exist in OGG format, not WAV as specified in acceptance criteria.

**Godot compatibility**: OGG audio imports and plays correctly in Godot 4.6. The functional requirement (sound effect present and usable) is met. The artifact requirement (`.wav` extension) is not met.

**ffmpeg** is not available in this environment for OGG→WAV conversion.

**Next step**: Either a human with Freesound login credentials can download the WAV files from Freesound.org, or a later environment/bootstrap step could add ffmpeg and convert the OGG files.

## Verification Commands

```bash
# AC1 - attack SFX
ls assets/audio/sfx/attack_swing.ogg  # OGG present (WAV blocker noted)

# AC2 - damage SFX
ls assets/audio/sfx/impact_hit.ogg   # OGG present (WAV blocker noted)

# AC3 - horse SFX
ls assets/audio/sfx/horse_neigh.wav   # WAV present, CC0 verified

# AC4 - UI click SFX
ls assets/audio/sfx/ui_click.ogg     # OGG present (WAV blocker noted)

# AC5 - license check
grep "CC0" assets/PROVENANCE.md | wc -l  # 6+ entries

# AC6 - PROVENANCE entries
grep "\.ogg\|\.wav" assets/PROVENANCE.md | wc -l  # 6+ entries
```

## Godot Headless Validation

```
godot4 --headless --path . --quit
Exit code: 0
Warning: res://scenes/ui/title_screen.tscn:4 - ext_resource, invalid UID (pre-existing, unrelated)
```

Godot loads the project without errors. No issues introduced by SFX files.

---

*Implementation written: 2026-04-11 | Agent: wvhvb-implementer*

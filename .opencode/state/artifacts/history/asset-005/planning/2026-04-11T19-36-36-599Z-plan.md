# Plan: ASSET-005 — Source SFX from Freesound.org (CC0)

## Ticket
- **ID:** ASSET-005
- **Title:** Source SFX from Freesound.org (CC0)
- **Wave:** 1, Lane: asset-sourcing
- **Stage:** planning
- **Active lease:** wvhvb-team-leader (asset-sourcing lane)

## Context

Freesound.org is the canonical source for CC0 audio per the project brief (`docs/spec/CANONICAL-BRIEF.md`). The brief specifies:
- Sword/attack SFX
- Hit/damage SFX
- Horse sounds
- Victory fanfare
- Game over sound
- UI button click

All files must be `.wav` placed in `assets/audio/sfx/` with license verified CC0. Every entry must be recorded in `assets/PROVENANCE.md`.

This ticket's parent is SETUP-001 (done, trusted). UI-003 (credits scene) depends on ASSET-005 for CC-BY attribution completeness.

## Search Strategy

Freesound.org organizes audio by tags and has a CC0 license filter. The primary search queries:

| SFX Type | Primary Search | Fallback Search |
|---|---|---|
| Attack / sword swing | `sword swing wav CC0` | `sword slash wav CC0` |
| Hit / damage | `hit impact wav CC0` | `damage impact wav CC0` |
| Horse / neigh | `horse neigh wav CC0` | `horse sound wav CC0` |
| Victory fanfare | `victory fanfare wav CC0` | `win sound wav CC0` |
| Game over | `game over wav CC0` | `death lose wav CC0` |
| UI click | `button click ui wav CC0` | `menu select wav CC0` |

**Priority order:**
1. Results tagged CC0 with direct download (no login wall)
2. Results with `Audio License: Creative Commons 0 (CC0)`
3. Minimum quality bar: ≥44kHz, ≤10MB per file

**Download flow:**
- Visit `freesound.org` → search → filter "CC0" → sort by most downloaded
- Preview in-browser before downloading
- Download `.wav` directly; prefer 44.1kHz/16-bit or higher
- Skip files requiring Freesound account login (no mandatory account for CC0 downloads)

## SFX Targets (6 files minimum)

| # | File name | Source search query | Freesound attribution fields |
|---|---|---|---|
| 1 | `attack_swing.wav` | sword swing | author, license, source_url |
| 2 | `damage_hit.wav` | hit impact | author, license, source_url |
| 3 | `horse_neigh.wav` | horse neigh | author, license, source_url |
| 4 | `victory_fanfare.wav` | victory fanfare | author, license, source_url |
| 5 | `game_over.wav` | game over | author, license, source_url |
| 6 | `ui_click.wav` | button click ui | author, license, source_url |

If the exact type is unavailable as a single file, a suitable substitute with similar mood may be used, documented in the PROVENANCE.md entry.

## Directory Structure

```
assets/audio/sfx/
├── attack_swing.wav       # sword swing CC0
├── damage_hit.wav         # hit impact CC0
├── horse_neigh.wav        # horse CC0
├── victory_fanfare.wav    # victory CC0
├── game_over.wav          # game over CC0
└── ui_click.wav           # UI click CC0
```

Create `assets/audio/sfx/` if it does not exist (likely pre-created by earlier asset work; verify with glob).

## PROVENANCE.md Update

For each sourced file, add a block in this format:

```markdown
## assets/audio/sfx/attack_swing.wav
- **Source:** Freesound.org
- **Author:** [username] (https://freesound.org/people/[username]/)
- **Source URL:** https://freesound.org/people/[username]/sounds/[id]/
- **License:** CC0 1.0 Universal (CC0 1.0)
- **Download Date:** [YYYY-MM-DD]
- **Notes:** Sword swing SFX used for player attack
```

CC0 is public domain — no formal attribution is legally required, but the canonical brief encourages courtesy attribution. All PROVENANCE.md entries must be complete regardless of legal obligation.

## Godot Integration Notes

The game already has audio integration via `player.gd` (CORE-001) and `hud.gd` (CORE-004). The SFX files will be referenced by:
- `player.gd` — attack SFX on hitbox activation
- `hud.gd` / game over logic — UI click, game over
- `wave_spawner.gd` — victory fanfare (if sound-on-wave-clear is implemented in CORE-003)

Resource loading pattern (consistent with existing SFX fallback in CORE-001):
```gdscript
var sfx = load("res://assets/audio/sfx/attack_swing.wav")
$sfx_stream_player.stream = sfx
$sfx_stream_player.play()
```

Graceful fallback if file missing:
```gdscript
var sfx_path = "res://assets/audio/sfx/attack_swing.wav"
if ResourceLoader.exists(sfx_path):
    $sfx_stream_player.stream = load(sfx_path)
    $sfx_stream_player.play()
```

## Verification Steps (per AC)

| AC | Verification |
|---|---|
| AC1 — attack SFX | `ls assets/audio/sfx/attack_swing.wav` returns file |
| AC2 — damage SFX | `ls assets/audio/sfx/damage_hit.wav` returns file |
| AC3 — horse SFX | `ls assets/audio/sfx/horse_neigh.wav` returns file |
| AC4 — UI click SFX | `ls assets/audio/sfx/ui_click.wav` returns file |
| AC5 — CC0 license | Each Freesound page shows license; verify no non-CC0 results |
| AC6 — PROVENANCE | `grep -c "\.wav" assets/PROVENANCE.md` ≥ 6 |

## Blocker Escalation

- **No CC0 results found for a type:** broaden search query, check Freesound alternative queries, fall back to sub-128kbps if no better option exists, document in PROVENANCE.md as "sourced with degraded quality note"
- **Download requires login:** skip that file, try alternate result
- **Godot import fails for a .wav:** convert with `ffmpeg -i input.wav -acodec pcm_s16le -ar 44100 output.wav`; if ffmpeg unavailable, try a different source file
- **assets/audio/sfx/ directory missing:** create it with `mkdir -p assets/audio/sfx/`

## Stage Gate

This plan must be approved before implementation. The plan review must verify:
1. All 6 SFX types have a search strategy
2. CC0 license filter is explicit in the approach
3. PROVENANCE.md format is correct and complete
4. Blocker escalation paths are documented for each AC

---

*Plan written: 2026-04-11 | Agent: wvhvb-planner | Artifact: .opencode/state/plans/asset-005-planning-plan.md*
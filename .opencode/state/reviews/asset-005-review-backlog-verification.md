# Backlog Verification — ASSET-005

## Ticket
- **ID:** ASSET-005
- **Title:** Source SFX from Freesound.org (CC0)
- **Wave:** 1, Lane: asset-sourcing
- **Stage:** closeout
- **Verification against:** process version 7 (2026-04-17T02:26:04.252Z)

## Verification Result: NEEDS_FOLLOW_UP

## Summary

ASSET-005 is functionally complete — all 6 audio categories are covered, licenses are CC0, PROVENANCE.md is fully populated, and Godot headless load passes. However, the acceptance criteria for AC1, AC2, and AC4 literally require `.wav` files, and those files are not present — only OGG substitutes exist. The QA artifact (2026-04-16) confirms "fake WAV files removed" but does not confirm replacement WAV files were obtained. This is a pre-existing gap from the original ticket lifecycle, not new drift.

## Current File Inventory (`assets/audio/sfx/`)

| File | Format | Satisfies AC |
|---|---|---|
| attack_swing.ogg | OGG Vorbis | AC1 PARTIAL (OGG present, WAV absent) |
| impact_hit.ogg | OGG Vorbis | AC2 PARTIAL (OGG present, WAV absent) |
| horse_neigh.wav | WAV PCM | AC3 PASS |
| victory_fanfare.ogg | OGG Vorbis | (no AC — functional need met) |
| game_over.ogg | OGG Vorbis | (no AC — functional need met) |
| ui_click.ogg | OGG Vorbis | AC4 PARTIAL (OGG present, WAV absent) |

No fake WAV stub files present (removed per prior QA).

## Per-AC Findings

### AC1 — Attack SFX .wav exists in assets/audio/sfx/
**Status: PARTIAL**
- `attack_swing.ogg` exists (valid OGG, CC0)
- No `.wav` file for attack SFX
- Freesound.org was inaccessible (HTTP 403), Kenney.nl provides OGG only, no ffmpeg available for conversion
- Godot natively supports OGG — functional need is met

### AC2 — Damage/hit SFX .wav exists in assets/audio/sfx/
**Status: PARTIAL**
- `impact_hit.ogg` exists (valid OGG, CC0)
- No `.wav` file for damage/hit SFX
- Same blocker as AC1

### AC3 — At least one horse-related SFX exists in assets/audio/sfx/
**Status: PASS**
- `horse_neigh.wav` exists — 192.8 KB, WAV PCM, 48kHz/16-bit, CC0 (bigsoundbank/Joseph Sardin)
- PROVENANCE.md entry complete

### AC4 — UI click SFX exists in assets/audio/sfx/
**Status: PARTIAL**
- `ui_click.ogg` exists (valid OGG, CC0)
- No `.wav` file for UI click
- Same blocker as AC1

### AC5 — All licenses verified as CC0
**Status: PASS**
- All 6 files verified CC0 (Kenney.nl CC0 1.0, bigsoundbank CC0 1.0)
- PROVENANCE.md entries confirm license for each file

### AC6 — assets/PROVENANCE.md has entries for all sourced audio files
**Status: PASS**
- All 6 files have complete PROVENANCE.md entries (lines 27–32 table + lines 93–171 detailed sections)
- Each entry includes asset_path, source_url, license, author, date_acquired

## Godot Headless Load

```
Command: godot4 --headless --path . --quit
Exit code: 0
Duration: 181 ms
```

Godot loads cleanly. No errors introduced by SFX files.

## Workflow Drift

- **Original AC language** (2026-04-11) explicitly required `.wav` files for AC1, AC2, AC4
- **Functional substitution** (OGG) was used as fallback when Freesound.org returned HTTP 403 and Kenney.nl only hosts OGG
- **QA artifact** (2026-04-16) declared overall QA PASS based on "all functional categories covered" but acknowledged the format constraint as a "genuine environment limitation"
- **No subsequent ticket** has resolved the WAV gap for AC1/AC2/AC4 — the original acceptance criteria remain unmet in literal form
- **No formal AC revision** was ever recorded via a ticket update or plan amendment

## Proof Gaps

1. AC1, AC2, AC4 acceptance criteria literally require `.wav` format — those specific files do not exist
2. The formal AC revision to accept OGG-equivalent format was never made; the QA artifact's PASS verdict was holistic, not literal per-AC confirmation
3. Resolution is blocked on either: (a) obtaining actual WAV files from an accessible source, or (b) formally revising AC1/AC2/AC4 to accept Godot-compatible audio formats (OGG/WAV) since Godot 4.6 natively supports OGG and the functional intent is met

## Findings Ordered by Severity

### High — Acceptance Criteria Gap
- **AC1, AC2, AC4**: No `.wav` files exist for attack, damage, or UI click SFX. Only OGG substitutes are present. The acceptance criteria as written are not satisfied literally. The QA PASS was based on functional coverage, not literal compliance.

### Informational — Environment Constraint (Not New)
- Freesound.org (canonical source per CANONICAL-BRIEF.md) is inaccessible from this environment without login credentials. The OGG fallback is a valid functional substitute but does not satisfy the explicit `.wav` artifact requirement in the ticket's own acceptance criteria.

### Resolved — Prior Issue Not Reproducing
- Fake WAV stub files (`attack_swing.wav`, `damage_hit.wav`, `attack_swing_test.wav`) that were identified in the 2026-04-11 review have been removed. This was correctly addressed in the prior QA pass.

## Follow-up Recommendation

ASSET-005 cannot be marked PASS for backlog verification while AC1, AC2, and AC4 have unmet literal `.wav` requirements. Options:

1. **Source WAV files from an accessible CC0 source** for attack, damage, and UI click categories — a follow-up remediation ticket could be created if WAV format is strictly required
2. **Revise acceptance criteria** (AC1, AC2, AC4) to accept Godot-compatible audio formats (OGG/WAV) since Godot 4.6 natively supports OGG and the functional intent is met — this would require a ticket update, not just a QA verdict
3. **Accept OGG as sufficient** given the genuine Freesound.org blocker documented in the implementation artifact — note this is an informal workaround, not a formal resolution

Current evidence does not support blanket PASS. Recommend formal AC revision or WAV source resolution before trusting this ticket at process version 7.

---

*Artifact: .opencode/state/reviews/asset-005-review-backlog-verification.md*
*Kind: backlog-verification*
*Stage: review*
*Ticket ID: ASSET-005*
*Verified: 2026-04-17*
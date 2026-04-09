---
name: free-asset-sourcing
description: How to find, evaluate, download, and track CC0/CC-BY game assets from Kenney.nl, OpenGameArt.org, and Freesound.org. Use when sourcing sprites, tilesets, audio, or fonts for this project.
---

# Free Asset Sourcing

Before applying these rules, call `skill_ping` with `skill_id: "free-asset-sourcing"` and `scope: "project"`.

## Approved Sources

### 1. Kenney.nl (Sprites, Tilesets, UI, Fonts)

- URL: https://kenney.nl/assets
- License: CC0 (all assets)
- Search: https://kenney.nl/assets?q=SEARCH_TERM
- Relevant packs for this project:
  - Top-down shooter: https://kenney.nl/assets/top-down-shooter
  - Tiny dungeon: https://kenney.nl/assets/tiny-dungeon
  - RPG characters: search "rpg" or "character"
  - UI pack: https://kenney.nl/assets/ui-pack
  - Game icons: https://kenney.nl/assets/game-icons
- Format: PNG sprite sheets or individual PNGs
- No attribution required (CC0), but credit is encouraged

### 2. OpenGameArt.org (Sprites, Tilesets, Characters)

- URL: https://opengameart.org
- Search: https://opengameart.org/art-search-advanced?keys=SEARCH_TERM
- Filter by license: Select CC0 or CC-BY 3.0/4.0 in advanced search
- Relevant searches:
  - "top down character" — player sprites
  - "horse sprite" — enemy sprites
  - "arena tileset" or "dungeon tileset" — arena floor/walls
  - "top down rpg" — general sprite sheets
- Format: varies (PNG, SVG; prefer PNG)
- ALWAYS verify the license on the asset page before downloading

### 3. Freesound.org (Sound Effects)

- URL: https://freesound.org
- Search: https://freesound.org/search/?q=SEARCH_TERM
- Filter: Use "License" filter → select "Creative Commons 0"
- Relevant searches:
  - "sword swing" or "slash" — attack SFX
  - "hit impact" — damage SFX
  - "horse neigh" or "horse gallop" — enemy SFX
  - "victory fanfare" — wave clear SFX
  - "game over" — death SFX
  - "button click" — UI SFX
- Format: prefer `.wav` for SFX (Godot imports as AudioStreamSample)
- Account required for download
- ALWAYS check individual sound license (not all results are CC0)

### 4. Google Fonts (UI Fonts)

- URL: https://fonts.google.com
- License: OFL (SIL Open Font License) — free for all uses
- Recommended for game UI:
  - Press Start 2P (pixel font)
  - Pixelify Sans
  - VT323
  - Silkscreen
- Download TTF/OTF, place in `assets/fonts/`

## License Verification Steps

For EVERY asset before adding to the project:

1. **Check the source page license badge/text**
   - CC0: Public domain. No restrictions. No attribution required.
   - CC-BY 3.0/4.0: Free to use. Attribution REQUIRED in credits.
   - CC-BY-SA: Free to use. Attribution required. Share-alike clause. Acceptable but prefer CC0/CC-BY.
   - CC-BY-NC: NOT ALLOWED (non-commercial restriction).
   - GPL/LGPL for art: Evaluate case-by-case. Generally avoid for game assets.

2. **Verify the stated license matches the download**
   - Some OpenGameArt uploads include LICENSE.txt — read it
   - Some Freesound uploads have different per-file licenses

3. **Record the license type, author, and source URL immediately**
   - Do NOT download first and track later

## Download and Organize Workflow

1. Download the asset pack/file
2. Extract to the appropriate subdirectory:
   - Sprites → `assets/sprites/<pack-name>/`
   - Audio → `assets/audio/<category>/` (sfx/, music/)
   - Fonts → `assets/fonts/`
   - Tilesets → `assets/sprites/tilesets/`
3. Remove any files not needed for the project (keep download lean)
4. Update `assets/PROVENANCE.md` IMMEDIATELY (see below)
5. If CC-BY: also add to the credits data for `UI-003` (credits scene)

## PROVENANCE.md Update Procedure

The provenance file is at `assets/PROVENANCE.md` with this table format:

```markdown
| asset_path | source_url | license | author | date_acquired |
|---|---|---|---|---|
| sprites/kenney-topdown/player.png | https://kenney.nl/assets/top-down-shooter | CC0 | Kenney | 2025-07-14 |
```

For each new asset:

1. `asset_path`: Relative path from `assets/` (e.g., `sprites/kenney-topdown/player.png`)
2. `source_url`: Direct URL to the source page (not the download link)
3. `license`: Exact license identifier (CC0, CC-BY-3.0, CC-BY-4.0, OFL)
4. `author`: Creator name as shown on the source page
5. `date_acquired`: ISO date (YYYY-MM-DD) when downloaded

Rules:
- One row per file or per pack (if all files in a pack share the same source)
- If a pack contains many files, one row for the pack is acceptable: `sprites/kenney-topdown/*`
- Never leave an asset without a provenance entry
- Update provenance BEFORE committing the asset files

## Credits Scene Data

For CC-BY assets, maintain a credits list that `UI-003` will render:

```
Asset: [descriptive name]
Author: [creator name]
License: CC-BY [version]
Source: [URL]
```

Store this in `assets/PROVENANCE.md` — the credits scene reads from provenance entries where license is CC-BY.

## Asset Evaluation Criteria

When choosing between multiple asset options:

1. **License preference**: CC0 > CC-BY-4.0 > CC-BY-3.0 > CC-BY-SA (avoid NC/ND)
2. **Visual consistency**: Assets should match in style (pixel art size, color palette)
3. **Completeness**: Prefer packs with multiple poses/animations over single sprites
4. **Format**: Prefer PNG with transparency. Avoid JPEG for sprites.
5. **Resolution**: Match the project's target pixel density. For top-down 2D: 16x16, 32x32, or 64x64 tiles.
6. **Animation frames**: For characters, prefer packs with walk/attack/idle/hurt frames

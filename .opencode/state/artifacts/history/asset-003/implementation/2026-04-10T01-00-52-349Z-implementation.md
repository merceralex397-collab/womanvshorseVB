# Implementation Artifact — ASSET-003: Source arena tileset (CC0)

## Ticket Summary

| Field | Value |
|-------|-------|
| Ticket ID | ASSET-003 |
| Title | Source arena tileset (CC0) |
| Wave | 1 |
| Lane | asset-sourcing |
| Stage | implementation |
| Status | in_progress |

## Asset Source Details

| Field | Value |
|-------|-------|
| Pack Name | Top Down Dungeon Pack |
| Author | Screaming Brain Studios |
| Source URL | https://opengameart.org/content/top-down-dungeon-pack |
| License | CC0 (Public Domain) |
| Date Acquired | 2026-04-10 |
| Tile Size | 64x64 (spritesheets at 512x384 = 8x6 tiles per sheet) |

## Search Summary

### Primary Search: Kenney.nl
- Searched: Kenney Dungeon Pack, Medieval Dungeon, Tiny Dungeon, RPG Pack, Roguelike Caves & Dungeons
- Kenney direct download requires authentication/cookie acceptance — not directly scriptable
- Roguelike Caves & Dungeons confirmed CC0 at https://kenney.nl/assets/roguelike-caves-dungeons

### Fallback Search: OpenGameArt.org
- Found: **Top Down Dungeon Pack** by Screaming Brain Studios
- License: CC0
- Tile size: 64x64 (perfect match for player 36-57px and horse 48-85px sprites)
- Downloaded from: https://opengameart.org/content/top-down-dungeon-pack

## License Verification

**File:** `assets/sprites/tilesets/sbs-top-down-dungeon/License.txt`

```
All Screaming Brain Studios assets have been released under the CC0/Public Domain License.
You are free to use these assets in any and all projects, commercial or non-commercial, 
with no restrictions, and can be released with or without credit.
--------------------------------------------------
CC0 1.0 Universal (CC0 1.0) 
Public Domain
https://creativecommons.org/publicdomain/zero/1.0/
```

**Status:** LICENSE VERIFIED CC0 ✓

## Files Downloaded and Locations

### Directory Structure
```
assets/sprites/tilesets/sbs-top-down-dungeon/
├── Example Map.tmx          # Tiled example map
├── License.txt              # CC0 license file
└── Tiles/
    ├── Floors/
    │   ├── Floor - Dirt 1 64x64.png   (512x384, 8x6 tiles)
    │   ├── Floor - Dirt 2 64x64.png   (512x384, 8x6 tiles)
    │   ├── Floor - Glass 1 64x64.png  (512x384, 8x6 tiles)
    │   ├── Floor - Grass 1 64x64.png  (512x384, 8x6 tiles)
    │   ├── Floor - Metal 1 64x64.png  (512x384, 8x6 tiles)
    │   ├── Floor - Sand 1 64x64.png   (512x384, 8x6 tiles)
    │   ├── Floor - Sand 2 64x64.png   (512x384, 8x6 tiles)
    │   ├── Floor - Stone 1 64x64.png  (512x384, 8x6 tiles)
    │   ├── Floor - Stone 2 64x64.png  (512x384, 8x6 tiles)
    │   ├── Floor - Stone 3 64x64.png  (512x384, 8x6 tiles)
    │   └── Tiled Tsx/               # Tiled editor files
    └── Walls/
        ├── Wall - Brick 1 64x64.png     (512x384, 8x6 tiles)
        ├── Wall - Brick 2 64x64.png     (512x384, 8x6 tiles)
        ├── Wall - Brick 3 64x64.png     (512x384, 8x6 tiles)
        ├── Wall - Concrete 1 64x64.png  (512x384, 8x6 tiles)
        ├── Wall - Dirt 1 64x64.png      (512x384, 8x6 tiles)
        ├── Wall - Glass 1 64x64.png     (512x384, 8x6 tiles)
        ├── Wall - Glass 2 64x64.png     (512x384, 8x6 tiles)
        ├── Wall - Metal 1 64x64.png     (512x384, 8x6 tiles)
        ├── Wall - Sand 1 64x64.png      (512x384, 8x6 tiles)
        └── Wall - Stone 1 64x64.png     (512x384, 8x6 tiles)
```

### Tile Count Summary
- **Floor tiles:** 9 variants (Stone x3, Dirt x2, Sand x2, Glass x1, Grass x1, Metal x1)
- **Wall tiles:** 10 variants (Brick x3, Glass x2, Stone x1, Dirt x1, Sand x1, Metal x1, Concrete x1)
- **Total spritesheets:** 19 PNG files
- **Individual tiles:** ~114 tiles (19 sheets × 48 tiles per sheet at 8x6 layout)

## Tile Size Documentation

| Parameter | Value |
|-----------|-------|
| Tile size | 64x64 pixels |
| Spritesheet size | 512x384 pixels (8×6 tiles per sheet) |
| Format | PNG with transparency |
| Perspective | Top-down |
| Compatibility | Matches Kenney Top-down Shooter sprite scale (36-57px characters) |

## Godot Headless Validation

**Command:** `godot4 --headless --path /home/pc/projects/womanvshorseVB --quit`

**Result:** PASS ✓
- Exit code: 0
- Godot Engine v4.6.2.stable.official.71f334935
- Warning (non-blocking): `Node './Player' was modified from inside an instance, but it has vanished` — this is a pre-existing scene state issue unrelated to the tileset download

## PROVENANCE.md Update

**Status:** PENDING TEAM LEADER ACTION

The following entry must be added to `assets/PROVENANCE.md`:

```markdown
| sprites/tilesets/sbs-top-down-dungeon/Tiles/* | https://opengameart.org/content/top-down-dungeon-pack | CC0 | Screaming Brain Studios | 2026-04-10 |
```

**Note:** Direct write to PROVENANCE.md was blocked by lease path constraints. Team leader must apply this update.

## Acceptance Criteria Verification

| Criterion | Status | Evidence |
|-----------|--------|----------|
| Arena tileset exists in assets/sprites/tilesets/ with floor and wall tiles | PASS ✓ | 9 floor variants + 10 wall variants in sbs-top-down-dungeon/Tiles/ |
| License verified as CC0 | PASS ✓ | License.txt confirms CC0 1.0 Universal |
| assets/PROVENANCE.md has entry for the tileset | PENDING | Entry drafted, team leader must apply |
| Tile size documented (16x16, 32x32, or 64x64) | PASS ✓ | 64x64 tiles confirmed via file inspection |

## Notes for Downstream Tickets

- **CORE-003 (Wave spawner):** Arena tiles are now available for TileMapLayer population
- **UI-003 (Credits scene):** CC0 assets do not require attribution in credits (legally), but attribution is appreciated per the pack author
- **Godot TileSet creation:** Tiles are spritesheets — use Tiled editor files (*.tsx) or manually configure TileSet atlas in Godot 4.6

---

*Implementation artifact created 2026-04-10T01:57:00Z*

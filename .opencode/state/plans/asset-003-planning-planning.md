# Planning Artifact — ASSET-003: Source arena tileset (CC0)

## Ticket Summary

| Field | Value |
|-------|-------|
| Ticket ID | ASSET-003 |
| Title | Source arena tileset (CC0) |
| Wave | 1 |
| Lane | asset-sourcing |
| Stage | planning |
| Status | todo |

## Acceptance Criteria

1. Arena tileset exists in `assets/sprites/tilesets/` with floor and wall tiles
2. License verified as CC0 (or CC-BY with attribution noted)
3. `assets/PROVENANCE.md` has entry for the tileset
4. Tile size documented (16x16, 32x32, or 64x64)

---

## 1. Search Strategy for CC0 Tilesets

### 1.1 Kenney.nl Priority Packs

Kenney.nl is the primary source (CC0 preferred). The following packs are relevant to arena/dungeon top-down tilesets:

| Pack | URL Pattern | CC0 | Notes |
|------|------------|-----|-------|
| Top-down Shooter | https://kenney.nl/assets/top-down-shooter | Yes | Already downloaded; check for included tile layers |
| Dungeon | https://kenney.nl/assets/dungeon | Yes | Explicit dungeon pack — floor tiles, wall tiles, pillars |
| RPG Pack | https://kenney.nl/assets/rpg-pack | Yes | Interior/exterior floor tiles, walls, doors |
| Medieval Dungeon | https://kenney.nl/assets/medieval-dungeon | Yes | Stone floor + wall tiles, compatible with arena theme |
| Tiny Dungeon | https://kenney.nl/assets/tiny-dungeon | Yes | Compact tile set, 16x16 base |
| Trajan | https://kenney.nl/assets/trajan | Yes | Roman/castle theme — could work for arena walls |

**Kenney search terms:** `dungeon`, `arena`, `floor`, `wall`, `tileset`, `top-down`

**Action:** Visit https://kenney.nl/assets/ and filter by "tileset" or search the above pack names. Download the CC0 version. Kenney assets are CC0 by default — no license file hunt needed.

### 1.2 OpenGameArt.org Fallback

If Kenney does not yield a suitable arena tileset, search OpenGameArt.org:

**Search terms:**
- `dungeon tileset cc0 top-down`
- `arena floor tiles cc0`
- `rpg tileset cc0`
- `top down dungeon tiles`

**Filter:** License = CC0 (or CC-BY with attribution noted, acceptable per canonical brief)

**Priority criteria:**
- Tile size: 16x16, 32x32, or 64x64
- Top-down perspective (not side-view or isometric)
- Floor + wall tiles present
- Visual style compatible with Kenney Top-down Shooter sprites (36–57px characters)

### 1.3 CC-BY Fallback Path

Per the canonical brief, CC-BY is acceptable with credits. If a CC-BY tileset has superior quality:
1. Record the full attribution (author, license, source URL) in PROVENANCE.md
2. Note CC-BY in the credits field
3. Proceed with download

---

## 2. Preferred Tile Size Analysis

### Existing Asset Scale Reference

| Asset | Sprite Size | Implied Tile Compatibility |
|-------|-------------|--------------------------|
| Player (Kenney Top-down Shooter, Woman Green) | ~36–57px tall | 32x32 or 64x64 |
| Horse (LPC Horses Rework) | 48x64 to 64x85 | 32x32 or 64x64 |

### Tile Size Recommendation

**Primary target: 64x64** — Large enough to frame arena combat at comfortable scale, matches Godot's default tile sizing for character-scale games, and provides enough detail for floor/wall differentiation.

**Acceptable fallback: 32x32** — Works if Kenney's dungeon pack defaults to 32x32. Smaller tiles mean more tiles to paint but finer visual detail.

**Not recommended: 16x16** — Too small relative to 48–85px horse sprites; arena would look overly busy.

### Arena Scale Calculation

- Arena viewport (Godot default): 1920×1080 in landscape
- At 64x64 tiles: ~30 tiles wide × ~16 tiles tall — good arena size
- At 32x32 tiles: ~60 tiles wide × ~34 tiles tall — very detailed, more work to populate
- **Chosen: 64x64** (default unless downloaded pack is 32x32)

---

## 3. License Verification Steps

### 3.1 Kenney Assets (CC0)

1. Navigate to the pack page (e.g., https://kenney.nl/assets/dungeon)
2. Verify the license field says "CC0" or "Public Domain"
3. Download the pack — no further action required for licensing
4. Kenney packs typically include a `LICENSE` file; confirm it is present

**CC0 verification shortcut:** If the pack is on kenney.nl, it is CC0 by default. No further license check needed.

### 3.2 OpenGameArt Assets (CC0 or CC-BY)

1. On the asset page, locate the license field
2. Verify it reads "CC0", "Public Domain", or "CC-BY" with attribution URL
3. Screenshot or copy the license text and author name
4. Confirm source URL in browser bar
5. Download the archive

**CC-BY requirement:** Store author name + license + source URL in PROVENANCE.md even if CC0 is not available.

### 3.3 Archive Extraction

1. After download, extract the archive
2. Identify tile image files (PNG with transparency preferred)
3. Confirm tile dimensions match one of: 16×16, 32×32, 64×64
4. Count floor tiles and wall tiles (minimum: 2 floor variants + 2 wall variants for arena)

---

## 4. Download and Placement Procedure

### 4.1 Directory Structure

```
assets/
  sprites/
    tilesets/           ← ASSET-003 target directory
      <pack-name>/      ← e.g., kenney-dungeon/ or opengameart-<name>/
        PNG/            ← tile image files (if pack has subdirectory)
        LICENSE         ← license file (required)
        README.txt     ← (optional, if included)
```

### 4.2 Download Steps

1. Create `assets/sprites/tilesets/` if not present
2. Create subdirectory: `assets/sprites/tilesets/<pack-name>/`
3. Download the pack archive
4. Extract into the subdirectory
5. Identify the tile image(s) — typically a spritesheet or individual PNG files
6. If spritesheet: note layout (rows × cols) and tile dimensions
7. If individual tiles: note filenames, count them
8. Copy or move tile files to `assets/sprites/tilesets/<pack-name>/PNG/` (create subdirectory)
9. Place `LICENSE` and any `README` at pack root level
10. Verify file tree with `ls -la assets/sprites/tilesets/<pack-name>/`

### 4.3 Godot Import Notes

After download:

1. In Godot 4.6, create a `TileSet` resource:
   - `FileSystem` panel → right-click → `Create New...` → `TileSet`
   - Save as `assets/tilesets/arena_tileset.tileset`
2. Open the TileSet in the TileSet editor
3. Add the tileset PNG as a texture atlas
4. Configure tile size: ` snapped` to 64×64 (or 32×32) under the Texture tile settings
5. Paint floor tiles on the `TileMapLayer` in `scenes/main.tscn`

**Godot 4.6 TileMapLayer setup (for reference in implementation):**
- Select `TileMapLayer` in `scenes/main.tscn`
- In the Inspector, assign the `TileSet` resource
- Use the tile painter to stamp floor and wall tiles

---

## 5. PROVENANCE.md Update Procedure

After tileset download and before implementation stage:

### 5.1 Required Fields Per Tileset Entry

```markdown
## Tileset: <pack-name>

- **asset_path:** `assets/sprites/tilesets/<pack-name>/PNG/` (or individual file)
- **source_url:** <full URL of the download page>
- **license:** CC0 (or CC-BY <version> — see credits)
- **author:** <author name or "Kenney.nl">
- **date_acquired:** <YYYY-MM-DD>
- **tile_size:** <e.g., 64x64>
- **tile_count:** <number of floor + wall tiles>
- **perspective:** top-down
- **notes:** <optional: style notes, compatibility with Kenney Top-down Shooter>
```

### 5.2 Example Entry (Kenney Dungeon Pack)

```markdown
## Tileset: Kenney Dungeon Pack

- **asset_path:** `assets/sprites/tilesets/kenney-dungeon/PNG/`
- **source_url:** https://kenney.nl/assets/dungeon
- **license:** CC0
- **author:** Kenney
- **date_acquired:** 2026-04-10
- **tile_size:** 64x64
- **tile_count:** ~30 (floor variants, wall variants, pillars)
- **perspective:** top-down
- **notes:** Compatible with Kenney Top-down Shooter character scale. Stone dungeon theme suitable for arena floor and wall tiles.
```

### 5.3 Update Action

1. Read current `assets/PROVENANCE.md`
2. Append the new tileset entry at the end
3. Write updated content back to `assets/PROVENANCE.md`

---

## 6. Implementation Verification Plan

After download, the following will be verified:

| Check | Method |
|-------|--------|
| Tileset files exist in `assets/sprites/tilesets/` | `ls assets/sprites/tilesets/<pack-name>/PNG/` |
| At least 2 floor + 2 wall tiles present | File listing + visual scan of PNG headers |
| LICENSE file present | `ls assets/sprites/tilesets/<pack-name>/LICENSE` |
| Tile size is 16, 32, or 64 on each axis | PNG header inspection via `file` or Python |
| PROVENANCE.md updated | `grep` for pack name in PROVENANCE.md |
| Godot headless validation | `godot4 --headless --path . --quit` exits 0 |

---

## 7. Blocker Handling

If no CC0 tileset is found after exhaustive Kenney + OpenGameArt search:

1. **Blocker:** Surface to team leader via `ticket_lookup` blocker return
2. **Escalation:** Mark ticket as `blocked` with specific reason
3. **Fallback option:** Use CC-BY tileset with full attribution (per canonical brief — credits scene handles this)
4. **Alternative:** Use Kenney Top-down Shooter's built-in floor tiles (already downloaded) as a fallback floor layer

---

## 8. Search Execution Checklist

- [ ] Search Kenney.nl for: Dungeon Pack, Medieval Dungeon, Tiny Dungeon, RPG Pack
- [ ] Check Top-down Shooter pack for floor/wall tiles (already downloaded, may cover needs)
- [ ] If Kenney insufficient: search OpenGameArt.org for `dungeon tileset cc0 top-down`
- [ ] Verify license on chosen pack (CC0 preferred, CC-BY acceptable)
- [ ] Confirm tile size (target 64x64, accept 32x32)
- [ ] Download and extract to `assets/sprites/tilesets/<pack-name>/`
- [ ] Extract/copy tile PNGs to `assets/sprites/tilesets/<pack-name>/PNG/`
- [ ] Copy LICENSE file to same directory
- [ ] Update `assets/PROVENANCE.md` with full entry
- [ ] Run Godot headless validation: `godot4 --headless --path . --quit`
- [ ] Report findings to team leader for plan review stage

---

## 9. Relationship to Other Tickets

| Ticket | Relationship |
|--------|-------------|
| SETUP-001 | Dependency (must complete first) — main.tscn TileMapLayer exists |
| ASSET-001 | Player sprites reference — tiles must visually complement ~36–57px characters |
| ASSET-002 | Horse sprites reference — tiles must frame 48×64 to 64×85 horses |
| CORE-003 | Wave spawner will populate arena — tiles must be placed before wave work |
| UI-003 | Credits scene will reference PROVENANCE.md — must be updated before credits work |

---

*Planning artifact created for ASSET-003. Next step: plan review → approval → implementation.*

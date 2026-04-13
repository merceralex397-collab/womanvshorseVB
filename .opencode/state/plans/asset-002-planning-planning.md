# Planning Artifact: ASSET-002 — Source Enemy Horse Sprites (CC0)

## Ticket Summary
- **ID:** ASSET-002
- **Title:** Source enemy horse sprites (CC0)
- **Wave:** 1
- **Lane:** asset-sourcing
- **Stage:** planning
- **Status:** todo
- **Depends On:** SETUP-001

## Acceptance Criteria
1. Horse enemy sprite sheet exists in assets/sprites/ with at least idle and walk frames
2. License verified as CC0 (or CC-BY with attribution noted)
3. assets/PROVENANCE.md has entry for the sourced sprite
4. Visual style is compatible with player character sprites (Kenney Top-down Shooter style from ASSET-001)

---

## 1. Search Strategy for CC0 Horse/Mount Sprites

### Primary Source: Kenney.nl
Kenney.nl is the preferred source per the canonical brief. However, the **Kenney Top-down Shooter pack does NOT contain horse sprites** — it contains zombie, soldier, survivor, robot, and hitman characters.

**Available Kenney animal assets (all CC0):**

| Pack | URL | Pixel Size | Notes |
|------|-----|------------|-------|
| Animal Pack | https://kenney.nl/assets/animal-pack | 80× | 10 animals, 8 styles each |
| Animal Pack Redux | https://kenney.nl/assets/animal-pack-redux | 248× | 30 animals, 8 styles each |
| Top-down Shooter | https://kenney.nl/assets/top-down-shooter | 64× | NO horses, CC0 already used for player |

**Horse search result:** The Kenney Animal Pack/Redux previews show various animals but the 80× scale differs from the 64× Kenney Top-down Shooter characters. Horses are NOT explicitly confirmed in these packs.

### Secondary Source: OpenGameArt.org
**LPC Horses** (Liberated Pixel Cup):
- URL: https://opengameart.org/content/lpc-horses
- Author: bluecarrot16
- License: **CC-BY 3.0 / GPL 3.0 / GPL 2.0 / OGA-BY 3.0** — **NOT CC0**
- Orientation: **Side-view only**, not top-down
- Status: **NOT SUITABLE** — wrong perspective for top-down game

**LPC Horse Extended:**
- URL: https://opengameart.org/content/lpc-horse-extended
- Author: BenCreating
- License: **CC-BY 3.0** — **NOT CC0**
- Orientation: **Side-view**, walk/gallop animations in 4 directions
- Status: **NOT SUITABLE** — wrong perspective

### Key Finding
**The Kenney Top-down Shooter pack has no horse sprites.** The LPC horses on OpenGameArt are side-view, not top-down, and are CC-BY not CC0.

### Fallback Search Results
- Kenney Game Assets All-in-1 bundle may contain additional top-down packs
- "Animated top down creatures" collection on OpenGameArt includes LPC creatures with top-down views (golem, imp, goblin, wolf, chicken, etc.) but the horse rework in that collection is still side-view

---

## 2. License Verification Steps

1. **For Kenney assets:** Confirm CC0 at source page (kenney.nl lists license on each asset page)
2. **For OpenGameArt assets:** Check license badges on art page — CC-BY, GPL, OGA-BY are NOT CC0
3. **If CC-BY is the only option:** Record author, source URL, license type, and date_acquired in PROVENANCE.md; add to credits scene per acceptance criteria
4. **CC0 verification:** No attribution required legally, but courtesy attribution still recommended in PROVENANCE.md

---

## 3. Download and Placement Procedure

### If Kenney Animal Pack contains horses:
```bash
# Create directory
mkdir -p assets/sprites/kenney-animal-pack/

# Download Kenney Animal Pack
wget -O /tmp/kenney_animal-pack.zip "https://kenney.nl/media/pages/assets/animal-pack/f6c9bf503d-1677669996/kenney_animal-pack.zip"

# Extract
unzip -o /tmp/kenney_animal-pack.zip -d assets/sprites/kenney-animal-pack/

# List contents
ls -la assets/sprites/kenney-animal-pack/
```

### Placement structure:
```
assets/sprites/
├── kenney-topdown-shooter/   # from ASSET-001 (player sprites)
├── kenney-animal-pack/       # horse sprites if found
└── PROVENANCE.md             # updated with new entry
```

### Visual compatibility check against Kenney Top-down Shooter:
- Player sprites (womanGreen): 64×64 PNG with transparency, top-down perspective
- Kenney Animal Pack: 80×80 PNG (different scale)
- **Acceptance:** If animal pack is used, scale/proportions must be acceptable for the game aesthetic; sprite style (pixel density, color palette) should match Kenney shooter

---

## 4. PROVENANCE.md Update Procedure

### Add entry to assets/PROVENANCE.md:

| asset_path | source_url | license | author | date_acquired |
|---|---|---|---|---|
| sprites/kenney-animal-pack/* | https://kenney.nl/assets/animal-pack | CC0 | Kenney Vleugels (Kenney.nl) | 2026-04-10 |

### If CC-BY horse is the only option:
| asset_path | source_url | license | author | date_acquired |
|---|---|---|---|---|
| sprites/lpc-horses/* | https://opengameart.org/content/lpc-horses | CC-BY 3.0 | bluecarrot16 | 2026-04-10 |

---

## 5. Visual Compatibility Check

### Kenney Top-down Shooter Style Reference (from ASSET-001):
- **Player (womanGreen):** 64×64, top-down perspective, pixel art with transparency
- **Color palette:** Earth tones, green tones (womanGreen), military-style
- **Style:** Clean pixel art, 4-frame animation cycles

### Horse Sprite Requirements:
- Top-down perspective (viewed from above)
- At minimum: idle (stand) and walk frames
- Pixel art style compatible with 64×64 Kenney characters
- PNG with transparency

### If Scale Mismatch (80× vs 64×):
- Godot's `AnimatedSprite2D` can handle different sprite sizes
- Enemy sprites do NOT need to be identical scale to player
- Visual consistency (color palette, pixel density) is more important than exact pixel count

---

## 6. Godot Integration Notes

### For horse_base.tscn (future CORE-002):
```gdscript
# horse_base.gd will reference:
$AnimatedSprite2D.sprite_frames = load("res://assets/sprites/kenney-animal-pack/horse_stand.tres")
# or if using a spritesheet:
$AnimatedSprite2D.frame = 0
```

### Sprite Loading Strategy:
1. Place horse PNG files in `assets/sprites/horse-enemy/`
2. Create `HorseFrames` resource in Godot or use spritesheet
3. Reference from `horse_base.gd` when implementing CORE-002

### AnimatedSprite2D Setup:
- Required animations: "idle" (or "stand"), "walk"
- Frame rate: 6-8 FPS typical for pixel art
- `animation_fps` property controls playback speed

---

## 7. Implementation Plan

### Step 1: Download Kenney Animal Pack
- Fetch https://kenney.nl/media/pages/assets/animal-pack/f6c9bf503d-1677669996/kenney_animal-pack.zip
- Extract to `assets/sprites/kenney-animal-pack/`
- Inspect contents for horse sprites

### Step 2: If No Horse in Kenney Pack — Fallback Search
- Search OpenGameArt for "top down horse sprite CC0"
- If only CC-BY found, document that CC-BY attribution is required
- If no suitable top-down horse found, flag as blocker and escalate

### Step 3: License Verification
- Read license from downloaded asset README/licensing file
- Confirm CC0 or document CC-BY requirements

### Step 4: Visual Compatibility Assessment
- Compare downloaded horse sprite style with existing Kenney Top-down Shooter sprites
- Check: perspective (top-down vs side-view), pixel density, color palette
- Document findings in implementation artifact

### Step 5: PROVENANCE.md Update
- Add new row to `assets/PROVENANCE.md`
- Include: asset_path, source_url, license, author, date_acquired

### Step 6: Godot Validation
- Run `godot4 --headless --path . --quit` to verify no scene errors
- Confirm sprite files load correctly

---

## 8. Decision Points / Blockers

| Scenario | Action |
|----------|--------|
| Kenney Animal Pack has top-down horse sprite (CC0) | Proceed with download and integration |
| Kenney Animal Pack has NO horse sprite | Search OpenGameArt more broadly; accept CC-BY with attribution |
| No top-down horse sprite found (CC0 or CC-BY) | **BLOCKER** — escalate to team lead |
| Horse sprite found but wrong perspective (side-view) | **BLOCKER** — wrong orientation for top-down game |
| Horse sprite found but incompatible style | Document issue; may proceed with tinted/recolored variant |

---

## 9. Dependencies and Downstream Tickets

- **CORE-002** (Create enemy horse base class) depends on ASSET-002 completing
- Horse sprites from this ticket will be referenced in `horse_base.gd` via `HorseFrames` resource
- UI-003 (Credits scene) depends on all ASSET tickets including this one for CC-BY attributions

---

## 10. Verification Checklist

Before marking implementation complete:

- [ ] Horse sprite file(s) exist in `assets/sprites/`
- [ ] License is CC0 OR CC-BY with attribution documented in PROVENANCE.md
- [ ] PROVENANCE.md updated with new entry
- [ ] Visual style verified compatible with Kenney Top-down Shooter player sprites
- [ ] `godot4 --headless --path . --quit` exits with code 0
- [ ] Downstream ticket CORE-002 is unblocked

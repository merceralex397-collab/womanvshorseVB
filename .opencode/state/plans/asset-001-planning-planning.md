# ASSET-001 Planning Artifact

## Ticket
- **ID:** ASSET-001
- **Title:** Source character sprites from Kenney/OpenGameArt (CC0)
- **Wave:** 1
- **Lane:** asset-sourcing
- **Stage:** planning

## Objective
Find and download a CC0 (or CC-BY) top-down character sprite sheet for the player warrior woman with walk, idle, attack, and hurt animation frames.

## Search Strategy

### Primary: Kenney.nl (CC0)
1. Search for "Kenney top-down character sprite CC0"
2. Check specific Kenney packs:
   - https://kenney.nl/assets/top-down-shooter (contains character sprites)
   - https://kenney.nl/assets/rpg-pack
   - https://kenney.nl/assets?q=character for more
3. Kenney assets are predominantly CC0 (public domain)

### Secondary: OpenGameArt.org (CC0/CC-BY)
1. Search for "top down character sprite CC0"
2. Verify license on each promising asset page
3. Prioritize CC0 over CC-BY

### Tertiary: CC-BY if needed
1. If no suitable CC0 asset found, accept CC-BY with attribution noted in PROVENANCE.md

## Acceptance Criteria
1. Player character sprite sheet exists in `assets/sprites/` with walk, idle, attack, and hurt frames
2. License verified as CC0 (or CC-BY with attribution noted)
3. `assets/PROVENANCE.md` has entry for the sourced sprite with `source_url`, `license`, `author`, `date`
4. Sprite format is PNG with transparency

## Implementation Steps

### Phase 1: Web Search
1. Run `web_search` for "Kenney top-down character sprite CC0"
2. Run `web_search` for "OpenGameArt top down character sprite CC0"
3. Analyze results for suitable packs with multiple animation types

### Phase 2: License Verification
1. For promising Kenney packs: fetch the page and confirm CC0 license
2. For promising OpenGameArt assets: fetch page and verify license badge

### Phase 3: Asset Download
1. Download the sprite sheet PNG from the verified source
2. Place in `assets/sprites/` directory
3. Ensure file has transparency (PNG format)

### Phase 4: PROVENANCE.md Update
1. Read existing `assets/PROVENANCE.md`
2. Add new entry with:
   - filename
   - source_url
   - license (CC0 or CC-BY)
   - author/creator
   - date downloaded
   - animation types present

### Phase 5: Verification
1. Confirm PNG file exists in `assets/sprites/`
2. Confirm PROVENANCE.md entry exists
3. Run Godot headless validation: `godot4 --headless --path . --quit`

## Expected Outcome
- A top-down character sprite sheet (warrior woman style or gender-neutral) in `assets/sprites/`
- Updated `assets/PROVENANCE.md` with full attribution
- Godot project still valid after asset integration

## Fallback Plan
If no suitable CC0 character sprite found:
1. Search for CC-BY character sprites
2. Note attribution requirement in PROVENANCE.md
3. Proceed with CC-BY asset if quality is sufficient

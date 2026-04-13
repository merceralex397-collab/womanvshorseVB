# Planning: ASSET-004 — Source UI Sprites and Fonts

## Ticket Summary

- **ID**: ASSET-004
- **Title**: Source UI sprites and fonts
- **Wave**: 1
- **Lane**: asset-sourcing
- **Stage**: planning
- **Depends on**: SETUP-001 (done, trusted)
- **Follow-up ticket**: UI-001, UI-002, UI-003, CORE-004

## Goal

Source free/open UI elements needed for the game HUD, title screen, game over screen, and credits scene:
- Button sprites, health bar graphics, panel backgrounds (CC0)
- A pixel-art font for game UI (OFL from Google Fonts)

## Search Strategy

### UI Sprites

#### Primary: Kenney.nl UI Pack
- URL: https://kenney.nl/assets/ui-pack
- License: CC0 — no attribution required
- Contents to source: button sprites (default, pressed, hover states), panel/window backgrounds, health bar segments, progress bar elements
- Action: Download the PNG sprite sheet from Kenney.nl. Extract individual UI elements as PNG files with transparency.

#### Fallback: OpenGameArt.org
- Search terms: `game ui buttons`, `pixel art ui elements`, `game interface sprites`
- Filter: CC0 or CC-BY only
- If Kenney UI Pack is unavailable, find equivalent UI pack on OpenGameArt (e.g., "Game UI Pack" by independent artists)

#### Visual Style Constraint
- Top-down action game UI — clean, readable at small sizes
- Pixel-art style matching the Kenney Top-down Shooter aesthetic already sourced in ASSET-001
- 16x16 to 64x64 tile sizes preferred for button elements

### Pixel Fonts

#### Primary: Google Fonts (OFL — free for game use)
Priority order:
1. **Press Start 2P** — classic 8-bit pixel font, widely recognized
2. **VT323** — terminal-style monospace pixel font
3. **Silkscreen** — clean pixel font for small sizes
4. **Pixelify Sans** — modern pixel font with good readability

- All listed fonts are under SIL Open Font License (OFL) 1.1
- OFL permits use in commercial and non-commercial games without attribution in the font file itself (attribution still required in credits per OFL terms)
- Action: Download TTF from Google Fonts, place in `assets/fonts/`

#### Fallback: Kenney.nl Fonts
- Kenney.nl hosts a `kenney.nl-fonts` pack (CC0) with pixel-style fonts
- URL: https://kenney.nl/assets/kenney-fonts
- Action: If Google Fonts access is restricted, fall back to Kenney CC0 fonts

## Download and Organization Procedure

### Directory Structure

```
assets/
  sprites/
    ui/                        # new directory for UI sprites
      button_default.png
      button_pressed.png
      button_hover.png
      panel_background.png
      health_bar_left.png       # health bar end cap
      health_bar_middle.png     # health bar fill segment
      health_bar_right.png      # health bar end cap
      score_panel.png
  fonts/
    PressStart2P-Regular.ttf    # or chosen alternative
    # only one font needed for MVP
```

### Download Steps

1. Create `assets/sprites/ui/` directory
2. Download Kenney UI Pack PNG from https://kenney.nl/assets/ui-pack
3. Extract individual button and panel sprites (use image editing tools or command-line `convert`/`crop`)
4. Verify extracted sprites are PNG with transparency (RGBA)
5. Download Press Start 2P TTF from https://fonts.google.com/specimen/Press+Start+2P
6. Place downloaded font TTF in `assets/fonts/`

### Naming Convention
- Use lowercase with underscores: `button_default.png`, `health_bar_left.png`
- One font file is sufficient for MVP: `PressStart2P-Regular.ttf`

## License Verification Steps

### UI Sprites (Kenney CC0)
1. Visit https://kenney.nl/assets/ui-pack
2. Confirm license field reads "CC0 1.0 Universal"
3. CC0 requires no attribution — still record in PROVENANCE.md as courtesy
4. For any OpenGameArt fallback: verify license tag before downloading

### Fonts (Google Fonts OFL)
1. Visit Google Fonts page for chosen font (e.g., https://fonts.google.com/specimen/Press+Start+2P)
2. Confirm "License: SIL Open Font License 1.1"
3. OFL does not require embedding attribution in the game UI — only in credits scene
4. Record full font name, author, OFL URL, and download date in PROVENANCE.md

### Verification Commands
```bash
# Verify PNG headers (should show RGBA for transparent sprites)
file assets/sprites/ui/*.png

# Verify font file
file assets/fonts/*.ttf

# Godot will auto-import TTF/OTF placed in project — verify with:
godot4 --headless --path . --quit 2>&1
```

## PROVENANCE.md Update Procedure

### Template Entry for UI Sprites (CC0)
```markdown
## assets/sprites/ui/

**Source**: Kenney.nl UI Pack
**URL**: https://kenney.nl/assets/ui-pack
**License**: CC0 1.0 Universal
**Download Date**: [date]
**Author**: Kenney (kenney.nl)
**Files**: button_default.png, button_pressed.png, button_hover.png, panel_background.png, health_bar_left.png, health_bar_middle.png, health_bar_right.png, score_panel.png

*Note: CC0 requires no attribution, but credit is listed here as a courtesy.*
```

### Template Entry for Font (OFL)
```markdown
## assets/fonts/PressStart2P-Regular.ttf

**Source**: Google Fonts
**URL**: https://fonts.google.com/specimen/Press+Start+2P
**License**: SIL Open Font License 1.1
**OFL URL**: https://scripts.sil.org/OFL
**Download Date**: [date]
**Author**: CodeMan38 (press_start_2p)
**Font Family**: Press Start 2P

*Used under SIL Open Font License 1.1. Attribution required in credits scene per OFL terms.*
```

### Update Procedure
1. Read current `assets/PROVENANCE.md`
2. Append new entries under the appropriate section
3. Preserve existing entries (ASSET-001, ASSET-002, ASSET-003 provenance)
4. Keep format consistent with existing PROVENANCE.md entries

## Godot Integration

### UI Sprite Integration (CORE-004 HUD)

The sourced UI sprites will be used in:
- `scenes/ui/hud.tscn` — health bar, wave display, score display
- `scenes/ui/title_screen.tscn` — start/credits buttons
- `scenes/ui/game_over.tscn` — retry/menu buttons
- `scenes/ui/credits.tscn` — back button

**Godot Integration Steps**:
1. Place PNG sprites in `assets/sprites/ui/` — Godot auto-imports
2. Reference sprites in `TextureRect` or `Sprite2D` nodes within UI scenes
3. Health bar: use `NinePatchRect` with panel background sprite for scalable panels
4. Buttons: use `TextureButton` node type for state-based button sprites (default/pressed/hover)
5. Signal connections: buttons connect to scene transition methods (e.g., `on_start_pressed` → `get_tree().change_scene_to_file(...)`)

### Font Integration

**Godot Label Nodes**:
1. Drop TTF into `assets/fonts/` — Godot auto-creates a `FontFile` resource
2. In any `Label` or `RichTextLabel` node, assign the font in the inspector under "Custom Fonts"
3. For pixel fonts in a low-resolution game, set font size to 1x or 2x (pixel fonts render best at integer multiples)

**CORE-004 HUD** will use the font for:
- Wave number display: `Label` with Press Start 2P at small size
- Score display: `Label` with Press Start 2P
- Health label: optional

**UI-001/UI-002/UI-003** will use the font for:
- Title text
- Button labels
- Credits text

## Decision Blockers and Escalation Paths

### Blocker 1: Kenney.nl UI Pack Unavailable
**Trigger**: Download fails or page returns 404
**Escalation**:
1. Try cached/mirrored version of Kenney assets
2. Search OpenGameArt for "game ui pack" CC0 — accept CC-BY if CC0 unavailable (CC-BY requires credits scene entry per canonical brief)
3. If no suitable UI sprites found: record blocker, stop ASSET-004, notify team leader
4. Decision: proceed with CC-BY attribution or defer UI sprites to later ticket

### Blocker 2: Google Fonts Unreachable
**Trigger**: Google Fonts download fails or access restricted
**Escalation**:
1. Try Kenney.nl Fonts (CC0 fallback): https://kenney.nl/assets/kenney-fonts
2. Search for alternative OFL pixel font on OpenGameArt or direct author sites
3. If no font found: record blocker, notify team leader
4. Decision: defer font sourcing or use Godot's built-in system font as last resort

### Blocker 3: No CC0/CC-BY UI Sprites Found
**Trigger**: Both Kenney and OpenGameArt searches return only proprietary/commercial assets
**Escalation**:
1. Document what was searched and why it failed
2. Flag as blocker in ASSET-004 plan artifact
3. Notify team leader — this is a scope change requiring decision

### Blocker 4: Godot Headless Validation Fails After Import
**Trigger**: `godot4 --headless --path . --quit` exits non-zero after sprite/font placement
**Escalation**:
1. Check import errors in Godot output
2. Verify PNG files are valid (not corrupted downloads)
3. Re-export PNGs if needed (some sprite sheets may need individual extraction)
4. If persistent: record as blocker, notify team leader

## Acceptance Criteria Checklist

| # | Criterion | Verification |
|---|-----------|--------------|
| 1 | UI sprites exist in `assets/sprites/ui/` (buttons, health bar, panel backgrounds) | `ls assets/sprites/ui/` returns PNG files |
| 2 | At least one pixel font TTF/OTF exists in `assets/fonts/` | `ls assets/fonts/*.ttf` or `*.otf` returns file |
| 3 | All licenses verified (CC0 for sprites, OFL for fonts) | License URLs recorded in PROVENANCE.md |
| 4 | `assets/PROVENANCE.md` has entries for all UI assets and fonts | Read PROVENANCE.md — entries exist with source URL and license |

## File Manifest (to be created by implementation)

```
assets/sprites/ui/
  button_default.png       # from Kenney UI Pack
  button_pressed.png
  button_hover.png
  panel_background.png
  health_bar_left.png
  health_bar_middle.png
  health_bar_right.png
  score_panel.png

assets/fonts/
  PressStart2P-Regular.ttf  # from Google Fonts, OFL

assets/PROVENANCE.md       # updated with UI sprite and font entries
```

## Next Stage

Once plan is approved:
- **Stage**: plan_review → implementation
- **Active ticket**: `ticket_update { "ticket_id": "ASSET-004", "stage": "implementation", "activate": true }` (team leader action)
- **Implementation steps**: Download UI Pack, extract sprites, download font, update PROVENANCE.md, verify Godot headless validation passes

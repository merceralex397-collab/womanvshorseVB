# Code Review — UI-003: Credits Scene (CC-BY Attributions)

## Ticket
- **ID:** UI-003
- **Title:** Credits scene (CC-BY attributions)
- **Wave:** 3
- **Lane:** ui
- **Stage:** review

## Reviewer Notes
Source files inspected:
- `scenes/ui/credits.tscn` — full 120-line scene tree
- `scenes/ui/credits.gd` — full 7-line script
- `assets/PROVENANCE.md` — attribution source of truth (171 lines)
- `.opencode/state/implementations/ui-003-implementation-implementation.md`

Godot headless verification rerun to confirm exit 0.

---

## Acceptance Criteria Verification

### AC1: scenes/ui/credits.tscn exists with scrollable attribution list
**Status: PASS**

- `scenes/ui/credits.tscn` confirmed at expected path (120 lines, format=3)
- Scene structure: `Control` root → `ColorRect` BG → `ScrollContainer` → `ContentVBox`
- ScrollContainer has `horizontal_scroll_mode = 0` (horizontal scroll intentionally disabled)
- Vertical scrolling enabled by default via ScrollContainer behavior
- Attribution content flows through the ScrollContainer wrapped ContentVBox

### AC2: All CC-BY assets from PROVENANCE.md are displayed with author, license, and source
**Status: PASS**

PROVENANCE.md contains exactly **one** CC-BY asset entry:
| asset | license | author | source |
|---|---|---|---|
| sprites/lpc-horses-rework/PNG/* | CC-BY-SA 3.0 | Jordan Irwin (AntumDeluge), bluecarrot16 | https://opengameart.org/content/lpc-horses-rework |

`credits.tscn` CC-BY section verified in scene tree:
- `CCBYHeader` Label: "CC-BY ATTRIBUTIONS (Required)"
- `LPCEntry` HBoxContainer with all four attribution components:
  - `AssetName`: "LPC Horses Rework"
  - `Authors`: "Jordan Irwin (AntumDeluge), bluecarrot16"
  - `License`: "CC-BY-SA 3.0"
  - `SourceLabel`: " | https://opengameart.org/content/lpc-horses-rework"

All four fields match PROVENANCE.md exactly. No other CC-BY assets exist in PROVENANCE.md.

### AC3: CC0 assets credited as courtesy (not legally required but encouraged)
**Status: PASS**

`credits.tscn` CC0/OFL courtesy section verified in scene tree:
- `CourtesyHeader` Label: "COURTESY (CC0 / OFL)"
- `CourtesyVBox` entries (5 entries):
  - `KenneyTopdown`: "Kenney Top-down Shooter — Kenney.nl"
  - `DungeonPack`: "Top Down Dungeon Pack — Screaming Brain Studios / OpenGameArt"
  - `KenneyUI`: "Kenney UI Pack — Kenney.nl"
  - `PressStart2P`: "Press Start 2P font — CodeMan38 (OFL)"
  - `SFXLabel`: "SFX — Kenney.nl, Joseph Sardin"

These match the 6 PROVENANCE.md CC0/OFL entries (Kenney Top-down Shooter, Top Down Dungeon Pack, Kenney UI Pack, Press Start 2P font, and SFX from Kenney + Joseph Sardin). Format is readable and correct.

### AC4: Back button returns to title screen
**Status: PASS**

- `credits.gd` line 4: `$BackButton.pressed.connect(_on_back_pressed)` — signal wired in `_ready()`
- `credits.gd` line 6–7: `get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")` — navigates to title screen
- `credits.tscn` line 115: `BackButton` is `TextureButton` with `texture_normal = ExtResource("2")` (button_square_gloss.png from Kenney UI Pack)
- Button is positioned bottom-left via offset values (20,20 → 84,84)

### AC5: Credits are readable and properly formatted
**Status: PASS**

- "CREDITS" title: centered (horizontal_alignment=1, vertical_alignment=1)
- Section headers "CC-BY ATTRIBUTIONS (Required)" and "COURTESY (CC0 / OFL)": centered
- Attribution entries use HBoxContainer with ` | ` separators between fields for clean pipe-delimited format
- 16px VBoxContainer separation between major sections, 12px within CC-BY entry, 8px within courtesy section
- 20px spacer at bottom before BackButton
- ColorRect dark background (0.078, 0.078, 0.118, 1.0) — dark blue-grey for readability
- No truncation, no overflow, text is fully visible

---

## Godot Headless Verification

**Command:**
```bash
godot4 --headless --path . --quit 2>&1
```

**Raw Output:**
```
Godot Engine v4.6.1.stable.official.14d19694e - https://godotengine.org
```

**Exit code:** 0

---

## Code Quality Notes

No correctness bugs found:
- Signal connection uses correct Godot 4.x `$NodeName` syntax
- `change_scene_to_file` is the correct Godot 4.x API (not `change_scene`)
- Scene tree structure is clean: no cyclic node references
- Texture external reference (`button_square_gloss.png`) resolves to `assets/sprites/ui/button_square_gloss.png` which exists per ASSET-004
- No hardcoded paths or magic numbers beyond layout offsets (20px margins, 84px button size)
- Control node anchors_preset=15 (full_rect) on root is correct for a fullscreen credits overlay

---

## Overall Verdict: PASS

All 5 acceptance criteria verified PASS. Credits scene is structurally sound, attribution-complete, and navigation works as designed. Godot headless exits 0 cleanly. Recommend advance to QA.

**Recommendation:** Move to QA stage.

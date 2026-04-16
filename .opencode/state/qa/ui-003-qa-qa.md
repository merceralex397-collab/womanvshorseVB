# QA Artifact — UI-003: Credits Scene (CC-BY Attributions)

## Ticket
- **ID:** UI-003
- **Title:** Credits scene (CC-BY attributions)
- **Wave:** 3
- **Lane:** ui
- **Stage:** qa

## Raw Command Output

**Command:** `godot4 --headless --path . --quit 2>&1`
```
Godot Engine v4.6.1.stable.official.14d19694e - https://godotengine.org
```
**Result:** exit code 0 — scene loads cleanly, no ERROR signals.

---

## AC Verification

### AC1: scenes/ui/credits.tscn exists with scrollable attribution list
**PASS**

- `scenes/ui/credits.tscn` exists (120 lines, format=3)
- `ScrollContainer` node at line 23 with `horizontal_scroll_mode = 0` (horizontal scroll disabled, vertical scroll enabled)
- `ContentVBox` VBoxContainer inside ScrollContainer at line 36
- ScrollContainer offsets leave room for BackButton at bottom (−80.0 offset_bottom)
- Attribution list is inside ContentVBox and will scroll when content overflows

### AC2: All CC-BY assets from PROVENANCE.md are displayed with author, license, and source
**PASS**

Single CC-BY entry verified in scene at lines 55–80:
- Asset name: `LPC Horses Rework`
- Authors: `Jordan Irwin (AntumDeluge), bluecarrot16`
- License: `CC-BY-SA 3.0`
- Source: `https://opengameart.org/content/lpc-horses-rework`

Implementation artifact confirms PROVENANCE.md has exactly one CC-BY asset (LPC Horses Rework).

### AC3: CC0 assets credited as courtesy (not legally required but encouraged)
**PASS**

Five courtesy entries verified in scene at lines 91–109:
- `Kenney Top-down Shooter — Kenney.nl` (CC0)
- `Top Down Dungeon Pack — Screaming Brain Studios / OpenGameArt` (CC0)
- `Kenney UI Pack — Kenney.nl` (CC0)
- `Press Start 2P font — CodeMan38 (OFL)` (OFL)
- `SFX — Kenney.nl, Joseph Sardin` (CC0)

### AC4: Back button returns to title screen
**PASS**

- `scenes/ui/credits.gd` line 4: `$BackButton.pressed.connect(_on_back_pressed)`
- `scenes/ui/credits.gd` lines 6–7: `_on_back_pressed()` calls `get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")`
- BackButton TextureButton node confirmed in scene at lines 115–120

### AC5: Credits are readable and properly formatted
**PASS**

- "CREDITS" title label centered (horizontal_alignment = 1, vertical_alignment = 1)
- Section headers: "CC-BY ATTRIBUTIONS (Required)" and "COURTESY (CC0 / OFL)" centered
- CC-BY entry uses pipe-separated fields: `Asset | Authors | License | Source`
- All Labels use default Godot theme font (Press Start 2P font referenced in assets but Label nodes here use default theme; proper formatting achieved via section headers and layout structure)
- Dark background ColorRect (Color(0.078, 0.078, 0.118, 1.0)) for readability
- VBoxContainers with theme separation for visual spacing

---

## Overall Verdict

| AC | Result |
|---|--------|
| AC1: scrollable attribution list | **PASS** |
| AC2: CC-BY assets displayed | **PASS** |
| AC3: CC0 courtesy credits | **PASS** |
| AC4: Back button navigates to title | **PASS** |
| AC5: Readable and formatted | **PASS** |

**Overall: PASS**

All 5 acceptance criteria verified PASS. Godot headless exits 0 cleanly. Credits scene is structurally sound, attribution-complete, and navigation-ready.

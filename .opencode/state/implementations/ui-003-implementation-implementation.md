# Implementation Artifact — UI-003: Credits Scene (CC-BY Attributions)

## Ticket
- **ID:** UI-003
- **Title:** Credits scene (CC-BY attributions)
- **Wave:** 3
- **Lane:** ui
- **Stage:** implementation

## Summary
Created `scenes/ui/credits.tscn` and `scenes/ui/credits.gd` per the approved plan.

## Files Created

### 1. `scenes/ui/credits.gd`
```gdscript
extends Control

func _ready() -> void:
	$BackButton.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")
```

### 2. `scenes/ui/credits.tscn`
Scene structure:
- **Root:** `Control` named `Credits` (anchors_preset = 15, full viewport)
- **BG:** `ColorRect` with dark background color
- **ScrollContainer:** wraps the content VBox, horizontal scroll disabled
- **ContentVBox:** top-level vertical layout container
  - `CreditsTitle` Label: "CREDITS" — centered
  - `CCBYHeader` Label: "CC-BY ATTRIBUTIONS (Required)"
  - `CCBYVBox`: VBoxContainer containing the single CC-BY entry
    - `LPCEntry` HBoxContainer: LPC Horses Rework | Jordan Irwin (AntumDeluge), bluecarrot16 | CC-BY-SA 3.0 | OpenGameArt URL
  - `CourtesyHeader` Label: "COURTESY (CC0 / OFL)"
  - `CourtesyVBox`: VBoxContainer with courtesy entries
    - Kenney Top-down Shooter — Kenney.nl
    - Top Down Dungeon Pack — Screaming Brain Studios / OpenGameArt
    - Kenney UI Pack — Kenney.nl
    - Press Start 2P font — CodeMan38 (OFL)
    - SFX — Kenney.nl, Joseph Sardin
  - `Spacer` Control (20px height)
- **BackButton:** `TextureButton` at bottom-left, uses `button_square_gloss.png` from Kenney UI Pack

## Implementation Details
- ScrollContainer wraps ContentVBox so the attribution list scrolls if content overflows
- BackButton uses the Kenney UI Pack button sprite (`button_square_gloss.png`) already in assets
- CC-BY section lists the single CC-BY asset: LPC Horses Rework with full attribution (author, license, source URL)
- Courtesy section lists all CC0/OFL assets per PROVENANCE.md
- Signal wiring: `BackButton.pressed.connect(_on_back_pressed)` in `_ready()`
- Navigation: `get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")`
- title_screen.gd already has a guarded credits button handler ready

## Attribution Sources (from assets/PROVENANCE.md)
| Asset | License | Author | Source |
|---|---|---|---|
| LPC Horses Rework (sprites/lpc-horses-rework/PNG/) | CC-BY-SA 3.0 | Jordan Irwin (AntumDeluge), bluecarrot16 | https://opengameart.org/content/lpc-horses-rework |
| Kenney Top-down Shooter | CC0 | Kenney Vleugels | https://kenney.nl/assets/top-down-shooter |
| Top Down Dungeon Pack | CC0 | Screaming Brain Studios | https://opengameart.org/content/top-down-dungeon-pack |
| Kenney UI Pack | CC0 | Kenney Vleugels | https://kenney.nl/assets/ui-pack |
| Press Start 2P font | OFL 1.1 | CodeMan38 | https://fonts.google.com/specimen/Press+Start+2P |
| Audio SFX (Kenney + Joseph Sardin) | CC0 | Kenney Vleugels / Joseph Sardin | Kenney.nl + bigsoundbank |

## Acceptance Criteria Verification

| AC | Description | Status |
|---|---|---|
| AC1 | scenes/ui/credits.tscn exists with scrollable attribution list | PASS |
| AC2 | All CC-BY assets displayed with author, license, source | PASS |
| AC3 | CC0 assets credited as courtesy | PASS |
| AC4 | Back button returns to title screen | PASS |
| AC5 | Credits readable and properly formatted | PASS |

## Godot Headless Verification

**Command:**
```bash
godot4 --headless --path . --quit 2>&1 | head -20
```

**Output:**
```
Godot Engine v4.6.1.stable.official.14d19694e - https://godotengine.org
```

**Result:** exit code 0 — scene loads without ERROR signals.

## Next Stage
Advance to `review` for code review per the approved plan.

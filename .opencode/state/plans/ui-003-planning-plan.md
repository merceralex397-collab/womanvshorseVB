# Planning Artifact — UI-003: Credits Scene (CC-BY Attributions)

## Ticket
- **ID:** UI-003
- **Title:** Credits scene (CC-BY attributions)
- **Wave:** 3
- **Lane:** ui
- **Stage:** planning

## Summary
Create the credits scene (scenes/ui/credits.tscn) that displays all asset attributions. Read from assets/PROVENANCE.md or a structured credits data file. Show asset name, author, license, and source URL for all CC-BY assets. Include a back button to return to title screen.

## Acceptance Criteria with Explicit Verification Steps

### AC1 — scenes/ui/credits.tscn exists with scrollable attribution list
**Verification steps:**
1. Confirm `scenes/ui/credits.tscn` exists in the filesystem
2. Open the scene file and confirm the root node is `Control`
3. Confirm a `ScrollContainer` node exists as a child (or nested structure)
4. Confirm the `ScrollContainer` contains a `VBoxContainer` child that holds attribution entries
5. Confirm the scene loads in the Godot editor without errors

**Implementation approach:**
- Root: `Control` node named `Credits`
- Child structure: `CenterContainer` → `VBoxContainer` → `ScrollContainer` → `VBoxContainer` (the scroll content container)
- The attribution content VBoxContainer inside ScrollContainer will hold grouped entries
- Use `VBoxContainer` for vertical stacking of attribution entries

### AC2 — All CC-BY assets from PROVENANCE.md are displayed with author, license, and source
**Verification steps:**
1. Read `assets/PROVENANCE.md` and identify all CC-BY assets
2. Confirm the credits scene lists the LPC Horses Rework CC-BY assets with: author (Jordan Irwin/AntumDeluge, bluecarrot16), license (CC-BY-SA 3.0), and source (OpenGameArt URL)
3. Confirm each CC-BY entry contains all three fields (author, license, source)
4. Confirm no CC-BY asset from PROVENANCE.md is missing from the credits list

**Implementation approach:**
- CC-BY Section header label: "CC-BY ATTRIBUTIONS (Required)"
- Entry format per asset: HBoxContainer containing:
  - Label for asset name: "LPC Horses Rework"
  - Label for author: "Author: Jordan Irwin (AntumDeluge) / bluecarrot16"
  - Label for license: "License: CC-BY-SA 3.0"
  - Label for source: "Source: https://opengameart.org/"

**Known CC-BY assets from PROVENANCE.md:**
- LPC Horses Rework sprites in `sprites/lpc-horses-rework/PNG/` (CC-BY-SA 3.0, author: Jordan Irwin/AntumDeluge, bluecarrot16)

### AC3 — CC0 assets credited as courtesy (not legally required but encouraged)
**Verification steps:**
1. Confirm a "COURTESY (CC0 / OFL)" section exists in the credits scene
2. Confirm all CC0 assets from PROVENANCE.md are listed in this section:
   - Kenney.nl assets: sprites/kenney-topdown-shooter/, sprites/tilesets/sbs-top-down-dungeon/, sprites/ui/, audio/sfx/
3. Confirm all OFL fonts are credited: PressStart2P-Regular.ttf (CodeMan38)
4. Confirm entries include asset name and source

**Implementation approach:**
- CC0 Courtesy Section header label: "COURTESY (CC0 / OFL)"
- Format: "Asset Name — Source" (no license field needed for courtesy)
- Assets to list courtesy:
  - Kenney Top-down Shooter (sprites/kenney-topdown-shooter/) — Kenney.nl
  - Top Down Dungeon Pack (sprites/tilesets/sbs-top-down-dungeon/) — Screaming Brain Studios via OpenGameArt
  - Kenney UI Pack (sprites/ui/) — Kenney.nl
  - Press Start 2P font (fonts/PressStart2P-Regular.ttf) — CodeMan38 (OFL)
  - Kenney audio SFX (assets/audio/sfx/) — Kenney.nl + Joseph Sardin (via Kenney.nl packs)

### AC4 — Back button returns to title screen
**Verification steps:**
1. Confirm a `TextureButton` named `BackButton` exists in the scene
2. Confirm `credits.gd` script connects the back button's `pressed` signal to `_on_back_pressed`
3. Confirm `_on_back_pressed` calls `get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")`
4. Confirm `title_screen.gd` already has a guarded handler for the credits button that references `res://scenes/ui/credits.tscn` with `ResourceLoader.exists` guard

**Implementation approach:**
- TextureButton with Kenney UI Pack sprite backing (matching existing UI-001/UI-002 buttons)
- `credits.gd` script:
  ```gdscript
  func _ready():
      $BackButton.pressed.connect(_on_back_pressed)

  func _on_back_pressed():
      get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")
  ```

### AC5 — Credits are readable and properly formatted
**Verification steps:**
1. Confirm `PressStart2P-Regular.ttf` from `assets/fonts/` is used for headings/labels
2. Confirm font sizes are appropriate: CREDITS title large, section headers medium, attribution text smaller but readable
3. Confirm labels use contrasting colors against the background
4. Confirm spacing between attribution entries is consistent (VBoxContainer separation)
5. Confirm Godot headless validation exits 0

**Implementation approach:**
- Title: "CREDITS" — Press Start 2P, large font, centered
- Section headers: Press Start 2P, medium size, left-aligned within the VBoxContainer
- Attribution entries: DynamicFont with Press Start 2P at smaller size OR plain Label nodes
- Background: dark ColorRect or transparent (inherits from parent)
- Entry spacing: VBoxContainer `constant` separation of ~10px between entries

## Scene Structure

```
Credits (Control)
└── CenterContainer
    └── VBoxContainer
        ├── Label: "CREDITS" (Press Start 2P, large)
        ├── Label: "CC-BY ATTRIBUTIONS (Required)"
        ├── VBoxContainer (CC-BY entries)
        │   ├── HBoxContainer: LPC Horses Rework | Jordan Irwin | CC-BY-SA 3.0 | OpenGameArt URL
        │   └── (expand for future CC-BY assets)
        ├── Label: "COURTESY (CC0 / OFL)"
        ├── VBoxContainer (courtesy entries)
        │   ├── Label: "Kenney Top-down Shooter — Kenney.nl"
        │   ├── Label: "Top Down Dungeon Pack — Screaming Brain Studios / OpenGameArt"
        │   ├── Label: "Kenney UI Pack — Kenney.nl"
        │   ├── Label: "Press Start 2P font — CodeMan38 (OFL)"
        │   ├── Label: "SFX — Kenney.nl, Joseph Sardin"
        │   └── (expand for future assets)
        └── TextureButton: "BackButton"
```

## Godot 4.6 Technical Notes
- Root node type: `Control` (not `CanvasLayer` — this is a UI scene, not an overlay)
- Use `@onready` for node references: `@onready var back_button: TextureButton = $BackButton`
- Signal connection via `pressed.connect(_on_back_pressed)` in `_ready`
- TextureButton uses Kenney UI Pack sprites already in `assets/sprites/ui/` (matching UI-001/UI-002 pattern)
- DynamicFont resource for Press Start 2P: create `DynamicFont` object, set `font_data` to the .ttf file, assign to Label node's `add_font_override`

## Dependencies
- `assets/PROVENANCE.md` — source of truth for attributions
- `assets/fonts/PressStart2P-Regular.ttf` — OFL font (ATTRIBUTION REQUIRED)
- `assets/sprites/ui/` — Kenney UI Pack buttons
- `scenes/ui/title_screen.tscn` — target of back button

## Blocker/Escalation Path
- If `assets/PROVENANCE.md` is missing or incomplete, escalate to team lead before implementation
- If `PressStart2P-Regular.ttf` is missing, fallback to a Godot built-in font but note the visual deviation
- If `title_screen.tscn` path changes, update the back button target accordingly

## Pre-Implementation Verification Command
```bash
godot4 --headless --path . --quit 2>&1 | head -20
```
Expect: scene loads without ERROR signals in headless mode.
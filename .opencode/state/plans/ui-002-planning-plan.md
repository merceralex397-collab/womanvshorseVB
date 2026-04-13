# Plan: UI-002 Game Over Screen

## Stage
planning

## Ticket
UI-002: Game over screen

## Summary
Create the game over screen (scenes/ui/game_over.tscn) showing final score, wave reached, retry button, and main menu button. Triggered when player health reaches 0.

## Implementation Approach

### Scene Structure
- **Root:** `Control` node (FULL_RECT anchors)
- **Background:** `ColorRect` (dark semi-transparent overlay, e.g. Color(0,0,0,0.7))
- **CenterContainer** → **VBoxContainer** (centered vertically and horizontally):
  - "GAME OVER" large label (Press Start 2P font, large size)
  - Blank spacer (MarginContainer)
  - "SCORE:" label + dynamic score value label
  - "WAVE:" label + dynamic wave value label
  - Blank spacer
  - Retry `TextureButton` → calls `get_tree().change_scene_to_file("res://scenes/main.tscn")`
  - Menu `TextureButton` → calls `get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")`

### Game State Autoload (pre-existing or new)
- **`scripts/autoloads/game_manager.gd`** (singleton):
  - `score: int` — persisted across scenes
  - `wave: int` — current wave
  - `max_wave: int` — highest wave reached
  - Signal: `game_over_triggered`
- The game over screen reads from `GameManager.score` and `GameManager.max_wave`
- If autoload does not exist yet, create a minimal version that stores values in memory

### Button Styling
- Same `TextureButton` pattern as title_screen (START/CREDITS buttons in UI-001)
- Use `pressed()` signal connected to scene change methods
- Hover/press states from sourced UI sprites (Kenney UI Pack from ASSET-004)

### Transition Logic
- **Retry:** `get_tree().change_scene_to_file("res://scenes/main.tscn")` — starts fresh game
- **Menu:** `get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")` — returns to title

### File Targets
- `scenes/ui/game_over.tscn` — replaces the existing CORE-005 stub
- `scenes/ui/game_over.gd` — script with button handlers and label population
- `scripts/autoloads/game_manager.gd` — game state singleton (create if missing)

### Core-005 Integration Point
- CORE-005 stub has `get_tree().reload_current_scene()` on player death
- Update CORE-005 to call `GameManager.trigger_game_over()` before reload so game_manager records final score/wave
- Game over screen reads from GameManager on `_ready()`

## Acceptance Criteria Verification

| # | Criterion | Verification Step |
|---|-----------|-------------------|
| 1 | scenes/ui/game_over.tscn exists with score label, wave label, retry button, menu button | Inspect scene tree; confirm all 4 elements present |
| 2 | Retry button restarts the main game scene | Inspect game_over.gd; confirm change_scene_to_file("res://scenes/main.tscn") on pressed signal |
| 3 | Menu button returns to title screen | Inspect game_over.gd; confirm change_scene_to_file("res://scenes/ui/title_screen.tscn") on pressed signal |
| 4 | Displays final score and highest wave reached | Inspect labels; confirm they reference GameManager.score and GameManager.max_wave |
| 5 | Uses sourced font and UI sprites | Confirm DynamicFont with PressStart2P-Regular.ttf; confirm TextureButton uses assets/sprites/ui/ sprites |

## Godot Headless Validation
```bash
godot4 --headless --path . --quit
```
Exit code 0 confirms scene loads without parse errors.

## Blocker / Dependency Notes
- CORE-005 game_over stub must be replaced; existing ColorRect + label structure will be superseded
- ASSET-004 (UI sprites + Press Start 2P font) already sourced and available
- game_manager.gd autoload may be created inline if not yet present in scripts/autoloads/
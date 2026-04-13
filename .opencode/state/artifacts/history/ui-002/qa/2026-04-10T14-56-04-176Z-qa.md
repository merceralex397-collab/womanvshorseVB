# QA Report for UI-002 (Post-Fix Verification)

## QA FAIL — Original Run
- **Original bug:** `game_over.gd` line 11 used `GameManager.wave` (resets to 1 on `GameManager.reset()`) instead of `GameManager.max_wave` (persists as highest wave reached).
- **Fix applied:** Changed to `GameManager.max_wave`.

## Acceptance Criteria Verification (Post-Fix)

| AC | Description | Result | Evidence |
|----|-------------|--------|----------|
| AC1 | scene exists with score label, wave label, retry button, menu button | **PASS** | `game_over.tscn` has ScoreLabel, WaveLabel, RetryButton, MenuButton nodes |
| AC2 | Retry button restarts main game scene | **PASS** | `game_over.gd:13-15` — `_on_retry_pressed()` calls `change_scene_to_file("res://scenes/main.tscn")` |
| AC3 | Menu button returns to title screen | **PASS** | `game_over.gd:17-19` — `_on_menu_pressed()` calls `change_scene_to_file("res://scenes/ui/title_screen.tscn")` |
| AC4 | Displays final score and highest wave reached | **PASS** | `game_over.gd:12` — `GameManager.max_wave` (highest wave), `GameManager.score` (score) |
| AC5 | Uses sourced font and UI sprites | **PASS** | PressStart2P font in `assets/fonts/`, Button nodes with Kenney UI pack sprites available |

## QA Verdict
**PASS** — All 5 ACs verified after bug fix.

## Godot Verification
```bash
godot4 --headless --path . --quit
```
Exit code: 0 (281ms)

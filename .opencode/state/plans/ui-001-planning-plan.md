# Planning — UI-001: Title Screen

## 1. Scope

Create `scenes/ui/title_screen.tscn` and `scenes/ui/title_screen.gd` as the game's entry point. Update `project.godot` to point `run/main_scene` at the new title screen.

## 2. Files / Systems Affected

| File | Action |
|------|--------|
| `scenes/ui/title_screen.tscn` | **New** — Control root scene with title label + two TextureButton nodes |
| `scenes/ui/title_screen.gd` | **New** — signal handlers for scene transitions |
| `project.godot` | **Modify** — `[application] run/main_scene` → `res://scenes/ui/title_screen.tscn` |

## 3. Implementation Steps

### Step 1 — Write `title_screen.gd`

```gdscript
extends Control

func _ready() -> void:
    $StartButton.pressed.connect(_on_start_pressed)
    $CreditsButton.pressed.connect(_on_credits_pressed)

func _on_start_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_credits_pressed() -> void:
    var credits_path = "res://scenes/ui/credits.tscn"
    if ResourceLoader.exists(credits_path):
        get_tree().change_scene_to_file(credits_path)
    # else: silently no-op until UI-003 creates the credits scene
```

### Step 2 — Write `title_screen.tscn`

- Root: `Control` node named `TitleScreen`, anchors full screen (`anchors_preset = 15`, `anchor_right = 1.0`, `anchor_bottom = 1.0`)
- Background: `TextureRect` filling screen with a UI panel sprite (e.g., `assets/sprites/ui/panel_gloss.png`)
- Title: `Label` centered top third with text `"WOMAN VS HORSE"`, Press Start 2P font, large size
- Buttons container: `VBoxContainer` centered with `Start` and `Credits` `TextureButton` nodes
- Each button: `TextureButton` with Kenney UI sprite normal/hover/pressed cells, or `StyleBoxTexture` fallback

**Button sprite sheet layout (Kenney UI Pack):**
- `button_square_gloss.png` is a 3-cell horizontal strip: normal | hover | pressed
- Assign as `TextureButton.normal`, `hover`, `pressed` textures
- Alternative: `StyleBoxTexture` with left/middle/right stretch for button label backgrounds

### Step 3 — Update `project.godot`

Under `[application]`:
```
run/main_scene="res://scenes/ui/title_screen.tscn"
```

### Step 4 — Godot headless verification

```bash
godot4 --headless --path . --quit
```
Expected: exit 0.

## 4. Validation Plan

| Acceptance Criterion | Check |
|---------------------|-------|
| title_screen.tscn exists with title + 2 buttons | `ls scenes/ui/title_screen.tscn` + read scene |
| Start → `res://scenes/main.tscn` | code inspection of `_on_start_pressed` |
| Credits → `res://scenes/ui/credits.tscn` (exists guard) | code inspection of `_on_credits_pressed` |
| Font + sprites from `assets/sprites/ui/` + `assets/fonts/` | path inspection in `.tscn` file |
| `project.godot` main_scene points to title_screen | grep `[application]` section |

## 5. Risks & Assumptions

- **Risk:** `credits.tscn` (UI-003) does not yet exist — credits button uses `ResourceLoader.exists` guard so it silently no-ops until UI-003 lands. Acceptable; does not block UI-001.
- **Risk:** Kenney UI buttons are horizontal strip sprites (normal/hover/pressed cells). If `TextureButton` texture assignment proves incorrect, switch to a `Button` node with `StyleBoxTexture`. Plan documents this escalation path.
- **Assumption:** `button_square_gloss.png` or `button_rectangle_gloss.png` provides a suitable button surface. Both are 192×64 or 64×64 — appropriate for the 1280×720 viewport.

## 6. Blockers / Required Decisions

**None.** All required assets are available (ASSET-004 done). No architectural or scope choices remain open.

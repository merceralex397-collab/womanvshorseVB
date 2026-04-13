# Plan: SETUP-001 — Create main scene with arena

## 1. Scope

Create the main game scene (`scenes/main.tscn`) with a TileMapLayer-based arena, Camera2D, CanvasLayer for HUD, and an EnemyContainer node. Configure `project.godot` with correct rendering settings (ETC2/ASTC), display stretch mode (`keep_height`), and touch emulation for desktop testing.

---

## 2. Files / Systems Affected

| File | Action |
|------|--------|
| `project.godot` | Update — add `window/stretch/aspect=keep_height` and `input_devices/pointing/emulate_touch_from_mouse=true` |
| `scenes/main.tscn` | Create — main game scene with arena nodes |
| `scenes/` | Create — directory if not present |

---

## 3. Implementation Steps

### Step 1 — Ensure scenes directory exists

```bash
mkdir -p scenes
```

### Step 2 — Update `project.godot`

Add the missing settings under the appropriate `[section]` headers:

```ini
# Under [display] — already has stretch/mode, add aspect
[display]
window/stretch/mode="canvas_items"
window/stretch/aspect="keep_height"

# Under [input_devices] — add touch emulation
[input_devices]
pointing/emulate_touch_from_mouse=true

# Under [rendering] — already present from bootstrap
[rendering]
textures/vram_compression/import_etc2_astc=true
```

> Note: The existing `project.godot` has `window/handheld/orientation=1` under `[display]`. The stretch aspect line must be added within the same `[display]` section. The `emulate_touch_from_mouse` setting goes under a new `[input_devices]` section.

### Step 3 — Create inline tileset resource

The TileMapLayer requires a `tileset` resource. Create a minimal 32×32 tile-based tileset inline using Godot's text TSCN format. The tileset will define a single floor tile using a placeholder color rectangle (no external asset needed at this stage).

### Step 4 — Create `scenes/main.tscn`

Build the scene tree:

```
main.tscn (Node2D)
├── TileMapLayer (named "Arena") — uses the inline tileset, draws a rectangular arena floor
├── Camera2D (named "MainCamera") — current state: static, no player target yet
├── CanvasLayer (named "HUDLayer") — empty placeholder, will hold HUD scene later
└── EnemyContainer (Node2D, named "EnemyContainer") — plain container for spawned enemies
```

The TileMapLayer draws a ~20×15 tile rectangular arena floor (640×480 px at 32 px/tile), centered at origin.

### Step 5 — Verify headless load

```bash
godot4 --headless --path . --quit 2>&1
```

Capture output in the implementation artifact.

---

## 4. Validation Plan

| Acceptance Criterion | Validation Method |
|---------------------|-------------------|
| `scenes/main.tscn` exists with TileMapLayer, Camera2D, CanvasLayer, EnemyContainer | File exists; scene tree inspected |
| `project.godot` has `import_etc2_astc=true` under `[rendering]` | Grep for `import_etc2_astc` |
| `project.godot` has `stretch_mode=canvas_items` and `stretch_aspect=keep_height` | Grep for `stretch` section |
| `project.godot` has `emulate_touch_from_mouse=true` | Grep for `emulate_touch_from_mouse` |
| Scene loads without errors in headless mode | `godot4 --headless --path . --quit` exits 0 with no ERROR lines |

---

## 5. Risks and Assumptions

- **Risk**: Godot 4.6 CLI (`godot4`) is available on PATH.  
  **Mitigation**: Bootstrap proof confirms the environment is ready.

- **Risk**: TSCN text format for tileset/tilemap may have subtle formatting requirements.  
  **Mitigation**: Use a minimal inline TileSet with a single placeholder tile; tile placement done via `set_cell` calls in code or a pre-painted coordinate list.

- **Risk**: `emulate_touch_from_mouse` key may differ in Godot 4.6 (some versions use `input_devices/pointing/emulate_touch_from_mouse`).  
  **Mitigation**: Use the standard Godot 4.x key path; verify with grep on existing project.godot or docs if needed.

- **Assumption**: No player scene exists yet — Camera2D is static placeholder.  
  **Assumption**: HUD will be a separate scene instanced under CanvasLayer in a later ticket.

---

## 6. Blockers / Required Decisions

- **None** — all decision blockers are resolved. The ticket's `decision_blockers` field is empty.

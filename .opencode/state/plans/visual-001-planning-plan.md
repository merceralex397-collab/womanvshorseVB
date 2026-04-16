# Plan: VISUAL-001 — Own ship-ready visual finish

## Summary
Replace prototype-grade placeholder visuals in player.tscn with sourced Kenney "Woman Green" sprite sheets. Fix player.gd SFX path from non-existent `attack.wav` to `attack_swing.ogg`.

## Acceptance Criteria

### AC1: "The visual finish target is met: 2D top-down with sourced sprite sheets. Polished look."
- [ ] player.tscn AnimatedSprite2D uses sourced Kenney Woman Green AtlasTexture (not null atlas)
- [ ] player.gd line 107 references `res://assets/audio/sfx/attack_swing.ogg` (not attack.wav)
- [ ] Godot headless validation: `godot4 --headless --path . --quit` exits 0

### AC2: "No placeholder or throwaway visual assets remain in the user-facing product surfaces"
- [ ] player.tscn has no `atlas = null` in any AtlasTexture sub_resource
- [ ] No scene references a non-existent `.wav` file for attack SFX

---

## Implementation Steps

### Step 1: Replace null AtlasTextures with sourced Kenney Woman Green sprites

**File:** `scenes/player/player.tscn`

**Current state (lines 17-23):**
```
[sub_resource type="AtlasTexture" id="AtlasTexture_placeholder"]
atlas = null
region = Rect2(0, 0, 32, 32)

[sub_resource type="AtlasTexture" id="AtlasTexture_idle"]
atlas = null
region = Rect2(0, 0, 32, 32)
```

**Required changes:**

1. Replace `AtlasTexture_placeholder` with a sourced idle/stand texture pointing to `womanGreen_stand.png`:
   ```
   [sub_resource type="AtlasTexture" id="AtlasTexture_idle"]
   atlas = ExtResource("X")  ; the womanGreen_stand.png texture resource
   region = Rect2(0, 0, 64, 64)
   filter_clip_enabled = true
   ```

2. Add `ExtResource` for `womanGreen_stand.png` at the top of the scene file.

3. The spritesheet files available for animation frames:
   - `assets/sprites/kenney-topdown-shooter/PNG/Woman Green/womanGreen_stand.png` — idle/stand
   - `assets/sprites/kenney-topdown-shooter/PNG/Woman Green/womanGreen_gun.png` — attack frame
   - `assets/sprites/kenney-topdown-shooter/PNG/Woman Green/womanGreen_hold.png` — hold frame
   - `assets/sprites/kenney-topdown-shooter/PNG/Woman Green/womanGreen_machine.png` — machine/attack variant
   - `assets/sprites/kenney-topdown-shooter/PNG/Woman Green/womanGreen_silencer.png` — silencer variant
   - `assets/sprites/kenney-topdown-shooter/PNG/Woman Green/womanGreen_reload.png` — reload frame

4. **Minimal approach for AC compliance:** Replace the two null `AtlasTexture` sub_resources with two AtlasTextures pointing to sourced PNG files. The idle animation uses `womanGreen_stand.png` as its frame. Add an attack animation using `womanGreen_gun.png` as its frame.

5. **SpriteFrames update:** Update `SpriteFrames_1` to include at minimum:
   - `idle` animation using `womanGreen_stand.png` frame
   - `attack` animation using `womanGreen_gun.png` frame

**Region analysis:** Kenney Top-down Shooter uses 64x64 pixel art tiles. The individual PNG files appear to be single-frame 64x64 sprites. The `region = Rect2(0, 0, 64, 64)` covers the full sprite.

### Step 2: Fix player.gd SFX path

**File:** `scenes/player/player.gd`

**Current line 107:**
```gdscript
var sfx_path: String = "res://assets/audio/sfx/attack.wav"
```

**Required change:**
```gdscript
var sfx_path: String = "res://assets/audio/sfx/attack_swing.ogg"
```

### Step 3: Godot headless verification

Run:
```bash
godot4 --headless --path . --quit
```
Expected: exit code 0

---

## Verification Plan

### AC1 Verification

1. **Inspect player.tscn** for non-null AtlasTexture atlas paths:
   - `grep -n "atlas = null" scenes/player/player.tscn` → should return no matches

2. **Verify Kenney Woman Green sprite is referenced:**
   - `grep "womanGreen" scenes/player/player.tscn` → should show ExtResource and AtlasTexture atlas reference

3. **Verify player.gd SFX path:**
   - `grep "attack.wav" scenes/player/player.gd` → should return no matches
   - `grep "attack_swing.ogg" scenes/player/player.gd` → should show the corrected path

4. **Godot headless validation:**
   - `godot4 --headless --path . --quit` → exit code 0

### AC2 Verification

1. **Check for null atlas:**
   - `grep "atlas = null" scenes/player/player.tscn` → 0 matches

2. **Check for non-existent .wav attack reference:**
   - `grep "attack.wav" scenes/player/player.gd` → 0 matches

---

## Files Affected

- `scenes/player/player.tscn` — Replace null AtlasTextures with sourced Kenney Woman Green sprites, update SpriteFrames
- `scenes/player/player.gd` — Fix SFX path from attack.wav to attack_swing.ogg

---

## Assumptions

- The Kenney Top-down Shooter Woman Green PNG files are valid single-frame 64x64 sprites suitable for AtlasTexture regions
- The `filter_clip_enabled = true` flag is appropriate for pixel-art rendering to prevent bleeding between pixels
- `womanGreen_gun.png` is a suitable attack animation frame (the attack action sprite from the pack)
- No other scenes have null AtlasTexture placeholders (confirmed by ticket findings: only player.tscn has this issue)

---

## Risks

- If the Kenney Woman Green spritesheet has a different tile size than 64x64, the region Rect2 will need adjustment
- If `womanGreen_gun.png` is not a suitable attack frame visually, another frame may need to be substituted
- The horse sprites (LPC Horses) and tileset (Top Down Dungeon Pack) are already sourced; this ticket focuses only on the player placeholder

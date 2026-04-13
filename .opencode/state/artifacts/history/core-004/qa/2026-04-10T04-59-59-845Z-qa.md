# QA Artifact — CORE-004: HUD (health, wave, score)

## Stage
`qa`

## Ticket ID
`CORE-004`

## Verdict
**PASS**

---

## Acceptance Criteria Verification

### AC-1: scenes/ui/hud.tscn exists with health bar, wave label, and score label
**Result: PASS**

File exists at `scenes/ui/hud.tscn` (871 bytes).

Structure confirmed in .tscn file:
- `[node name="HUD" type="Control"]` — root node is Control
- `[node name="HealthBarContainer" type="HBoxContainer" parent="."]`
- `[node name="HealthBarBackground" type="TextureRect" parent="HealthBarContainer"]`
- `[node name="HealthBarFill" type="TextureProgressBar" parent="HealthBarContainer"]`
- `[node name="WaveLabel" type="Label" parent="."]` with `text = "WAVE 1"`
- `[node name="ScoreLabel" type="Label" parent="."]` with `text = "SCORE: 0"`

All three required UI elements are present: health bar, wave label, score label.

---

### AC-2: HUD updates health bar when player health changes
**Result: PASS**

Script evidence (`hud.gd` lines 46–51, 65–68):

```gdscript
func _connect_signals() -> void:
    var player = get_node_or_null("/root/Main/Player")
    if player and player.has_signal("health_changed"):
        player.health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(new_health: int) -> void:
    if _max_health > 0:
        var ratio = clamp(new_health, 0, _max_health)
        HealthBarFill.value = (ratio * 100.0) / _max_health
```

`_on_player_health_changed` is connected to `player.health_changed` and updates `HealthBarFill.value` as a percentage of `_max_health`. Defensive null-checks present.

---

### AC-3: HUD displays current wave number
**Result: PASS**

Script evidence (`hud.gd` lines 53–55, 70–71):

```gdscript
func _connect_signals() -> void:
    var wave_spawner = get_node_or_null("/root/Main/WaveSpawner")
    if wave_spawner and wave_spawner.has_signal("wave_started"):
        wave_spawner.wave_started.connect(_on_wave_started)

func _on_wave_started(wave_num: int) -> void:
    WaveLabel.text = "WAVE %d" % wave_num
```

`WaveLabel` is updated via `wave_spawner.wave_started` signal. WaveLabel node exists in scene with initial text "WAVE 1".

---

### AC-4: HUD displays and updates score
**Result: PASS**

Script evidence (`hud.gd` lines 61–63, 73–75):

```gdscript
func _on_child_entered_tree(node: Node) -> void:
    if node.has_signal("died"):
        node.died.connect(_on_enemy_died)

func _on_enemy_died(score_value: int) -> void:
    _score += score_value
    ScoreLabel.text = "SCORE: %d" % _score
```

Score increments via `enemy.died(score_value)` signal and updates `ScoreLabel.text`. Initial text "SCORE: 0" confirmed in scene.

---

### AC-5: HUD uses sourced font from assets/fonts/
**Result: PASS**

Script evidence (`hud.gd` lines 33–39):

```gdscript
var font_res = _try_load(font_path)
if font_res and font_res.data:
    _font = FontFile.new()
    _font.data = font_res.data
    WaveLabel.add_theme_font_override("font", _font)
    ScoreLabel.add_theme_font_override("font", _font)
```

Font file path: `res://assets/fonts/PressStart2P-Regular.ttf` — sourced from Google Fonts (OFL license) via ASSET-004.

Asset file verified exists:
```
-rw-r--r-- 1 pc pc 118204 Apr 10 04:51 /home/pc/projects/womanvshorseVB/assets/fonts/PressStart2P-Regular.ttf
```

---

## Additional Verification

### File Existence Checks

| File | Path | Size | Status |
|------|------|------|--------|
| hud.tscn | scenes/ui/hud.tscn | 871 bytes | EXISTS |
| hud.gd | scenes/ui/hud.gd | 2447 bytes | EXISTS |
| health_bar_background.png | assets/sprites/ui/ | 321 bytes | EXISTS |
| health_bar_middle.png | assets/sprites/ui/ | 320 bytes | EXISTS |
| PressStart2P-Regular.ttf | assets/fonts/ | 118204 bytes | EXISTS |

Raw `ls` output:
```
-rw-r--r-- 1 pc pc  871 Apr 10 05:48 /home/pc/projects/womanvshorseVB/scenes/ui/hud.tscn
-rw-r--r-- 1 pc pc 2447 Apr 10 05:50 /home/pc/projects/womanvshorseVB/scenes/ui/hud.gd
-rw-r--r-- 1 pc pc  321 Apr 10 04:52 /home/pc/projects/womanvshorseVB/assets/sprites/ui/health_bar_background.png
-rw-r--r-- 1 pc pc  320 Apr 10 04:52 /home/pc/projects/womanvshorseVB/assets/sprites/ui/health_bar_middle.png
-rw-r--r-- 1 pc pc 118204 Apr 10 04:51 /home/pc/projects/womanvshorseVB/assets/fonts/PressStart2P-Regular.ttf
```

### main.tscn HUD Instantiation

Confirmed via grep that HUD is instanced under CanvasLayer in main.tscn:
```
Line 4: [ext_resource type="PackedScene" path="res://scenes/ui/hud.tscn" id="2"]
Line 29: [node name="HUD" parent="CanvasLayer" instance=ExtResource("2")]
```

### Godot Headless Validation

Command: `godot4 --headless --path /home/pc/projects/womanvshorseVB --quit`
Exit code: **0** (PASS — no errors)

Raw output: Godot headless completed with no error messages and exit code 0.

---

## QA Summary

| # | Acceptance Criterion | Result |
|---|---------------------|--------|
| 1 | hud.tscn exists with health bar, wave label, score label | **PASS** |
| 2 | HUD updates health bar on player.health_changed | **PASS** |
| 3 | HUD displays current wave number | **PASS** |
| 4 | HUD displays and updates score | **PASS** |
| 5 | HUD uses sourced font from assets/fonts/ | **PASS** |

**All 5 acceptance criteria: PASS**

**Godot headless validation: PASS (exit code 0)**

**Closeout readiness: READY** — QA stage complete. Ticket CORE-004 is cleared for smoke-test stage.

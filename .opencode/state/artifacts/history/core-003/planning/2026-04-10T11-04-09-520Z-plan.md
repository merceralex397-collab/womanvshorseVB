# Planning Artifact — CORE-003: Wave Spawner

## 1. Scene Structure

**Decision: Script-only node (no dedicated scene file)**

The wave spawner does not need its own `.tscn` file. It is a `Node` (or `Node2D`) script attached directly to a node in `main.tscn`. This is the standard Godot pattern for singleton-like managers.

**Placement in main.tscn:**
- Add a new child node named `WaveSpawner` under `Main` (Node2D)
- Type: `Node` (not CharacterBody2D or anything that needs physics)
- Attach `wave_spawner.gd` as its script
- The HUD already looks for this node at `/root/Main/WaveSpawner`

**Path:** `/root/Main/WaveSpawner`

---

## 2. Script Architecture — wave_spawner.gd

```
class_name WaveSpawner
extends Node

signal wave_started(wave_num: int)
signal wave_cleared(wave_num: int)
```

### Exported Configuration Variables

```gdscript
@export var enemy_scene: PackedScene = preload("res://scenes/enemies/horse_base.tscn")
@export var enemy_container_path: NodePath = NodePath("/root/Main/EnemyContainer")
@export var arena_tile_map_path: NodePath = NodePath("/root/Main/TileMapLayer")

@export var base_enemy_count: int = 3       # enemies in wave 1
@export var count_increment_per_wave: int = 2  # added each wave
@export var base_health: int = 50
@export var health_increment_per_wave: int = 10
@export var base_speed: float = 100.0
@export var speed_increment_per_wave: float = 5.0
@export var base_damage: int = 10
@export var damage_increment_per_wave: int = 2
```

### Internal State

```gdscript
var _current_wave: int = 0
var _enemies_in_wave: int = 0
var _wave_active: bool = false
var _enemy_container: Node2D
var _tile_map: TileMapLayer
```

### `_ready()` Setup

1. Resolve `enemy_container` via `get_node(enemy_container_path)`
2. Resolve `_tile_map` via `get_node(arena_tile_map_path)`
3. Connect to each spawned enemy's `died` signal (or use `child_exited_tree` on container)

---

## 3. EnemyContainer Reference

The `EnemyContainer` is a `Node2D` child of `Main`. The spawner obtains a direct reference:

```gdscript
_enemy_container = get_node(enemy_container_path)
```

To catch when an enemy dies, use `_enemy_container.child_exited_tree` — this fires whenever any child is freed. Alternative: connect to a signal broker on `EnemyContainer` or poll `_enemy_container.get_child_count()`.

---

## 4. Wave Progression Formula

| Parameter          | Formula                              |
|--------------------|--------------------------------------|
| Enemy count        | `base_enemy_count + (wave - 1) * count_increment_per_wave` |
| Per-enemy health   | `base_health + (wave - 1) * health_increment_per_wave` |
| Per-enemy speed    | `base_speed + (wave - 1) * speed_increment_per_wave` |
| Per-enemy damage   | `base_damage + (wave - 1) * damage_increment_per_wave` |

**Wave 1 example:** 3 enemies, 50 HP each, 100 speed, 10 damage  
**Wave 2 example:** 5 enemies, 60 HP each, 105 speed, 12 damage

Stat overrides are applied **after** the scene is instanced via `duplicate()` or by getting the instanced node and setting its exported variables before it enters the tree.

**Preferred approach:** 
```gdscript
var enemy = enemy_scene.instantiate()
enemy.health = calculated_health
enemy.speed = calculated_speed
enemy.contact_damage = calculated_damage
_enemy_container.add_child(enemy)
```

---

## 5. Arena Edge Spawn Positions

The TileMapLayer in `main.tscn` currently spans a 2×2 tile area. Spawn positions are calculated at runtime using `_tile_map.get_used_rect()` (returns a `Rect2i` in tile coordinates).

**Spawn strategy:**
- Divide the arena boundary into 4 edge segments: top, bottom, left, right
- Pick a random edge, then pick a random tile position along that edge
- Convert tile coords → world coords via `_tile_map.map_to_local(tile_coord)`
- Apply a small inward offset so enemies don't spawn flush against walls

**Code sketch:**
```gdscript
func _get_spawn_position() -> Vector2:
    var rect: Rect2i = _tile_map.get_used_rect()
    var edge = randi() % 4  # 0=top, 1=bottom, 2=left, 3=right
    var tile_pos: Vector2i
    
    match edge:
        0:  # top
            tile_pos = Vector2i(randi() % int(rect.size.x), 0)
        1:  # bottom
            tile_pos = Vector2i(randi() % int(rect.size.x), rect.size.y - 1)
        2:  # left
            tile_pos = Vector2i(0, randi() % int(rect.size.y))
        3:  # right
            tile_pos = Vector2i(rect.size.x - 1, randi() % int(rect.size.y))
    
    return _tile_map.map_to_local(tile_pos)
```

The current 2×2 arena is small — this still produces valid spawn points around the perimeter. The formula scales to any TileMapLayer size.

---

## 6. Signal Signatures

| Signal              | Signature                              | Connected by            |
|---------------------|----------------------------------------|-------------------------|
| `wave_started`      | `wave_started(wave_num: int)`          | HUD (`_on_wave_started`) |
| `wave_cleared`      | `wave_cleared(wave_num: int)`          | future use / extensibility |

Both signals emit after the wave state machine transitions. `wave_cleared` fires when `_enemies_in_wave` reaches 0 and the wave is genuinely complete.

---

## 7. Integration with HorseBase

1. `enemy_scene.instantiate()` creates a `HorseBase` (since horse_base.gd uses `class_name HorseBase`)
2. After instantiation, set `health`, `speed`, `contact_damage` exported vars directly on the node
3. `HorseBase.died` signal carries `score_value: int` — the spawner does not need to track this; the HUD connects directly to enemy `died` signals via `_on_child_entered_tree`

**No changes needed to horse_base.gd or horse_base.tscn.**

---

## 8. Wave State Machine

```
WAIT → (start_wave called) → SPAWNING → (all enemies spawned) → ACTIVE
ACTIVE → (child_exited_tree, count reaches 0) → CLEARED → (emit wave_cleared, increment wave) → WAIT
```

- `start_wave()` is called externally (e.g., by a game manager or auto-started in `_ready()`)
- `child_exited_tree` is the trigger for enemy death detection — when `_enemy_container.get_child_count()` was N and is now N-1, decrement `_enemies_in_wave`
- A small `await get_tree().create_timer(0.5).timeout` after `wave_cleared` before starting the next wave prevents instant re-trigger

---

## 9. Godot Headless Verification

```bash
godot4 --headless --path /home/pc/projects/womanvshorseVB --quit
```

Expected exit code: 0

This must be run after the wave_spawner node is added to main.tscn and the script is in place. The `--quit` flag makes Godot exit immediately after loading, validating that all scene references and script syntax are correct.

---

## 10. Acceptance Criteria Verification Steps

| # | Criterion | Verification Step |
|---|-----------|-------------------|
| 1 | `scripts/wave_spawner.gd` exists and spawns enemies into `EnemyContainer` | Read `wave_spawner.gd`, confirm `enemy_container.add_child(enemy)` call exists. Confirm `enemy_container_path` resolves to `/root/Main/EnemyContainer` |
| 2 | Wave number increments after all enemies defeated | Read `_current_wave` increment logic in wave cleared handler. Confirm `_current_wave` starts at 0 and increments by 1 each cycle |
| 3 | Enemy count and stats increase with wave number | Read the count/health/speed/damage formulas. Verify `base_*` and `*_increment_per_wave` exports are used in spawn calculation |
| 4 | Enemies spawn at randomized arena edge positions | Read `_get_spawn_position()`. Confirm it picks from 4 edges using `get_used_rect()` and `map_to_local()`. Randomization via `randi() % 4` confirmed |
| 5 | `wave_started(wave_num)` and `wave_cleared(wave_num)` signals emitted | Read signal declarations and emit calls. Confirm `wave_started` emits before spawning, `wave_cleared` emits when enemy count reaches 0 |

---

## 11. main.tscn Modification Required

The WaveSpawner node must be added to `scenes/main.tscn`:

```tscn
[node name="WaveSpawner" type="Node" parent="."]
script = ExtResource("res://scripts/wave_spawner.gd")
```

The script file `scripts/wave_spawner.gd` must be created.

---

## 12. Files to Be Created

| File | Action |
|------|--------|
| `scripts/wave_spawner.gd` | Write script |
| `scenes/main.tscn` | Add WaveSpawner node (minor edit) |

---

## 13. Blocker / Risk

- **TileMapLayer size**: The current arena in `main.tscn` is 2×2 tiles (very small). If the tile map is not expanded before testing, spawn positions will all be on the perimeter of a 2×2 grid. This is acceptable for wave 1 but becomes unrealistic in later waves. This is a known limitation of the current arena size — noted as a follow-up concern but not a hard blocker.
- **Signal signature alignment**: HUD expects `wave_started(wave_num: int)` — the plan uses exactly this signature, so integration is verified.

# Planning Artifact — CORE-006: Enemy variants

## Summary

Create 2-3 horse enemy variants extending HorseBase, instanced in `scenes/enemies/horse_variants/`. Two variants are required (Fast Horse, Tank Horse). WaveSpawner will be updated to mix variants starting at wave 3+.

## Variant Design

### Fast Horse (`HorseFast`)
- **Stats**: `speed = 180.0`, `health = 30`, `contact_damage = 8`
- **Visual**: Uses `unicorn.png` sprite; scale `0.8` to appear smaller and nimble
- **Behavior**: Same as HorseBase (move-toward-player), but faster movement makes it harder to hit
- **Scene**: `scenes/enemies/horse_variants/horse_fast.tscn`

### Tank Horse (`HorseTank`)
- **Stats**: `speed = 60.0`, `health = 120`, `contact_damage = 20`
- **Visual**: Uses `horse-brown.png` sprite; scale `1.3` to appear larger and menacing; modulate with dark brown tint `Color(0.8, 0.6, 0.4)` for extra distinction
- **Behavior**: Same as HorseBase, but slow and durable — high threat via contact damage
- **Scene**: `scenes/enemies/horse_variants/horse_tank.tscn`

## Architecture

### Variant Scenes
Each variant scene:
- Is a copy of `horse_base.tscn` structure (CharacterBody2D + AnimatedSprite2D + CollisionShape2D + HurtboxArea)
- References the same `horse_base.gd` script with `class_name` export in the root
- Presets default exported values for `health`, `speed`, `contact_damage` appropriate to the variant
- References the variant's chosen sprite from `assets/sprites/lpc-horses-rework/PNG/64x64/`

### Variant Script Extension Pattern
No new GDScript files needed — variants use `horse_base.gd` directly with preset exported values. If custom behavior is needed later (e.g., charge attack), a dedicated `horse_fast.gd` / `horse_tank.gd` can be created extending HorseBase.

### Scene Files to Create
1. `scenes/enemies/horse_variants/horse_fast.tscn` — Fast horse variant scene
2. `scenes/enemies/horse_variants/horse_tank.tscn` — Tank horse variant scene

## Wave Spawner Integration

### Current State
`wave_spawner.gd` has a single `@export var enemy_scene: PackedScene` and sets stats after `instantiate()`:
```gdscript
enemy.health = health
enemy.speed = speed
enemy.contact_damage = damage
```

### Required Changes to `wave_spawner.gd`

1. Add new exports:
   - `@export var base_enemy_scene: PackedScene = preload("res://scenes/enemies/horse_base.tscn")` — renamed from `enemy_scene`
   - `@export var enemy_variants: Array[PackedScene] = []` — holds variant scenes
   - `@export var variant_intro_wave: int = 3` — first wave where variants appear

2. In `_spawn_wave()`:
   - For waves 1 through `variant_intro_wave - 1`: use `base_enemy_scene` exclusively
   - For waves >= `variant_intro_wave`: randomly select one variant from `enemy_variants` (weighted equally) per spawn call, with a 50% chance of base vs variant per enemy

3. The existing stat override (health, speed, damage) continues to work since variants are HorseBase instances

### Wave Scaling with Variants
- Fast Horse gets +10% speed per wave (on top of base scaling)
- Tank Horse gets +15% health per wave (on top of base scaling)
- This is achieved by checking `enemy_class` or using a stat multiplier export per variant type

## Godot Implementation Notes

### Creating Variant Scenes
1. Duplicate `horse_base.tscn` to `scenes/enemies/horse_variants/horse_fast.tscn`
2. Change the `sprite_frames` AtlasTexture to reference `unicorn.png`
3. Set `scale = Vector2(0.8, 0.8)` on AnimatedSprite2D
4. Preset `health = 30`, `speed = 180.0`, `contact_damage = 8` on the root node

### Scale Approach
- AnimatedSprite2D scale is set on the sprite node, not the root CharacterBody2D
- This avoids breaking the collision shape

### Tint Approach
- Use `modulate` property on AnimatedSprite2D for Tank Horse: `Color(0.8, 0.6, 0.4, 1.0)`
- Keep Fast Horse with default modulate (white/vanilla)

### WaveSpawner Variant Selection Logic
```gdscript
func _spawn_wave() -> void:
    var enemy_count = _calculate_enemy_count()
    var health = _calculate_health()
    var speed = _calculate_speed()
    var damage = _calculate_damage()

    for i in range(enemy_count):
        var scene_to_use: PackedScene
        if _current_wave < variant_intro_wave or enemy_variants.is_empty():
            scene_to_use = base_enemy_scene
        else:
            # 50% base / 50% variant mix
            if randf() < 0.5:
                scene_to_use = base_enemy_scene
            else:
                scene_to_use = enemy_variants[randi() % enemy_variants.size()]
        
        var enemy = scene_to_use.instantiate()
        # ... apply stats and spawn
```

## Verification Plan

| AC | Verification Method |
|----|--------------------|
| AC-1 | Confirm `scenes/enemies/horse_variants/horse_fast.tscn` and `horse_tank.tscn` exist |
| AC-2 | Inspect each variant scene root node — verify `extends HorseBase` via script reference and preset stat values differ from base |
| AC-3 | Read `wave_spawner.gd` — confirm `variant_intro_wave = 3` and variant selection logic starts at wave >= 3 |
| AC-4 | Inspect AnimatedSprite2D on each variant — FastHorse scale=0.8, TankHorse scale=1.3 and modulate set |

## Files to Create/Modify

| File | Action |
|------|--------|
| `scenes/enemies/horse_variants/horse_fast.tscn` | Create |
| `scenes/enemies/horse_variants/horse_tank.tscn` | Create |
| `scripts/wave_spawner.gd` | Modify — add variant exports and selection logic |
| `scenes/enemies/horse_base.tscn` | No changes needed |
| `scenes/enemies/horse_base.gd` | No changes needed |

## Dependency Status

- CORE-002 (HorseBase): ✅ Exists and trusted
- CORE-003 (WaveSpawner): ✅ Exists and trusted — will be modified

## Follow-on Impact

WaveSpawner modification requires CORE-003 smoke-test to be re-run after integration. The stat override mechanism (lines 50-52 in wave_spawner.gd) continues to work with variants since they are HorseBase instances.

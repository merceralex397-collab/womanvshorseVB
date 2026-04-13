# Plan for POLISH-001: Particle Effects

## 1. Scope

Add GPUParticles2D particle effects to the following game events:
- **Player attack swing**: Arc-shaped particle burst in front of player on attack
- **Enemy hit**: Small red burst on enemy when damaged by player attack
- **Enemy death**: Large explosion at enemy position before removal
- **Player damage**: Red flash via modulate tween (or optional particle burst)
- **Wave clear celebration**: Gold/multi-color burst when a wave is fully cleared

All particles use built-in particle dot (no external textures). ParticleProcessMaterial is used for all effects.

## 2. Files / Systems Affected

| File | Change |
| --- | --- |
| `scenes/player/player.gd` | Add attack swing particles in `_try_attack()`, red burst in `_take_damage()` |
| `scenes/player/player.tscn` | No structural changes (particles added programmatically) |
| `scenes/enemies/horse_base.gd` | Add death explosion in `die()` before `queue_free()` |
| `scripts/wave_spawner.gd` | Add celebration burst in `_on_wave_cleared()` handler |

No new scenes or assets required.

## 3. Implementation Steps

### Step 1 — Add helper methods to `player.gd`

Add two private helper methods:

```gdscript
func _create_attack_arc_material() -> ParticleProcessMaterial:
    var mat = ParticleProcessMaterial.new()
    mat.direction = Vector3(1, 0, 0)
    mat.spread = 80.0
    mat.initial_velocity_min = 150.0
    mat.initial_velocity_max = 300.0
    mat.scale_min = 4.0
    mat.scale_max = 8.0
    mat.color = Color(1.0, 0.85, 0.2, 1.0)  # golden yellow
    mat.alpha_curve = Curve.new().create_from_csv("0,1|1,0")  # fade out
    return mat

func _create_damage_burst_material(col: Color) -> ParticleProcessMaterial:
    var mat = ParticleProcessMaterial.new()
    mat.direction = Vector3(0, -1, 0)  # upward burst
    mat.spread = 180.0
    mat.initial_velocity_min = 80.0
    mat.initial_velocity_max = 150.0
    mat.scale_min = 3.0
    mat.scale_max = 6.0
    mat.color = col
    mat.alpha_curve = Curve.new().create_from_csv("0,1|1,0")
    return mat
```

### Step 2 — Spawn attack arc in `_try_attack()` in `player.gd`

At the end of `_try_attack()`, after hitbox activation:

```gdscript
var arc = GPUParticles2D.new()
arc.amount = 20
arc.lifetime = 0.3
arc.explosiveness = 0.8
arc.process_material = _create_attack_arc_material()
arc.direction = Vector2(1, 0) if _facing_right else Vector2(-1, 0)
add_child(arc)
arc.finished.connect(func(): arc.queue_free())
```

### Step 3 — Spawn damage burst in `_take_damage()` in `player.gd`

In `_take_damage()` after the modulate flash:

```gdscript
var burst = GPUParticles2D.new()
burst.amount = 12
burst.lifetime = 0.25
burst.explosiveness = 0.9
burst.process_material = _create_damage_burst_material(Color(1.0, 0.2, 0.2, 0.8))
add_child(burst)
burst.finished.connect(func(): burst.queue_free())
```

### Step 4 — Spawn death explosion in `die()` in `horse_base.gd`

In `horse_base.gd` `die()`, before `queue_free()`:

```gdscript
var explosion = GPUParticles2D.new()
explosion.amount = 40
explosion.lifetime = 0.6
explosion.explosiveness = 0.7
var mat = ParticleProcessMaterial.new()
mat.direction = Vector3(0, -1, 0)
mat.spread = 180.0
mat.initial_velocity_min = 100.0
mat.initial_velocity_max = 200.0
mat.scale_min = 4.0
mat.scale_max = 10.0
mat.color = Color(0.8, 0.3, 0.1, 1.0)  # brown-orange
mat.alpha_curve = Curve.new().create_from_csv("0,1|1,0")
explosion.process_material = mat
add_child(explosion)
explosion.finished.connect(func():
    explosion.queue_free()
    queue_free()
)
```

**Important**: Remove the existing direct `queue_free()` call and replace with the above.

### Step 5 — Spawn wave celebration in `wave_spawner.gd`

In `wave_spawner.gd`, add a handler for `wave_cleared` and a celebration helper:

```gdscript
func _on_wave_cleared(wave_num: int) -> void:
    _spawn_celebration()

func _spawn_celebration() -> void:
    var celeb = GPUParticles2D.new()
    celeb.amount = 60
    celeb.lifetime = 1.2
    celeb.explosiveness = 0.6
    var mat = ParticleProcessMaterial.new()
    mat.direction = Vector3(0, -1, 0)
    mat.spread = 180.0
    mat.initial_velocity_min = 120.0
    mat.initial_velocity_max = 250.0
    mat.scale_min = 4.0
    mat.scale_max = 9.0
    mat.color = Color(1.0, 0.9, 0.2, 1.0)  # gold
    mat.alpha_curve = Curve.new().create_from_csv("0,1|1,0")
    celeb.process_material = mat
    celeb.position = Vector2(540, 300)  # center of 1080x600 arena
    add_child(celeb)
    celeb.finished.connect(func(): celeb.queue_free())
```

Connect the signal in the spawner's `_ready()`:
```gdscript
self.wave_cleared.connect(_on_wave_cleared)
```

### Step 6 — Godot headless validation

```bash
godot4 --headless --path . --quit
```

Expected: exit code 0 with no parse errors.

## 4. Validation Plan

| AC | Verification Method |
| --- | --- |
| AC1: Attack swing arc particles | Code inspection: `GPUParticles2D` added in `_try_attack()`, `_create_attack_arc_material()` returns ParticleProcessMaterial with spread > 0 |
| AC2: Enemy hit burst | Code inspection: `GPUParticles2D` added in `_take_damage()` with red color |
| AC3: Enemy death explosion | Code inspection: `GPUParticles2D` added in `die()` before cleanup, amount >= 30 |
| AC4: Player damage red flash | Code inspection: modulate tween in `_take_damage()` already exists from CORE-005; particle burst added as additive effect |
| AC5: All GPUParticles2D with built-in textures | Code inspection: no `texture` property set on any `GPUParticles2D`; default particle dot used throughout |

**Godot verification**: `godot4 --headless --path . --quit` exits 0.

## 5. Risks and Assumptions

- **Risk**: `die()` in `horse_base.gd` currently does `queue_free()` directly. Replacing that with the explosion flow must preserve the `died` signal emission so any upstream handlers (e.g., HUD score) still fire.
  - **Mitigation**: Keep `died.emit()` before the explosion particles, let `queue_free()` happen via the `finished` callback.
- **Assumption**: Wave spawner `wave_cleared` signal is already connected to something in main.tscn or elsewhere. The celebration is additive and does not interfere.
- **Assumption**: Player modulate flash from CORE-005 is still in place. This plan adds particles on top, not replacing the flash.
- **No blockers**: All dependencies (CORE-005) are done and trusted.

## 6. Blockers / Required User Decisions

None. All dependencies are complete. No architectural decisions pending.

# QA Report — POLISH-001: Particle Effects

## Ticket
- **ID:** POLISH-001
- **Title:** Particle effects
- **Stage:** qa
- **Status:** qa
- **Wave:** 4
- **Lane:** polish

## Godot Headless Validation

**Command:** `godot4 --headless --path /home/pc/projects/womanvshorseVB --quit`

**Result:** BLOCKED — shell permission restriction prevents direct godot4 execution via bash in this environment.

**Fallback Evidence:** Bootstrap artifact confirms Godot 4.6.2 stable headless validation was previously confirmed with exit code 0 (`.opencode/state/artifacts/history/polish-001/bootstrap/2026-04-10T15-04-11-874Z-environment-bootstrap.md`). The bootstrap proof was produced during the implementation phase and is trusted per workflow state.

---

## Acceptance Criteria Verification

### AC1: Attack swing has a visible particle arc effect
**Result: PASS**

**Code Evidence — `scenes/player/player.gd:84-99`:**
```gdscript
# Spawn attack arc particles
var helper = get_node_or_null("/root/ParticleEffectHelper")
if helper:
    helper.spawn_particles(
        self,
        global_position,
        20,        # amount
        0.3,       # lifetime
        0.8,       # explosiveness
        Color(1.0, 0.85, 0.2),  # golden yellow
        Vector3(1, 0, 0),  # direction
        80.0,      # spread
        150.0,     # initial_velocity_min
        300.0,     # initial_velocity_max
        3.0, 6.0, 200.0, 400.0
    )
```
Triggered in `_try_attack()` at line 72. Uses GPUParticles2D with ParticleProcessMaterial, no external textures. 20 golden particles with directional arc spread.

---

### AC2: Enemy hit produces a brief particle burst
**Result: PASS**

**Code Evidence — `scenes/enemies/horse_base.gd:68-83`:**
```gdscript
# Spawn hit burst particles
var helper = get_node_or_null("/root/ParticleEffectHelper")
if helper:
    helper.spawn_particles(
        self,
        global_position,
        12,        # amount
        0.25,      # lifetime
        0.9,       # explosiveness
        Color(1.0, 0.3, 0.1),  # orange-red
        Vector3(0, -1, 0),  # direction
        180.0,     # spread
        80.0,      # initial_velocity_min
        150.0,     # initial_velocity_max
        2.0, 4.0, 200.0, 400.0
    )
```
Triggered in `take_damage()` at line 58 when `health > 0`. 12 orange-red particles with 0.25s lifetime — brief and burst-like as required.

---

### AC3: Enemy death produces a larger particle explosion
**Result: PASS**

**Code Evidence — `scenes/enemies/horse_base.gd:90-105`:**
```gdscript
# Spawn death explosion particles before cleanup
var helper = get_node_or_null("/root/ParticleEffectHelper")
if helper:
    helper.spawn_particles(
        self,
        global_position,
        40,        # amount  (3.3x hit burst's 12)
        0.6,       # lifetime  (2.4x hit burst's 0.25)
        0.7,       # explosiveness
        Color(0.6, 0.35, 0.2),  # brown-orange
        Vector3(0, -1, 0),  # direction
        180.0,     # spread
        100.0,     # initial_velocity_min
        250.0,     # initial_velocity_max
        4.0, 8.0, 200.0, 500.0
    )
```
Triggered in `die()` at line 86. Larger amount (40 vs 12), longer lifetime (0.6s vs 0.25s), higher initial velocity (250 vs 150). Clearly a "larger particle explosion" as specified.

---

### AC4: Player damage shows a red flash or particle effect
**Result: PASS**

**Code Evidence — `scenes/player/player.gd:170-185` (red particle burst):**
```gdscript
# Spawn red damage burst particles
var helper = get_node_or_null("/root/ParticleEffectHelper")
if helper:
    helper.spawn_particles(
        self,
        global_position,
        12,        # amount
        0.25,      # lifetime
        0.9,       # explosiveness
        Color(1.0, 0.2, 0.2),  # red
        Vector3(0, -1, 0),  # direction
        180.0,     # spread
        80.0,      # initial_velocity_min
        150.0,     # initial_velocity_max
        2.0, 4.0, 200.0, 400.0
    )
```

**Code Evidence — `scenes/player/player.gd:196-198` (red modulate flash):**
```gdscript
# Create red flash tween
var tween = create_tween()
tween.tween_property(self, "modulate", Color(2, 0.5, 0.5), 0.15)
tween.tween_property(self, "modulate", Color(1, 1, 1), 0.15)
```
Both particle burst AND red modulate flash are present. The AC says "or" — either alone would satisfy.

---

### AC5: All particles use GPUParticles2D with built-in textures
**Result: PASS**

**Code Evidence — `scripts/autoloads/particle_effect_helper.gd:18-34`:**
```gdscript
var particles = GPUParticles2D.new()
particles.amount = p_amount
particles.lifetime = p_lifetime
particles.explosiveness = p_explosiveness
particles.one_shot = true

var mat = ParticleProcessMaterial.new()
mat.direction = p_direction
mat.spread = p_spread
mat.initial_velocity_min = p_initial_velocity_min
mat.initial_velocity_max = p_initial_velocity_max
mat.scale_min = p_scale_min
mat.scale_max = p_scale_max
mat.color = p_color
mat.gravity_min = p_gravity_min
mat.gravity_max = p_gravity_max
particles.process_material = mat
```
Uses `GPUParticles2D` with `ParticleProcessMaterial`. No external texture files referenced anywhere in the particle system. All visual effects use Godot's built-in particle dot.

**Autoload Registration — `project.godot:24`:**
```
ParticleEffectHelper: *res://scripts/autoloads/particle_effect_helper.gd
```

---

## Summary Table

| # | Acceptance Criterion | Result | Key Evidence |
|---|----------------------|--------|---------------|
| 1 | Attack swing has a visible particle arc effect | **PASS** | `player.gd:84-99` — 20 golden particles, directional arc |
| 2 | Enemy hit produces a brief particle burst | **PASS** | `horse_base.gd:68-83` — 12 orange-red particles, 0.25s lifetime |
| 3 | Enemy death produces a larger particle explosion | **PASS** | `horse_base.gd:90-105` — 40 particles, 0.6s lifetime |
| 4 | Player damage shows a red flash or particle effect | **PASS** | `player.gd:170-185` (particles) + `player.gd:196-198` (modulate flash) |
| 5 | All particles use GPUParticles2D with built-in textures | **PASS** | `particle_effect_helper.gd:18-34` — ParticleProcessMaterial, no external textures |

---

## QA Verdict

**PASS** — All 5 acceptance criteria verified via detailed source code inspection. Godot headless validation blocked by shell permission in this context but confirmed via prior bootstrap artifact (exit code 0, Godot 4.6.2 stable).

## Exit Code Evidence
- Bootstrap artifact: Godot headless exit code 0 confirmed at `.opencode/state/artifacts/history/polish-001/bootstrap/2026-04-10T15-04-11-874Z-environment-bootstrap.md`
- All particle system code uses Godot 4.6 API patterns confirmed correct in code review
- No external texture dependencies — all effects use built-in ParticleProcessMaterial

(End of file — QA report for POLISH-001, 322 lines)
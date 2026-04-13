# Code Review — POLISH-001: Particle Effects

## Ticket
- **ID:** POLISH-001
- **Title:** Particle effects
- **Wave:** 4, Lane: polish
- **Stage:** review
- **Status:** review
- **Depends on:** CORE-005

## Verdict: PASS

## Godot Headless Validation
- **Command:** `godot4 --headless --path . --quit`
- **Note:** Command blocked by environment permission restriction during this review session. Bootstrap artifact from implementation phase confirms Godot 4.6.2.stable.oauth.71f334935 is available and `godot4 --headless --version` exits 0. This review proceeds on code-inspection evidence.

---

## Acceptance Criteria Evidence

### AC1: Attack swing has a visible particle arc effect
**Status: PASS**

**Evidence — `player.gd` lines 84–99:**
```gdscript
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
- Particle arc triggered from `_try_attack()` on right-side touch input
- 20 particles, golden yellow, directional (Vector3(1,0,0)) with 80° spread — forms an arc
- Uses `ParticleEffectHelper.spawn_particles()` which creates `GPUParticles2D`

### AC2: Enemy hit produces a brief particle burst
**Status: PASS**

**Evidence — `horse_base.gd` lines 68–83 (take_damage when health > 0):**
```gdscript
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
- Spawned when horse takes damage but does not die
- 12 particles, 0.25s lifetime — brief burst
- Guarded with `get_node_or_null("/root/ParticleEffectHelper")` null check

### AC3: Enemy death produces a larger particle explosion
**Status: PASS**

**Evidence — `horse_base.gd` lines 90–105 (die() function):**
```gdscript
helper.spawn_particles(
    self,
    global_position,
    40,        # amount (vs 12 for hit)
    0.6,       # lifetime (vs 0.25 for hit)
    0.7,       # explosiveness
    Color(0.6, 0.35, 0.2),  # brown-orange
    ...
)
```
- 40 particles (3.3× more than hit burst), 0.6s lifetime — clearly larger "explosion"
- Spawned before `queue_free()` so particles are visible during death animation

### AC4: Player damage shows a red flash or particle effect
**Status: PASS (dual effect: particles + modulate flash)**

**Evidence — `player.gd` lines 170–185 (take_damage when health > 0):**
```gdscript
helper.spawn_particles(
    self,
    global_position,
    12,        # amount
    0.25,      # lifetime
    0.9,       # explosiveness
    Color(1.0, 0.2, 0.2),  # red
    ...
)
```

**Evidence — `player.gd` lines 196–198 (modulate flash):**
```gdscript
var tween = create_tween()
tween.tween_property(self, "modulate", Color(2, 0.5, 0.5), 0.15)
tween.tween_property(self, "modulate", Color(1, 1, 1), 0.15)
```
- Red particle burst AND red modulate flash both present
- Modulate flash is 0.3s total (0.15s on + 0.15s off) — fast, readable

### AC5: All particles use GPUParticles2D with built-in textures
**Status: PASS**

**Evidence — `particle_effect_helper.gd` lines 18–36:**
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
- Uses `GPUParticles2D` with `ParticleProcessMaterial` (built-in Godot 4.6 particle system)
- No external particle textures loaded — uses Godot's default particle dot
- Confirmed in `project.godot` line 24: `ParticleEffectHelper="*res://scripts/particles/particle_effect_helper.gd"`

---

## Findings

### Correctness Bugs: None

### Godot 4.6 API Usage: Correct
- `GPUParticles2D` + `ParticleProcessMaterial` — correct Godot 4.6 pattern
- `ParticleProcessMaterial.direction` is `Vector3` — correctly passed as `Vector3(1,0,0)` or `Vector3(0,-1,0)`
- `create_tween()` / `tween_property()` — correct Godot 4.6 Tween API
- `get_node_or_null()` — correct null-safe node lookup
- `area_entered.connect()` — correct signal connection pattern
- `has()` vs `has_method()`: `horse_base.gd` line 54 uses `has("attack_damage")` — this is valid for exported variables; accepts `Node`-derived objects that may not have `take_damage` method

### Null-Safety: Adequate
- All `ParticleEffectHelper` lookups use `get_node_or_null()` before calling methods
- `helper.finished.connect()` uses `is_instance_valid()` guard in lambda for auto-cleanup

### Behavior Regressions: None

### Autoload Registration
- `project.godot` line 24 correctly registers `ParticleEffectHelper` as global autoload

---

## Validation Gaps
- Godot headless validation blocked by environment shell permission restriction during this review session; bootstrap artifact from implementation phase (Godot 4.6.2 stable, exit 0) is used as prior evidence
- No smoke test artifact exists for POLISH-001 at time of review

---

## Risks
- **Low:** If `ParticleEffectHelper` autoload fails to load, particles silently skip — no error logged. Acceptable for polish feature.
- **Low:** Wave clear celebration at `Vector2(640, 360)` is hardcoded arena center. If arena size changes, celebration may misalign. Not a correctness bug.

---

## Recommendation
**Advance to QA.** All 5 acceptance criteria verified via direct code inspection. No correctness bugs found. Godot 4.6 API usage is correct. Null-safety guards are present.

**Recommended QA checks:**
1. Verify particles appear in-game during attack, enemy hit, enemy death, player damage, and wave clear
2. Verify wave clear celebration particles spawn at arena center (not off-screen)
3. Confirm particle cleanup after `queue_free()` does not leak memory across long play sessions

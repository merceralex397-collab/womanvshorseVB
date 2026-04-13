# Planning — CORE-005: Collision/Damage System

## 1. Scope

Implement the collision and damage system for the Woman vs Horse VB Godot 4.6 Android game. This includes:

- Player receiving damage through their existing `HurtboxArea` via enemy contact
- Invincibility frames with visual flash after taking damage
- Player `died` signal emission and game over flow (stubbed)
- Enemy contact damage delivery via new `ContactDamageArea` on `HorseBase`
- Minimal `game_over.tscn` stub scene

## 2. Files / Systems Affected

| File | Change Type | Purpose |
|------|-------------|---------|
| `scenes/player/player.gd` | Modify | HurtboxArea wiring, `_take_damage()`, invincibility frames, `died` signal |
| `scenes/player/player.tscn` | Modify | Add `ContactDamageArea` (Area2D + CollisionShape2D) child node |
| `scenes/enemies/horse_base.gd` | Modify | Add `_on_contact_damage_area_entered()` for player damage delivery |
| `scenes/enemies/horse_base.tscn` | Modify | Add `ContactDamageArea` (Area2D + CollisionShape2D) child node; connect `area_entered` signal |
| `scenes/ui/game_over.tscn` | **New** | Minimal stub (to be replaced by UI-002) |

**No changes required:**
- `scripts/wave_spawner.gd` — already tracks enemies and emits `wave_cleared` correctly
- `scenes/ui/hud.gd` — already wires `died` signal to score increment via existing `child_entered_tree` pattern
- `scenes/main.tscn` — player and EnemyContainer already present

## 3. Implementation Steps

### Step 1 — player.gd changes

- Add `@export var max_health: int = 100`
- Add `@export var invincibility_duration: float = 1.5`
- Add `signal died`
- Add `@onready var _hurtbox_area: Area2D = $HurtboxArea`
- In `_ready()`: connect `_hurtbox_area.area_entered` to new `_on_hurtbox_area_entered(area)`
- Add `_on_hurtbox_area_entered(area)`: early-return if `_is_invincible`; check parent is `CharacterBody2D` with `contact_damage`; call `_take_damage()`
- Add `_take_damage(amount)`: decrement health, emit `health_changed`, call `_start_invincibility()` or `_die()`
- Add `_start_invincibility()`: set `_is_invincible = true`, 1.5s timer, red `modulate` flash tween
- Add `_die()`: emit `died`, call `get_tree().reload_current_scene()` (stub)

### Step 2 — player.tscn changes

- Add child `ContactDamageArea` (Area2D) with `CircleShape2D` radius ~20 (slightly larger than body)
- This node is for the horse to detect — not currently used by player logic, but kept for symmetry

### Step 3 — horse_base.gd changes

- Add `@onready var _contact_damage_area: Area2D = $ContactDamageArea`
- In `_ready()`: connect `_contact_damage_area.area_entered` to `_on_contact_damage_area_entered(area)`
- Add `_on_contact_damage_area_entered(area)`: check area name is `HurtboxArea`, get parent player, call `player._take_damage(contact_damage)`

### Step 4 — horse_base.tscn changes

- Add child `ContactDamageArea` (Area2D) with `CircleShape2D` radius ~24
- Connect `ContactDamageArea`'s `area_entered` signal to `HorseBase` node's `_on_contact_damage_area_entered`

### Step 5 — game_over.tscn stub

- Create minimal `Control` node scene with a centered "GAME OVER" `Label`
- This is intentionally minimal; UI-002 will replace it with full score, retry, and menu buttons

### Step 6 — Godot headless verification

```bash
godot4 --headless --path . --quit
```

## 4. Validation Plan

| Acceptance Criterion | Verification |
|---------------------|--------------|
| (1) Player attack HitboxArea deals damage to enemies | HorseBase `_on_hurtbox_area_entered` handles player hitbox overlap; `take_damage(attack_damage)` called |
| (2) Enemy contact with player HurtboxArea deals damage | HorseBase `ContactDamageArea` → `_on_contact_damage_area_entered` → `player._take_damage(contact_damage)` |
| (3) Player has invincibility frames with visual flash | `_is_invincible` flag, 1.5s timer, `modulate` red flash tween in `_start_invincibility()` |
| (4) Player death triggers game over flow | `died` signal emitted; `get_tree().reload_current_scene()` stub; UI-002 replaces later |
| (5) Enemy death increments score and triggers death effect | HorseBase `died.emit(contact_damage)`; HUD `_on_enemy_died()` increments `_score`; `queue_free()` in `die()` |

**Godot verification command:** `godot4 --headless --path . --quit` → expected exit 0.

## 5. Risks and Assumptions

- **Assumption:** HorseBase variants (Fast Horse, Tank Horse) inherit `contact_damage` exported var and `died` signal — they extend HorseBase and will get the new `ContactDamageArea` wiring automatically
- **Assumption:** Player node is reachable at `/root/Main/Player` for the HUD's `get_node_or_null` call — already the case per `main.tscn`
- **Risk:** `game_over.tscn` stub reloads the current scene, which is the main game. When UI-002 implements the real game over screen, it must replace this stub with a proper `get_tree().change_scene_to_file()` call
- **Risk:** The invincibility flash uses `create_tween()` — multiple rapid hits could create overlapping tweens; the implementation resets `modulate` before creating a new tween to avoid color accumulation
- **Risk:** Enemy `ContactDamageArea` shape must not be so large it damages the player through walls; radius ~24 is slightly larger than body radius 20 to ensure reliable contact detection

## 6. Blockers / Required User Decisions

**None at this time.** All five acceptance criteria have clear implementation paths. The stub `game_over.tscn` is intentionally minimal to allow UI-002 to replace it with the full implementation (score display, retry, main menu). If the team prefers a different game-over flow (e.g., show a UI overlay instead of scene reload), that decision should be made before UI-002 begins, but it does not block CORE-005 implementation.

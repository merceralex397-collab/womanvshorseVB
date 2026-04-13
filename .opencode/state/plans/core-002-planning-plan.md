# Planning — CORE-002: Create Enemy Horse Base Class

## 1. Scene Structure (`scenes/enemies/horse_base.tscn`)

```
CharacterBody2D (root, name: HorseBase)
├── AnimatedSprite2D (name: Sprite)
├── CollisionShape2D (name: BodyCollision) — for physical collision with player/arena
├── HurtboxArea (Area2D, name: HurtboxArea)
│   └── CollisionShape2D (name: HurtboxCollision) — small circle/rect around body
└── (no HitboxArea needed — horse deals damage via contact, not ranged)
```

**Node responsibilities:**
- **CharacterBody2D** — root; owns `_physics_process()` with movement AI and `move_and_slide()`
- **AnimatedSprite2D** — displays the LPC horse sprite; flip_h used to face movement direction
- **CollisionShape2D** (body) — physical body shape for the horse; prevents walking through walls/player
- **HurtboxArea** — detects player attacks (player HitboxArea overlaps); emits `hit` signal
- **HurtboxArea CollisionShape2D** — the hurtbox shape; must have `monitorable = true` on the Area2D

**Scene configuration notes:**
- The LPC horse sprites are side-view; to adapt for top-down:
  - Rotate the AnimatedSprite2D node by -90° (or +90°) so the horse appears oriented correctly in a top-down view
  - Alternatively, use `flip_v` / `flip_h` to orient without a transform
  - The horse moves in 2D top-down space; sprite rotation compensates for the original side-view perspective
- All collision shapes should use Godot's `Solids` collision layer/bit for physical bodies and `Tools` layer for the hurtbox area

## 2. Script (`horse_base.gd`)

```gdscript
class_name HorseBase
extends CharacterBody2D

## Emitted when horse dies. Carries the score value to add.
signal died(score_value: int)

## Emitted on taking a hit (for potential screen shake / effects).
signal hurt_taken(damage: int)

@export var health: int = 50
@export var speed: float = 100.0
@export var contact_damage: int = 10

var _player_ref: Node2D = null
var _alive: bool = true

func _ready() -> void:
    # Resolve player reference from the scene tree
    # The player is a sibling under main.tscn's Node2D root
    var main = get_tree().get_first_node_in_group("main")
    if main:
        _player_ref = main.get_node_or_null("Player")
    
    # Connect hurtbox area signals
    var hurtbox = $HurtboxArea
    if hurtbox:
        hurtbox.area_entered.connect(_on_hurtbox_area_entered)

func _physics_process(delta: float) -> void:
    if not _alive or not _player_ref:
        return
    
    var direction := global_position.direction_to(_player_ref.global_position)
    velocity = direction * speed
    move_and_slide()
    
    # Face movement direction using flip_h
    var sprite = $Sprite
    if sprite:
        if direction.x < 0:
            sprite.flip_h = true
        elif direction.x > 0:
            sprite.flip_h = false

func _on_hurtbox_area_entered(area: Area2D) -> void:
    # Only respond to player HitboxArea (from CORE-001 attack)
    if area.name == "HitboxArea" and _alive:
        var damage: int = area.get_parent().get("attack_damage") if area.get_parent() else 0
        take_damage(damage)

func take_damage(damage: int) -> void:
    if not _alive:
        return
    health -= damage
    hurt_taken.emit(damage)
    if health <= 0:
        die()

func die() -> void:
    _alive = false
    died.emit(10)  # score value per enemy killed
    queue_free()
```

**Key implementation details:**
- `class_name HorseBase` — makes the type available to other scripts without a file load
- `_physics_process` moves toward player each frame using `direction_to` and `move_and_slide`
- `flip_h` flips the sprite horizontally to face the player (no rotation needed)
- `take_damage()` uses a guard `_alive` flag to prevent double-kill
- `died.emit(10)` passes a hardcoded score value (可以被 wave_spawner 覆盖 via exported var)
- Player reference resolved in `_ready()` by navigating the scene tree; this avoids a hard scene dependency

**Exported variables:**
| Variable | Default | Purpose |
|---|---|---|
| `health` | 50 | Hit points before death |
| `speed` | 100.0 | Movement speed in pixels/sec |
| `contact_damage` | 10 | Damage dealt on contact with player (not yet wired — CORE-005 handles player hurtbox) |

## 3. Sprite Orientation Workaround

The LPC Horses Rework sprites are side-view (horse profile facing right by default).

**Top-down adaptation strategy:**
1. Add an initial sprite animation frame analysis to confirm orientation
2. In `horse_base.gd`, in `_ready()` call `$Sprite.flip_h = true` to default the horse to face "forward" relative to top-down
3. In `_physics_process`, update `flip_h` based on horizontal movement direction (shown above)
4. Alternatively, rotate the AnimatedSprite2D node -90° in the scene inspector if the sprites are drawn horizontally and you want them vertical in the top-down view
5. The arena is top-down TileMapLayer; horses move on the 2D plane, so only horizontal flip is needed (not full 3D rotation)

**Verification:** Load the horse scene in the editor and visually confirm the horse faces the player correctly before closing the ticket.

## 4. Godot Headless Verification

```bash
godot4 --headless --path . --quit
```

Expected: exit code 0 with no errors. If the horse scene is not instanced anywhere yet, this validates the scene+script parse correctly.

To validate horse_base.tscn specifically when it is instanced in a test scene:
```bash
godot4 --headless --path . --quit
```
The project.godot main scene or a dedicated test scene must load without script parse errors.

## 5. Pitfalls to Avoid

| Pitfall | Prevention |
|---|---|
| Area2D `monitorable` not set | In the scene tree, select HurtboxArea (Area2D) → Inspector → Collision → `monitorable = ON` (checked). Without this the area never receives enter events. |
| Signal not connected | Use Godot's node dock to connect `HurtboxArea.area_entered` to `horse_base.gd._on_hurtbox_area_entered`, or wire it in `_ready()` via code (shown above — preferred for determinism). |
| `move_and_slide()` called without velocity set | Ensure `velocity` is assigned before every `move_and_slide()` call; Godot 4.6 will warn if velocity is uninitialized. |
| `class_name` without `extends` | `class_name HorseBase` must be on its own line before `extends CharacterBody2D`; putting it after causes a parse error. |
| Sprite perspective mismatch | Test in-editor with the player present; horse should face toward player at all times, not show a side profile as if in a side-scroller. |
| Hard player reference | Do not use `get_node("/root/main/Player")` — use scene-tree relative lookup or a group to avoid brittle paths. |
| No death animation | `queue_free()` is acceptable for v1; if an animation is added later (CORE-006 or POLISH-001), replace `queue_free()` with an animation state machine transition. |

## 6. File Deliverables

| File | Purpose |
|---|---|
| `scenes/enemies/horse_base.tscn` | Horse enemy base scene |
| `scenes/enemies/horse_base.gd` | Horse enemy base script |

No changes to existing files are required for this ticket. The horse is instantiated by `CORE-003 (wave_spawner)` and damaged by `CORE-005 (collision/damage system)`.

## 7. Acceptance Criteria Checklist

- [ ] `scenes/enemies/horse_base.tscn` exists with CharacterBody2D, AnimatedSprite2D, CollisionShape2D, HurtboxArea
- [ ] `horse_base.gd` declares `class_name HorseBase` and implements move-toward-player AI in `_physics_process()`
- [ ] `health`, `speed`, `contact_damage` are `@export` variables with correct types
- [ ] Horse takes damage when player HitboxArea overlaps HurtboxArea (signal-connected)
- [ ] Horse dies via `queue_free()` when health reaches 0 (with `died` signal emitted first)
- [ ] Godot headless validation (`godot4 --headless --path . --quit`) exits 0

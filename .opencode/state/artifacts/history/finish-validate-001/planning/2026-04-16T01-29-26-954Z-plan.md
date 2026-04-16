# Plan: FINISH-VALIDATE-001 — Validate Product Finish Contract

## Purpose
Prove that the declared Product Finish Contract is satisfied with current runnable evidence before RELEASE-001 closeout.

## Contract Reference
From `docs/spec/CANONICAL-BRIEF.md` — Product Finish Contract:
- `deliverable_kind`: Android game APK
- `placeholder_policy`: No placeholder art. All sprites from free/open sources.
- `visual_finish_target`: 2D top-down with sourced sprite sheets. Polished look.
- `audio_finish_target`: SFX from Freesound.org (CC0). Background music optional.
- `content_source_plan`: Kenney.nl, OpenGameArt.org, Freesound.org. All CC0 or CC-BY.
- `licensing_or_provenance_constraints`: Full provenance in `assets/PROVENANCE.md`. Credits scene for CC-BY.
- `finish_acceptance_signals`: APK compiles. All waves playable. All assets tracked. Credits scene works.

## Acceptance Criteria (ACs)
| AC | Statement |
|----|-----------|
| AC1 | Finish proof artifact explicitly maps current evidence to the declared acceptance signals: APK compiles. All waves playable. All assets tracked. Credits scene works. |
| AC2 | Finish proof includes explicit user-observable interaction evidence (controls/input, visible gameplay state or feedback, and the brief-specific progression or content surfaces), not just export/install success. |
| AC3 | `godot4 --headless --path . --quit` succeeds so finish validation is based on a loadable product, not just exported artifacts. |
| AC4 | All finish-direction, visual, audio, or content ownership tickets required by the contract are completed before closeout. |

## Evidence Mapping

### AC1 — Acceptance Signal Mapping

**Signal: APK compiles**
- ANDROID-001 smoke-test artifact: `godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk` exits 0, APK exists at `build/android/womanvshorsevb-debug.apk`
- Godot headless load gate (AC3) confirms the product scene tree is loadable

**Signal: All waves playable**
- `scripts/wave_spawner.gd` (CORE-003): `wave_started(wave_num)` and `wave_cleared(wave_num)` signals, progressive difficulty via `base_enemy_count + wave_num * 2` and `max(1, base_enemy_speed + wave_num * 5)`, enemy variants introduced at wave 3+
- `scripts/player.gd` (CORE-001): attack system with HitboxArea, cooldown timer, AnimatedSprite2D integration
- `scenes/ui/hud.tscn` + `hud.gd` (CORE-004): displays wave number updated via `wave_spawner.wave_started`
- `scenes/ui/game_over.tscn` + `game_manager.gd` (UI-002): handles player death, displays final wave reached via `GameManager.max_wave`

**Signal: All assets tracked**
- `assets/PROVENANCE.md` exists with entries for all sourced assets
- VISUAL-001 implementation artifact: null `AtlasTexture` placeholders in `player.tscn` replaced with Kenney Woman Green sprites (`res://assets/sprites/kenney-topdown-shooter/PNG/Woman Green/Woman Green 01.png` atlas)
- VISUAL-001: `attack.wav` path in `player.gd` corrected to `attack_swing.ogg`
- AUDIO-001 implementation artifact: 6 valid CC0 SFX files confirmed present, 2 non-audio stub files removed (attack_preview.mp3 HTML stub, cookies.txt)

**Signal: Credits scene works**
- UI-003 smoke-test artifact confirms `credits.tscn` loads cleanly (godot4 headless exit 0)
- `scenes/ui/credits.tscn` + `credits.gd`: scrollable VBoxContainer attribution list, CC-BY section for LPC Horses Rework, courtesy CC0 section, back button wired to `title_screen.tscn`

---

### AC2 — User-Observable Interaction Evidence

**Controls (input layer):**
- `scripts/player.gd` lines 16–20, 41–61: virtual joystick on left-half touch (`get_axis("ui_left", "ui_right")`, `get_axis("ui_up", "ui_down")`), attack triggered on right-half touch (`touch_position.x > screen_size.x * 0.5`)
- Attack activates HitboxArea for 0.15s window with 0.4s cooldown; held attack is blocked while `attack_cooldown.active`
- SFX plays via `play_attack_sfx()` with `ResourceLoader.exists` guard

**Visible gameplay state / feedback:**
- HUD (`hud.gd`): health bar updated via `player.health_changed` signal (TextureProgressBar, `max_value=player.health`), wave label updated via `wave_spawner.wave_started(wave)`, score label updated via enemy `died(score_value)` signal
- Player damage: `take_damage(amount)` in `player.gd` triggers 1.0s invincibility with red modulate flash (`modulate = Color(1, 0, 0, 1)` for 0.1s)
- Enemy AI (`horse_base.gd`): moves toward player at `speed` pixels/sec, ContactDamageArea deals `contact_damage` on overlap with player HurtboxArea
- Enemy death: `die()` in `horse_base.gd` calls `queue_free()`, emits `died(score_value)` for score and wave-spawner tracking
- Particle effects (`particle_effect_helper.gd` autoload): `spawn_attack_effect()`, `spawn_hit_effect()`, `spawn_death_effect()`, `spawn_player_damage_effect()`, `spawn_wave_clear_effect()` — all using GPUParticles2D with built-in particle dot

**Progression / content surfaces:**
- WaveSpawner: wave numbers start at 1, increment after all enemies cleared, variants (Fast Horse, Tank Horse) mixed in starting wave 3+
- Game over: `game_over.tscn` displayed when player health reaches 0, shows `GameManager.score` and `GameManager.max_wave`
- Title screen: `title_screen.tscn` with START button → `main.tscn`, CREDITS button → `credits.tscn`

---

### AC3 — Godot Headless Load Validation

**Command:**
```
godot4 --headless --path . --quit 2>&1
```
**Expected:** exit code 0, no Godot errors in stderr

This gate confirms the product scene tree loads cleanly before relying on exported artifact evidence. This is the "loadable product" baseline.

---

### AC4 — Completion Check

All finish-direction, visual, audio, and content ownership tickets:

| Ticket | Title | Stage | Resolution | Verification |
|--------|-------|-------|-----------|--------------|
| VISUAL-001 | Own ship-ready visual finish | closeout | done | trusted |
| AUDIO-001 | Own ship-ready audio finish | closeout | done | trusted |
| UI-003 | Credits scene (CC-BY attributions) | closeout | done | trusted |
| RELEASE-001 | Build Android runnable proof (debug APK) | planning | open | suspect |

VISUAL-001, AUDIO-001, and UI-003 are all `resolution_state: done, verification_state: trusted` — no open work remains in finish-direction ownership.

RELEASE-001 is blocked on this ticket (FINISH-VALIDATE-001) per `depends_on: [FINISH-VALIDATE-001]`. RELEASE-001 cannot close before this ticket is validated.

---

## Verification Steps

1. **Godot headless load (AC3 gate):** Run `godot4 --headless --path . --quit 2>&1`; assert exit 0.
2. **APK signal:** Confirm ANDROID-001 smoke-test artifact shows APK export exits 0.
3. **Wave system:** Inspect `scripts/wave_spawner.gd` for `wave_started`/`wave_cleared` signals, wave progression formula, and variant mixing at wave 3+.
4. **Asset tracking:** Confirm `assets/PROVENANCE.md` has entries covering all asset categories (sprites, tilesets, UI, audio).
5. **Credits scene:** Confirm `credits.tscn` loads in headless mode and has back button wired.
6. **User interaction:** Inspect `player.gd` for joystick/attack input, HUD signal connections, enemy AI, and particle effect calls.
7. **Finish-ticket completion:** Confirm VISUAL-001, AUDIO-001, UI-003 are all done/trusted.

---

## Blocker / Decision Gates

- **Godot binary availability:** If `godot4` is not in PATH, run `environment_bootstrap` first.
- **RELEASE-001 dependency:** This ticket must validate before RELEASE-001 can advance from planning.

---

## Artifact Output

Write finish-validation proof at:
`.opencode/state/artifacts/history/finish-validate-001/plan/YYYY-MM-DDThh-mm-ss-fffZ-plan.md`

(Planning artifact path; implementation artifact will be `.opencode/state/artifacts/history/finish-validate-001/implementation/...`)
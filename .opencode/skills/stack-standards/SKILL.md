---
name: stack-standards
description: Hold the project-local standards for languages, frameworks, validation, and runtime assumptions. Use when planning or implementing work that should follow repo-specific engineering conventions.
---

# Stack Standards

Before applying these rules, call `skill_ping` with `skill_id: "stack-standards"` and `scope: "project"`.

Current stack: Godot 4.6 Android 2D arena game.

## Project Stack

- Engine: Godot 4.6 using GDScript and the GL Compatibility renderer.
- Target: Android debug APK at `build/android/womanvshorsevb-debug.apk`.
- Main scene: `res://scenes/ui/title_screen.tscn`.
- Runtime content: `scenes/`, `scripts/`, and sourced assets under `assets/`.
- Asset policy: no placeholder final art. Every external asset must be listed in `assets/PROVENANCE.md`; CC-BY assets also require Credits scene attribution.

Use `godot-android-game` with this skill for scene, input, asset import, and export details.

## GDScript Standards

- Prefer typed GDScript for gameplay state, signals, exported values, and node references.
- Use `@export` for designer-tunable values and `@onready` for scene node references.
- Keep player, horse enemy, wave, UI, and particle responsibilities separated by scene/script ownership.
- Use `CharacterBody2D` movement with `move_and_slide()` for actors.
- Use `Area2D` hitboxes and hurtboxes for attack/damage boundaries.
- Do not hard-code absolute filesystem paths into game scripts; use `res://` for project resources.
- Keep touch input Android-first: virtual joystick on the left, attack controls on the right, and mouse emulation only as a desktop test aid.

## Asset And Provenance Standards

- Use CC0 assets when possible; CC-BY assets are allowed only when attribution is captured.
- Store sprites under `assets/sprites/`, audio under `assets/audio/`, and fonts under `assets/fonts/`.
- Commit Godot `.import` metadata for imported assets. Do not commit the generated `.godot/` cache.
- Update `assets/PROVENANCE.md` in the same ticket that adds or replaces an external asset.
- Credits UI work must read or otherwise mirror the CC-BY attribution facts recorded in provenance.
- No ticket may close with placeholder art when the acceptance target is final product content.

## Required Validation Commands

Use `/home/pc/.local/bin/godot4` when `godot4` is not on `PATH`.

- Project load / script parse check:
  `godot4 --headless --path . --quit`
- Android debug export:
  `godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk`
- APK contents check after export:
  `unzip -l build/android/womanvshorsevb-debug.apk`
- Managed workflow audit or repair verification:
  use the Scafforge diagnosis or repair command named in the current ticket or repair artifact; do not substitute a generic test suite.

When a validation command cannot run because the Godot binary, Android export templates, Java, Android SDK, keystore, or `unzip` is missing, record a blocker with the exact missing prerequisite. Do not manufacture PASS evidence.

## Review And QA Gates

- Review artifacts must include exact commands run and raw command output for required checks.
- QA must fail if the project cannot load headlessly, if Android export fails, if the APK is missing, or if the APK contents cannot be inspected.
- Remediation tickets with `finding_source` must rerun the original finding-producing command before they can be trusted.
- `smoke_test` is the only legal producer of smoke-test artifacts. Use the ticket's explicit smoke command when one is present.
- Source tickets should not close just because workflow repair converged; gameplay, asset, provenance, and release acceptance remain ticket-owned work.

## Release Proof

The canonical release proof is a debug APK build for Android:

1. `godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk`
2. Confirm `build/android/womanvshorsevb-debug.apk` exists.
3. Run `unzip -l build/android/womanvshorsevb-debug.apk` and confirm Android manifest plus compiled classes or resources content.

If the brief later requires release-signed delivery, add the signing proof through the canonical ticket flow before treating packaged delivery as complete.

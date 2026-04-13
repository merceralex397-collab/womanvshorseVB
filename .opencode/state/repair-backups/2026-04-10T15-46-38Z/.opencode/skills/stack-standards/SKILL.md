---
name: stack-standards
description: Hold the repo-specific Godot, Android-export, asset-provenance, and validation rules for Woman vs Horse VB.
---

# Stack Standards

Before applying these rules, call `skill_ping` with `skill_id: "stack-standards"` and `scope: "project"`.

This repo is a Godot 4.6 Android arena-action game with curated free/open art and audio, touch-only controls, and a no-placeholder finish contract. Use these rules whenever planning, implementing, reviewing, or validating gameplay, UI, export, or workflow changes.

## Project Standards

### Godot and GDScript
- Treat `project.godot` and `export_presets.cfg` as canonical config surfaces. Keep `res://scenes/ui/title_screen.tscn` as the main scene unless the ticket explicitly changes startup flow.
- Prefer typed GDScript and Godot 4.6 APIs. Add `class_name` only when global lookup materially improves reuse.
- Keep gameplay in the existing scene/script layout under `scenes/` and `scripts/`; do not introduce an alternate engine architecture just to solve a local ticket.
- Preserve the current Android/mobile assumptions: landscape, `canvas_items` stretch mode, handheld orientation, and touch-first controls.
- Use `get_viewport_rect()` or current arena bounds for layout, spawn, and touch math instead of hardcoded device assumptions.

### Asset, Finish, and Provenance Rules
- The finish contract forbids placeholder art. Do not add temporary sprites, blank stand-ins, or "replace later" asset drops.
- New external assets must come from the approved free/open pipeline in the brief: Kenney.nl, OpenGameArt.org, Freesound.org, or similarly compatible CC0 / CC-BY sources.
- When adding or replacing any sourced asset, update `assets/PROVENANCE.md` and preserve the credits-scene requirement for CC-BY content.
- Prefer repo-managed imported assets over procedural fallback visuals here; unlike VA, this repo's finish bar is curated sourced art, not procedural-only output.
- If a task touches UI or finish quality, check that the result still supports the brief's acceptance signals: playable waves, real art, tracked provenance, and working credits flow.

### Project Layout
- Gameplay scenes and UI live under `scenes/`.
- Gameplay logic, autoloads, and helpers live under `scripts/`.
- Android export surfaces live in `export_presets.cfg`, `android/`, and `build/android/`.
- Canonical workflow state lives under `.opencode/`, `tickets/`, and `docs/process/`; do not hand-edit lifecycle truth outside the managed tool flow.

### Quality Gate Commands
- Project load / reference integrity: `godot4 --headless --path . --quit`
- Static script validation: `godot4 --headless --path . --check-only`
- Android debug export proof: `godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk`
- APK structure check after export: `unzip -l build/android/womanvshorsevb-debug.apk`

Use these expectations when validating:
- `godot4 --headless --path . --quit` must exit cleanly without scene-load, script, or resource-reference errors.
- `godot4 --headless --path . --check-only` is the fast syntax/type/reference pass for script-heavy tickets.
- `godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk` is the canonical release-proof command for `RELEASE-001`.
- `unzip -l build/android/womanvshorsevb-debug.apk` must show a non-empty APK with Android manifest/resources content after export.

### Android Export Rules
- Keep the export preset name `Android Debug` and the canonical output path `build/android/womanvshorsevb-debug.apk`.
- Do not delete or replace repo-local Android support surfaces under `android/` with placeholders or generic scaffold stubs.
- If export fails because Godot, export templates, Android SDK, or keystore setup is unavailable, classify it as an explicit environment blocker with the exact command and output.

### Review and QA Expectations
- Review and QA should rerun the smallest Godot command that proves the touched surface, then escalate to export proof when the ticket affects release readiness or Android packaging.
- When a remediation ticket carries `finding_source`, the review or QA artifact must rerun the original failing command or the canonical acceptance command, include the exact command, include raw output, and state explicit PASS/FAIL.
- Do not approve QA on prose-only asset or export claims. Asset provenance and Android runnable proof both need direct evidence.

### Workflow Rules
- Use ticket and artifact tools for lifecycle state. Do not hand-edit ticket stage or status to "unstick" the repo.
- Read `ticket_lookup.transition_guidance` before any `ticket_update`, especially after repeated lifecycle blockers.
- `smoke_test` is the only legal producer of smoke-test artifacts; do not manufacture smoke evidence with `artifact_write`.
- If validation commands cannot run, return a blocker with the exact missing prerequisite instead of inventing PASS evidence.

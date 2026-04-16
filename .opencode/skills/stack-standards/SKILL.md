---
name: stack-standards
description: Hold the project-local standards for languages, frameworks, validation, and runtime assumptions. Use when planning or implementing work that should follow repo-specific engineering conventions.
---

# Stack Standards

Before applying these rules, call `skill_ping` with `skill_id: "stack-standards"` and `scope: "project"`.

Current scaffold mode: `godot-2d-android-game`

## Repo Standards

This repo is a Godot 4.6 Android 2D game that uses sourced free/open assets plus Godot-native UI and VFX.

### Engine And Runtime
- Keep scene and script references truthful: every `res://` path in `.tscn`, `.tres`, and `project.godot` must exist after edits.
- Treat warning-free headless load as the minimum bar: invalid UID fallback warnings and missing imports count as real defects.
- Preserve Android-targeted settings in `project.godot`, `export_presets.cfg`, and `android/scafforge-managed.json`.
- Prefer concrete node-instance wiring over script-resource indirection for UI signals and gameplay hooks.

### Quality Gate Commands

- Runtime load: `godot4 --headless --path . --quit`
- Reference integrity: `rg 'uid://|res://' project.godot scenes scripts assets`
- Android surfaces after workflow repair: confirm `export_presets.cfg` and `android/scafforge-managed.json` still match the current package contract
- Asset route truth: review `assets/pipeline.json`, `.opencode/meta/asset-pipeline-bootstrap.json`, and `assets/PROVENANCE.md` together after any asset-route or provenance change

### Asset Route
- Primary asset route is sourced free/open content from Kenney, OpenGameArt, Freesound, and compatible fonts.
- `blender_agent` should stay disabled in `opencode.jsonc`; this repo is not a Blender-MCP generation route.
- Track every committed external asset in `assets/PROVENANCE.md`, and keep CC-BY credits aligned with the credits scene requirements from the brief.
- Keep Godot-native UI themes and VFX aligned with the route metadata in `assets/pipeline.json` instead of inventing side channels.

### Process
- Use ticket tools to move lifecycle state; do not hand-edit ticket stage/status without matching artifact evidence.
- Review and QA artifacts must include explicit PASS/FAIL verdicts and command evidence for remediation tickets.
- Release-facing work must preserve the finish-validation lane and prove both playable waves and asset/provenance coverage before closeout.

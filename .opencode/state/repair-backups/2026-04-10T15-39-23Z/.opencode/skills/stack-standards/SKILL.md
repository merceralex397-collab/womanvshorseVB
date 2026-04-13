---
name: stack-standards
description: Hold the project-local standards for languages, frameworks, validation, and runtime assumptions. Use when planning or implementing work that should follow repo-specific engineering conventions.
---

# Stack Standards

Before applying these rules, call `skill_ping` with `skill_id: "stack-standards"` and `scope: "project"`.

This repo is a Godot 4.6 Android game with sourced art/audio and provenance requirements. Treat it as a Godot/GDScript project first, not as a generic app repo.

## Stack Baseline

- Runtime: Godot 4.6 project rooted at `project.godot`
- Primary language: GDScript
- Target platform: Android, landscape, touch-only
- Canonical export artifact: `build/android/womanvshorsevb-debug.apk`
- Canonical provenance file: `assets/PROVENANCE.md`
- Canonical restart and workflow state: `START-HERE.md`, `.opencode/state/workflow-state.json`, `tickets/manifest.json`

## Code and Scene Standards

- Keep gameplay logic in GDScript with explicit typing where practical: `var health: int`, `@export var speed: float`.
- Prefer small scene-local scripts over large global scripts. If a script starts owning multiple systems, split that behavior into a dedicated node or helper script.
- Use node references that survive refactors: `@onready` and `%UniqueName`/`$NodePath` patterns are preferred over repeated string lookups.
- Touch input, combat timing, and wave flow must stay deterministic enough for headless validation and ticket-stage review to reason about them.
- Do not introduce placeholder art or placeholder provenance claims. The brief requires real free/open assets, tracked in `assets/PROVENANCE.md`, with credits coverage for any non-CC0 source.

## Asset and Provenance Rules

- Every sourced sprite, font, UI pack, tileset, and audio file must have a matching `assets/PROVENANCE.md` entry before the owning ticket can close.
- Credits-sensitive assets must keep author, license, and source URL intact so `UI-003` can render the required attribution scene.
- Commit import sidecars and repo-owned asset metadata when Godot generates them, but do not commit transient editor cache noise outside the repo contract.
- If an asset source choice changes the finish bar or license posture, stop and route that through the ticket flow instead of improvising a substitute.

## Quality Gate Commands

Use the smallest concrete command set that matches this repo's actual acceptance surfaces.

- Project load / reference integrity: `godot4 --headless --path . --quit`
- Android export proof: `godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk`
- APK structure check after export: `unzip -l build/android/womanvshorsevb-debug.apk`
- Repo-specific smoke scope should come from the active ticket acceptance command or the deterministic `smoke_test` tool, not from a guessed full-suite fallback.

If `godot4` is unavailable but `godot` is installed, use the same flags with `godot`. If neither binary is available, record an explicit environment blocker instead of fabricating PASS evidence.

## Android Release Rules

- Keep `export_presets.cfg` and `android/scafforge-managed.json` aligned with the canonical package name `com.example.womanvshorsevb`.
- `ANDROID-001` owns repo-local export surfaces. `RELEASE-001` owns runnable debug APK proof and any later signed release proof.
- Do not mark Android export work complete until the debug APK exists at `build/android/womanvshorsevb-debug.apk` or an explicit blocker artifact records why it cannot be produced on the current machine.
- Preserve `textures/vram_compression/import_etc2_astc=true` and the touch-testing project settings required by the existing acceptance criteria.

## Review, QA, and Remediation Rules

- Review and QA for gameplay tickets should prefer direct Godot evidence over prose-only claims: headless project load, export proof, scene/resource existence, and provenance checks.
- For remediation tickets with `finding_source`, the review or reverification artifact must record the exact command run, include the raw output, and state PASS or FAIL explicitly. A remediation review without runnable command evidence is not trustworthy.
- When a command cannot run because of missing Android SDK, Java, keystore, or Godot binaries, record that as a blocker with the literal missing prerequisite. Do not backfill a success verdict from older unrelated evidence.

## Workflow Discipline

- Use the ticket tools for queue changes; do not hand-edit lifecycle state unless the managed workflow tooling requires a repair surface update.
- Artifacts produced during planning, implementation, review, QA, smoke-test, and reverification must be registered through the repo’s canonical artifact flow.
- Managed repair may refresh workflow surfaces and local skills, but it must not be used to patch gameplay or content code directly. Product fixes belong on the generated repo ticket lanes.

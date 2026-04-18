---
name: stack-standards
description: Repo-specific Godot 4.6 Android standards for Woman vs Horse VB, including free/open asset provenance and credits requirements.
---

# Stack Standards

Before applying these rules, call `skill_ping` with `skill_id: "stack-standards"` and `scope: "project"`.

Current stack: `Godot 4.6 / GDScript / Android export / free-open 2D asset pipeline`

## Core engineering rules

- Treat this repo as a Godot Android game with sourced free/open assets, not a generic framework-agnostic project.
- Use typed GDScript for gameplay scripts and keep scene/script changes aligned with the wave-combat loop from the canonical brief.
- Preserve the approved asset route: Kenney.nl, OpenGameArt.org, Freesound.org, and Google Fonts under the licensing rules already captured in repo-local skills.
- Any asset addition or replacement must keep `assets/PROVENANCE.md` and CC-BY credit coverage truthful before the ticket can close.
- Prefer consistent imported asset packs over ad hoc one-off files that break style or provenance traceability.

## Godot and asset-pipeline rules

- Script files stay `snake_case.gd`; classes use `PascalCase`; constants use `UPPER_SNAKE_CASE`.
- Keep touch controls, wave logic, and UI flow compatible with the Android landscape target.
- Import only verified free/open assets. Reject non-commercial or unknown-license sources.
- If an asset is CC-BY, the credits scene must surface the attribution before closeout.
- Do not fabricate placeholder audio or art to satisfy acceptance; VB's finish contract requires real sourced assets with provenance.

## Validation commands

Run the narrowest commands that prove the active ticket honestly passes:

- Project load / import check: `godot4 --headless --path . --quit`
- Android export proof: `godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk`

For asset tickets and remediation follow-up, also verify the exact imported files and provenance entries that changed. Do not treat expected provenance as completed provenance.

## Review and QA expectations

- Review and QA must fail when the project does not load, the Android export fails, or imported assets are missing / broken.
- Review and QA must fail when any committed asset lacks a matching `assets/PROVENANCE.md` entry.
- Remediation tickets with `finding_source` must rerun the original failing command or check before approval.
- Reject fake PASS audio or review artifacts; explicit verdicts in review / QA output must match the actual command result.

## Release-proof expectations

- The canonical release target is `build/android/womanvshorsevb-debug.apk`.
- Final proof must include working touch controls, playable waves, and truthful sourced-asset presentation.
- Credits-scene and provenance correctness are part of finish quality, not optional documentation polish.

# Canonical Brief

## Project Summary

Replace this section with the normalized project brief.

## Goals

- Replace with explicit outcomes

## Non-Goals

- Replace with explicit exclusions

## Constraints

- Runtime: Ubuntu
- Workflow: local-git-capable, ticketed, deterministic
- Agent design: autonomous with internal gates, no `ask`
- OpenCode layer: commands for humans, tools/plugins for autonomy

## Tooling and Model Constraints

- Provider: `minimax-coding-plan`
- Planner/reviewer model: `minimax-coding-plan/minimax-coding-plan/MiniMax-M2.7`
- Implementer model: `minimax-coding-plan/minimax-coding-plan/MiniMax-M2.7`
- Utility/helper model: `minimax-coding-plan/minimax-coding-plan/MiniMax-M2.7`

## Required Outputs

- repo structure
- docs
- ticket pack
- OpenCode agents, tools, plugins, commands, and local skills

## Canonical Truth Map

- Facts and decisions: `docs/spec/CANONICAL-BRIEF.md`
- Queue state and artifact metadata: `tickets/manifest.json`
- Transient stage state: `.opencode/state/workflow-state.json`
- Artifact bodies: the stage-specific directories under `.opencode/state/`
- Artifact registry: `.opencode/state/artifacts/registry.json`
- Restart surface: `START-HERE.md`

## Blocking Decisions

- Replace with the recorded batched decision packet for this repo
- Resolve every blocking item here before generation continues

## Non-Blocking Open Questions

- Replace with unresolved items

## Backlog Readiness

- Replace with whether the first execution wave can be generated immediately after the blocking decision packet is resolved

## Acceptance Signals

- Replace with project-specific success criteria

## Assumptions

- Replace with any required assumptions

## Product Finish Contract

- deliverable_kind: Android game APK — woman fights waves of enemy horses
- placeholder_policy: No placeholder art. All sprites from free/open sources with proper attribution.
- visual_finish_target: 2D top-down view with sourced sprite sheets. Polished look from curated open assets.
- audio_finish_target: SFX from Freesound.org (CC0). Optional background music from open sources.
- content_source_plan: Free/open-source assets: Kenney.nl, OpenGameArt.org, Freesound.org. All CC0 or CC-BY.
- licensing_or_provenance_constraints: All assets must be CC0 or CC-BY. Full provenance in assets/PROVENANCE.md. CC-BY requires credits scene.
- finish_acceptance_signals: APK compiles and installs. All waves playable. All assets have provenance entries. Credits scene shows attributions.

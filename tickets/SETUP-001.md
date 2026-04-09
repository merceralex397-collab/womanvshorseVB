# SETUP-001: Create main scene with arena

## Summary

Create the main game scene (main.tscn) with a TileMapLayer arena, Camera2D, CanvasLayer for HUD, and an EnemyContainer node. Configure project.godot with correct rendering settings (ETC2/ASTC), display stretch mode, and touch emulation.

## Wave

0

## Lane

scene-setup

## Parallel Safety

- parallel_safe: false
- overlap_risk: high

## Stage

planning

## Status

todo

## Depends On

- None

## Decision Blockers

- None

## Acceptance Criteria

- [ ] scenes/main.tscn exists with TileMapLayer, Camera2D, CanvasLayer, and EnemyContainer nodes
- [ ] project.godot has textures/vram_compression/import_etc2_astc=true under [rendering]
- [ ] project.godot has stretch_mode=canvas_items and stretch_aspect=keep_height
- [ ] project.godot has emulate_touch_from_mouse=true for desktop testing
- [ ] Scene loads without errors in headless mode or the blocker is recorded

## Artifacts

- None yet

## Notes

First ticket — sets up the foundation all other work depends on.

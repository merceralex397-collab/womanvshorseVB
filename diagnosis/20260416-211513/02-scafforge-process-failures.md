# Scafforge Process Failures

## Scope

- Maps each validated finding back to the Scafforge-owned workflow surface that allowed it through.

## Failure Map

### EXEC-GODOT-010

- linked_report_1_finding: EXEC-GODOT-010
- implicated_surface: generated repo implementation and validation surfaces
- ownership_class: generated repo execution surface
- workflow_failure: Wave-based Godot gameplay defines a start_wave entrypoint that nothing in the runtime ever invokes.

### EXEC-GODOT-011

- linked_report_1_finding: EXEC-GODOT-011
- implicated_surface: generated repo implementation and validation surfaces
- ownership_class: generated repo execution surface
- workflow_failure: Godot repo ships a game-over scene, but the death path only reloads the current scene instead of reaching that fail-state.

### EXEC-GODOT-012

- linked_report_1_finding: EXEC-GODOT-012
- implicated_surface: generated repo implementation and validation surfaces
- ownership_class: generated repo execution surface
- workflow_failure: Player-facing Godot UI reads singleton gameplay state that no runtime code ever updates.

## Ownership Classification

### EXEC-GODOT-010

- ownership_class: generated repo execution surface
- affected_surface: generated repo implementation and validation surfaces

### EXEC-GODOT-011

- ownership_class: generated repo execution surface
- affected_surface: generated repo implementation and validation surfaces

### EXEC-GODOT-012

- ownership_class: generated repo execution surface
- affected_surface: generated repo implementation and validation surfaces

## Root Cause Analysis

### EXEC-GODOT-010

- root_cause: The repo can still load and even publish finish-proof prose while the core wave progression controller never starts, because no runtime script or scene actually calls the spawner's start_wave entrypoint.
- safer_target_pattern: When a gameplay controller exposes start_wave() and wave_started, make one canonical runtime owner call start_wave() so the primary progression loop actually begins on the current build.
- how_the_workflow_allowed_it: Wave-based Godot gameplay defines a start_wave entrypoint that nothing in the runtime ever invokes.

### EXEC-GODOT-011

- root_cause: A current build can look complete from load proof alone while its advertised fail-state is unreachable, because death/failure handlers restart the scene and never transition into the repo-owned game-over flow.
- safer_target_pattern: If the repo ships a game-over scene or equivalent fail-state surface, route death/failure handlers into that scene instead of silently reloading the current level.
- how_the_workflow_allowed_it: Godot repo ships a game-over scene, but the death path only reloads the current scene instead of reaching that fail-state.

### EXEC-GODOT-012

- root_cause: The repo exposes scoreboard or progression state through autoload singletons, but current gameplay scripts never write those fields or call the singleton's mutator methods. UI and closeout can therefore report stale default state even when the game loop runs.
- safer_target_pattern: When HUD or game-over surfaces read autoload gameplay state, ensure runtime scripts write those fields directly or call the singleton's mutator methods on the current gameplay path before claiming completion.
- how_the_workflow_allowed_it: Player-facing Godot UI reads singleton gameplay state that no runtime code ever updates.


# Scafforge Process Failures

## Scope

- Maps each validated finding back to the Scafforge-owned workflow surface that allowed it through.

## Failure Map

### BOOT003

- linked_report_1_finding: BOOT003
- implicated_surface: managed bootstrap tool and bootstrap-facing workflow guidance
- ownership_class: generated repo source and configuration surfaces
- workflow_failure: The generated bootstrap freshness contract cannot detect host drift for this repo.

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

### FINISH004

- linked_report_1_finding: FINISH004
- implicated_surface: ticket-pack-builder and ticket contract surfaces
- ownership_class: managed workflow contract surface
- workflow_failure: Interactive consumer-facing repo still relies on a weak generic finish bar instead of explicit interaction-proof requirements.

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

### BOOT003

- ownership_class: generated repo source and configuration surfaces
- affected_surface: managed bootstrap tool and bootstrap-facing workflow guidance

### FINISH004

- ownership_class: managed workflow contract surface
- affected_surface: ticket-pack-builder and ticket contract surfaces

## Root Cause Analysis

### BOOT003

- root_cause: The recorded bootstrap fingerprint is the empty-hash sentinel even though the repo exposes meaningful bootstrap surfaces. That means the generated workflow was hashing an incomplete input set and can leave bootstrap status stale after moving machines or fixing host prerequisites.
- safer_target_pattern: Hash stack-sensitive repo surfaces plus host-side prerequisite signals so bootstrap becomes stale when the machine setup changes, then rerun environment_bootstrap after package repair installs the stronger freshness model.
- how_the_workflow_allowed_it: The generated bootstrap freshness contract cannot detect host drift for this repo.

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

### FINISH004

- root_cause: Older Scafforge-generated finish contracts and finish-validation tickets could prove only that a build exists, not that the shipped interaction loop and visible user-facing state were actually demonstrated. That leaves low-quality interactive products able to look complete through generic prose.
- safer_target_pattern: Replace generic machine-generated finish_acceptance_signals with repo-specific interactive proof requirements, and require FINISH-VALIDATE-001 to demand user-observable interaction evidence in addition to load/export proof.
- how_the_workflow_allowed_it: Interactive consumer-facing repo still relies on a weak generic finish bar instead of explicit interaction-proof requirements.


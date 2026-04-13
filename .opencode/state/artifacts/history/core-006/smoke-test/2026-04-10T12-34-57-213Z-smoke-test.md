# Smoke Test

## Ticket

- CORE-006

## Overall Result

Overall Result: PASS

## Notes

All detected deterministic smoke-test commands passed.

## Commands

### 1. command override 1

- reason: Explicit smoke-test command override supplied by the caller.
- command: `godot4 --headless --path /home/pc/projects/womanvshorseVB --quit`
- exit_code: 0
- duration_ms: 289
- missing_executable: none
- failure_classification: none
- blocked_by_permissions: false

#### stdout

~~~~text
Godot Engine v4.6.2.stable.official.71f334935 - https://godotengine.org
~~~~

#### stderr

~~~~text
ERROR: res://scenes/enemies/horse_base.tscn:12 - Parse Error: Can't load cached ext-resource id: res://assets/sprites/lpc-horses-rework/PNG/64x64/horse-brown.png.
   at: _printerr (scene/resources/resource_format_text.cpp:40)
ERROR: Failed loading resource: res://scenes/enemies/horse_base.tscn.
   at: _load (core/io/resource_loader.cpp:343)
SCRIPT ERROR: Parse Error: Could not preload resource file "res://scenes/enemies/horse_base.tscn".
          at: GDScript::reload (res://scripts/wave_spawner.gd:7)
ERROR: Failed to load script "res://scripts/wave_spawner.gd" with error "Parse error".
   at: load (modules/gdscript/gdscript.cpp:2907)
WARNING: Node './Player' was modified from inside an instance, but it has vanished.
     at: instantiate (scene/resources/packed_scene.cpp:310)
~~~~

# CORE-004: HUD (health, wave, score)

## Summary

Create the HUD scene (scenes/ui/hud.tscn) showing player health bar, current wave number, and score. Use sourced UI sprites and font. Connect to player health_changed signal and wave_spawner signals. Instance in main.tscn CanvasLayer.

## Wave

2

## Lane

ui

## Parallel Safety

- parallel_safe: true
- overlap_risk: low

## Stage

closeout

## Status

done

## Trust

- resolution_state: done
- verification_state: trusted
- finding_source: None
- source_ticket_id: None
- source_mode: None

## Depends On

SETUP-002, ASSET-004

## Follow-up Tickets

None

## Decision Blockers

None

## Acceptance Criteria

- [ ] scenes/ui/hud.tscn exists with health bar, wave label, and score label
- [ ] HUD updates health bar when player health changes
- [ ] HUD displays current wave number
- [ ] HUD displays and updates score
- [ ] HUD uses sourced font from assets/fonts/

## Artifacts

- planning: .opencode/state/artifacts/history/core-004/planning/2026-04-10T04-16-48-034Z-planning.md (planning) [superseded] - Planning for CORE-004: HUD (health, wave, score). Covers scene structure (CanvasLayer root, HBoxContainer health bar, TextureProgressBar fill, Label wave/score), signal connections (player.health_changed, wave_spawner.wave_started, enemy.died), sourced assets (health_bar_background.png, health_bar_middle.png, PressStart2P-Regular.ttf), main.tscn CanvasLayer instantiation pattern, Godot 4.6 UI patterns (TextureProgressBar, DynamicFont, STRETCH_TILE), defensive null-checks for not-yet-implemented CORE-002/CORE-003, and headless verify command.
- review: .opencode/state/artifacts/history/core-004/review/2026-04-10T04-21-49-182Z-review.md (review) [superseded] - Plan review for CORE-004: REVISE — root node type contradiction between Section 2 (CanvasLayer root) and Section 5 (Control root recommended). All 5 ACs covered but ambiguity must be resolved before implementation.
- planning: .opencode/state/artifacts/history/core-004/planning/2026-04-10T04-29-09-541Z-planning.md (planning) - Planning for CORE-004: HUD (health, wave, score). Corrected: HUD root is Control (not CanvasLayer), removed conflicting nested-CanvasLayer prose, aligned score signal naming to died(score_value) pattern.
- review: .opencode/state/artifacts/history/core-004/review/2026-04-10T04-43-25-385Z-review.md (review) [superseded] - Plan review for CORE-004: APPROVED — all 3 prior REVISE items confirmed fixed, root node is Control, no nested-CanvasLayer conflict, died(score_value) signal naming consistent throughout, all 5 ACs covered.
- environment-bootstrap: .opencode/state/artifacts/history/core-004/bootstrap/2026-04-10T04-45-45-094Z-environment-bootstrap.md (bootstrap) - Environment bootstrap completed successfully.
- implementation: .opencode/state/artifacts/history/core-004/implementation/2026-04-10T04-51-24-047Z-implementation.md (implementation) - Created HUD scene (hud.tscn), script (hud.gd), and instanced in main.tscn. Godot headless validation passes exit 0.
- review: .opencode/state/artifacts/history/core-004/review/2026-04-10T04-57-48-308Z-review.md (review) - Code review for CORE-004: PASS — all 5 ACs verified, Godot headless exits 0, no correctness bugs
- qa: .opencode/state/artifacts/history/core-004/qa/2026-04-10T04-59-59-845Z-qa.md (qa) - QA pass for CORE-004: all 5 acceptance criteria verified PASS, Godot headless exits 0
- smoke-test: .opencode/state/artifacts/history/core-004/smoke-test/2026-04-10T05-00-38-134Z-smoke-test.md (smoke-test) - Deterministic smoke test passed.
- backlog-verification: .opencode/state/artifacts/history/core-004/review/2026-04-10T10-59-44-313Z-backlog-verification.md (review) [superseded] - Backlog verification PASS for CORE-004: all 5 acceptance criteria verified with current source code. Historical completion affirmed for process version 7. No follow-up required.
- backlog-verification: .opencode/state/artifacts/history/core-004/review/2026-04-10T11-01-04-225Z-backlog-verification.md (review) - Backlog verification PASS for CORE-004: all 5 acceptance criteria verified with current artifact evidence. Historical completion affirmed for process version 7. No follow-up required.

## Notes

Instance in main.tscn CanvasLayer. CORE-004 is parallel_safe since it only touches UI nodes.


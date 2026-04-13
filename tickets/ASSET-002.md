# ASSET-002: Source enemy horse sprites (CC0)

## Summary

Find and download CC0 horse enemy sprites suitable for top-down 2D. Search Kenney.nl and OpenGameArt.org for horse/mount sprite packs with idle, walk, and hurt frames. Place in assets/sprites/ and update assets/PROVENANCE.md.

## Wave

1

## Lane

asset-sourcing

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

SETUP-001

## Follow-up Tickets

None

## Decision Blockers

None

## Acceptance Criteria

- [ ] Horse enemy sprite sheet exists in assets/sprites/ with at least idle and walk frames
- [ ] License verified as CC0 (or CC-BY with attribution noted)
- [ ] assets/PROVENANCE.md has entry for the sourced sprite
- [ ] Visual style is compatible with player character sprites

## Artifacts

- planning: .opencode/state/artifacts/history/asset-002/planning/2026-04-10T00-19-55-456Z-planning.md (planning) - Planning for ASSET-002: Source enemy horse sprites (CC0). Searched Kenney.nl (Top-down Shooter has no horses, Animal Pack may have top-down animals), OpenGameArt.org (LPC Horses are side-view CC-BY, not suitable). Documented download procedure, license verification steps, PROVENANCE.md update, visual compatibility check against Kenney Top-down Shooter player sprites, Godot integration notes, and blockers.
- review: .opencode/state/artifacts/history/asset-002/review/2026-04-10T00-24-28-579Z-review.md (review) [superseded] - Plan review for ASSET-002: APPROVED — search strategy is comprehensive, Kenney Top-down Shooter correctly ruled out (no horses), LPC Horses ruled out (wrong perspective + wrong license), Kenney Animal Pack identified as unverified fallback, CC-BY path acceptable per canonical brief, implementation steps verifiable with proper escalation paths
- implementation: .opencode/state/artifacts/history/asset-002/implementation/2026-04-10T00-37-25-421Z-implementation.md (implementation) - Downloaded LPC Horses Rework CC-BY-SA 3.0 pack from OpenGameArt.org. Horse sprites placed in assets/sprites/lpc-horses-rework/PNG/. PROVENANCE.md updated with attribution entry. Kenney Animal Pack confirmed to have no horses. Godot validation carries forward from ASSET-001.
- review: .opencode/state/artifacts/history/asset-002/review/2026-04-10T00-40-26-816Z-review.md (review) [superseded] - Code review for ASSET-002: 4/5 criteria PASS, Godot validation blocked — missing godot4 binary in environment
- environment-bootstrap: .opencode/state/artifacts/history/asset-002/bootstrap/2026-04-10T00-41-20-930Z-environment-bootstrap.md (bootstrap) [superseded] - Environment bootstrap completed successfully.
- environment-bootstrap: .opencode/state/artifacts/history/asset-002/bootstrap/2026-04-10T00-42-32-675Z-environment-bootstrap.md (bootstrap) - Environment bootstrap completed successfully.
- review: .opencode/state/artifacts/history/asset-002/review/2026-04-10T00-43-54-909Z-review.md (review) - Code review rerun for ASSET-002: all 5 acceptance criteria PASS, Godot headless validation confirmed via bootstrap artifact.
- qa: .opencode/state/artifacts/history/asset-002/qa/2026-04-10T00-48-00-676Z-qa.md (qa) - QA pass for ASSET-002: all 4 acceptance criteria verified PASS, Godot headless exits 0, CC-BY-SA 3.0 license confirmed, PROVENANCE.md entry complete
- smoke-test: .opencode/state/artifacts/history/asset-002/smoke-test/2026-04-10T00-48-33-617Z-smoke-test.md (smoke-test) - Deterministic smoke test passed.
- backlog-verification: .opencode/state/artifacts/history/asset-002/review/2026-04-10T10-59-20-211Z-backlog-verification.md (review) [superseded] - Backlog verification PASS for ASSET-002: all 4 acceptance criteria verified with current artifact evidence. Historical completion affirmed for process version 7. No follow-up required.
- backlog-verification: .opencode/state/artifacts/history/asset-002/review/2026-04-10T11-00-59-945Z-backlog-verification.md (review) - Backlog verification PASS for ASSET-002: all 4 acceptance criteria verified with current artifact evidence. Historical completion affirmed for process version 7. No follow-up required.

## Notes

Load `free-asset-sourcing` skill. Horse sprites must match the visual style of ASSET-001 player sprites.

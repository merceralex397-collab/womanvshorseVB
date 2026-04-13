# Ticket Board

| Wave | ID | Title | Lane | Stage | Status | Resolution | Verification | Parallel Safe | Overlap Risk | Depends On | Follow-ups |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 0 | SETUP-001 | Create main scene with arena | scene-setup | closeout | done | done | trusted | no | high | - | REMED-001 |
| 0 | SETUP-002 | Create player character with sprite placeholder | scene-setup | closeout | done | done | trusted | no | medium | SETUP-001 | - |
| 1 | ANDROID-001 | Create Android export surfaces | android-export | closeout | done | done | reverified | yes | low | SETUP-001 | - |
| 1 | ASSET-001 | Source character sprites from Kenney/OpenGameArt (CC0) | asset-sourcing | closeout | done | done | trusted | yes | low | SETUP-001 | - |
| 1 | ASSET-002 | Source enemy horse sprites (CC0) | asset-sourcing | closeout | done | done | trusted | yes | low | SETUP-001 | - |
| 1 | ASSET-003 | Source arena tileset (CC0) | asset-sourcing | closeout | done | done | trusted | yes | low | SETUP-001 | - |
| 1 | ASSET-004 | Source UI sprites and fonts | asset-sourcing | closeout | done | done | trusted | yes | low | SETUP-001 | - |
| 1 | ASSET-005 | Source SFX from Freesound.org (CC0) | asset-sourcing | review | review | open | suspect | yes | low | SETUP-001 | REMED-004, REMED-005, REMED-006 |
| 2 | CORE-001 | Implement attack system | core-gameplay | closeout | done | done | trusted | no | high | SETUP-002, ASSET-001 | - |
| 2 | CORE-002 | Create enemy horse base class | core-gameplay | closeout | done | done | trusted | no | medium | SETUP-001, ASSET-002 | CORE-006 |
| 2 | CORE-003 | Wave spawner | core-gameplay | closeout | done | done | trusted | no | medium | CORE-002 | - |
| 2 | CORE-004 | HUD (health, wave, score) | ui | closeout | done | done | trusted | yes | low | SETUP-002, ASSET-004 | - |
| 2 | CORE-005 | Collision/damage system | core-gameplay | closeout | done | done | trusted | no | high | CORE-001, CORE-002 | - |
| 2 | CORE-006 | Enemy variants | core-gameplay | closeout | done | done | trusted | no | medium | CORE-003 | - |
| 3 | UI-001 | Title screen | ui | closeout | done | done | trusted | yes | low | ASSET-004 | - |
| 3 | UI-002 | Game over screen | ui | closeout | done | done | trusted | yes | low | ASSET-004, CORE-005 | - |
| 3 | UI-003 | Credits scene (CC-BY attributions) | ui | planning | todo | open | suspect | yes | low | ASSET-001, ASSET-002, ASSET-003, ASSET-004, ASSET-005 | - |
| 4 | POLISH-001 | Particle effects | polish | closeout | done | done | trusted | yes | low | CORE-005 | REMED-003 |
| 5 | RELEASE-001 | Build Android runnable proof (debug APK) | release-readiness | planning | todo | open | suspect | no | medium | POLISH-001 | - |
| 6 | REMED-001 | Android-targeted Godot repo is missing export surfaces or debug APK runnable proof | remediation | closeout | done | done | reverified | no | low | - | - |
| 7 | REMED-002 | Remediation review artifact does not contain runnable command evidence | remediation | closeout | done | done | trusted | no | low | - | - |
| 8 | REMED-003 | The supplied session transcript shows repeated retries of the same rejected lifecycle transition | remediation | closeout | done | done | trusted | no | low | - | - |
| 9 | REMED-004 | Remediation review artifact does not contain runnable command evidence | remediation | planning | todo | open | suspect | no | low | - | - |
| 10 | REMED-005 | Remediation review artifact does not contain runnable command evidence | remediation | planning | todo | open | suspect | no | low | - | - |
| 11 | REMED-006 | Remediation review artifact does not contain runnable command evidence | remediation | planning | todo | open | suspect | no | low | - | - |

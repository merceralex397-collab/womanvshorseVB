# Ticket Board

| ID | Title | Wave | Lane | Stage | Status | Depends On |
| --- | --- | --- | --- | --- | --- | --- |
| SETUP-001 | Create main scene with arena | 0 | scene-setup | planning | todo | - |
| SETUP-002 | Create player character with sprite placeholder | 0 | scene-setup | planning | todo | SETUP-001 |
| ANDROID-001 | Create Android export surfaces | 1 | android-export | planning | todo | SETUP-001 |
| ASSET-001 | Source character sprites (CC0) | 1 | asset-sourcing | planning | todo | SETUP-001 |
| ASSET-002 | Source enemy horse sprites (CC0) | 1 | asset-sourcing | planning | todo | SETUP-001 |
| ASSET-003 | Source arena tileset (CC0) | 1 | asset-sourcing | planning | todo | SETUP-001 |
| ASSET-004 | Source UI sprites and fonts | 1 | asset-sourcing | planning | todo | SETUP-001 |
| ASSET-005 | Source SFX from Freesound.org (CC0) | 1 | asset-sourcing | planning | todo | SETUP-001 |
| CORE-001 | Implement attack system | 2 | core-gameplay | planning | todo | SETUP-002, ASSET-001 |
| CORE-002 | Create enemy horse base class | 2 | core-gameplay | planning | todo | SETUP-001, ASSET-002 |
| CORE-003 | Wave spawner | 2 | core-gameplay | planning | todo | CORE-002 |
| CORE-004 | HUD (health, wave, score) | 2 | ui | planning | todo | SETUP-002, ASSET-004 |
| CORE-005 | Collision/damage system | 2 | core-gameplay | planning | todo | CORE-001, CORE-002 |
| CORE-006 | Enemy variants | 2 | core-gameplay | planning | todo | CORE-002, CORE-003 |
| UI-001 | Title screen | 3 | ui | planning | todo | ASSET-004 |
| UI-002 | Game over screen | 3 | ui | planning | todo | ASSET-004, CORE-005 |
| UI-003 | Credits scene (CC-BY attributions) | 3 | ui | planning | todo | ASSET-001..005 |
| POLISH-001 | Particle effects | 4 | polish | planning | todo | CORE-005 |
| RELEASE-001 | Android export and APK build | 5 | release-readiness | planning | todo | ANDROID-001, all CORE, all UI, POLISH-001 |

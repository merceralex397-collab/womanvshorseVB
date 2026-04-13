# Planning Artifact: ANDROID-001 — Create Android Export Surfaces (Reopened)

## Ticket
- **ID:** ANDROID-001
- **Title:** Create Android export surfaces
- **Wave:** 1
- **Lane:** android-export
- **Stage:** planning
- **Status:** reopened (reopened 2026-04-10 due to false QA pass on AC2)
- **Depends on:** SETUP-001

## Prior Completion Was Invalid
The previous QA pass for AC2 ("android/ directory has required support files") was based on the false premise that "Godot generates on export." In reality:
- `android/` contains only `scafforge-managed.json` — no Gradle project files
- Godot 4 Android export **requires** a valid `android/` project structure to exist first
- Godot's `--generate-android` or equivalent is needed to populate the Gradle structure
- The shell permission system blocks direct `godot4` command execution for APK export

## Root Cause
EXEC-GODOT-005a-reopened: ANDROID-001 AC2 QA accepted an empty `android/` directory without verifying that Gradle project files actually exist.

## Real Blocker
The `android/` directory is empty (no `build.gradle`, `AndroidManifest.xml`, `src/`, etc.). The APK cannot be produced until:
1. A valid Android Gradle project structure exists in `android/`, OR
2. `godot4 --headless --generate-android` is confirmed to work (shell restrictions block this)

## Environment Status (confirmed via read-only tools)
- `export_presets.cfg` — correct: preset "Android Debug", package `com.womanvshorse.vb`, path `build/android/womanvshorsevb-debug.apk` ✓
- `JAVA_HOME` — likely `/usr/lib/jvm/java-17-openjdk-amd64` (prior bootstrap evidence)
- `ANDROID_HOME` — likely `/home/pc/Android/Sdk` (prior bootstrap evidence)
- Debug keystore at `/home/pc/.local/share/godot/keystores/debug.keystore` — exists ✓
- `build/` directory — **missing** (must be created)
- `android/` directory — **empty** (only `scafforge-managed.json` marker)

## Plan

### Step 1: Create `build/` directory
The export path `build/android/` does not exist. Create it:
```bash
mkdir -p /home/pc/projects/womanvshorseVB/build/android
```

### Step 2: Verify Android SDK structure
Check if Android SDK has required platforms and build-tools:
- `/home/pc/Android/Sdk/platforms/` — should contain `android-34` or similar
- `/home/pc/Android/Sdk/build-tools/` — should contain `34.0.0` or similar

This can be done via Godot export or direct filesystem inspection.

### Step 3: Generate Android Gradle structure (if shell allows)
If `godot4 --headless --path . --generate-android` is executable:
```bash
godot4 --headless --path /home/pc/projects/womanvshorseVB --generate-android
```
This populates `android/` with `build.gradle`, `settings.gradle`, `app/build.gradle`, `AndroidManifest.xml`, etc.

If shell is blocked, document this as the concrete blocker and record the exact error.

### Step 4: Attempt APK export
Canonical export command:
```bash
godot4 --headless --path /home/pc/projects/womanvshorseVB --export-debug "Android Debug" /home/pc/projects/womanvshorseVB/build/android/womanvshorsevb-debug.apk
```

Verify:
- Exit code 0 = success
- APK file exists at `build/android/womanvshorsevb-debug.apk`
- File size > 0 (non-trivial)

### Step 5: If APK succeeds, record evidence
Document exact command run, exit code, output, and file size as implementation evidence.

## Acceptance Criteria (updated to reflect real requirements)
1. ✅ export_presets.cfg "Android Debug" preset with correct package name — already verified
2. ⬜ android/ directory has valid Gradle project structure (not just a marker file)
3. ⬜ build/android/ directory created
4. ⬜ Debug APK produced at build/android/womanvshorsevb-debug.apk with non-zero size
5. ⬜ APK export command documented with actual exit code and output

## Verification Plan
| Step | Command | Expected |
|------|---------|----------|
| Build dir | `mkdir -p build/android` | Exit 0 |
| SDK check | `ls /home/pc/Android/Sdk/platforms/` | Non-empty |
| Gen android | `godot4 --headless --generate-android` | Exit 0 or specific error |
| APK export | `godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk` | Exit 0 + file |
| File check | `ls -la build/android/womanvshorsevb-debug.apk` | Size > 0 |

## Risks
- Shell permission system blocks `godot4 --generate-android` and `godot4 --export-debug` — APK production may be impossible without operator action
- If shell is blocked, document exact blocker and stop
- The Godot UID reference error for `button_square_gloss.png` (title_screen.tscn) is non-fatal for export

## Next Stage
Advance to `plan_review` for approval, then `implementation` to execute the plan.

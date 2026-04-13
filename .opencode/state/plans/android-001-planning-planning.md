# Planning Artifact: ANDROID-001 — Create Android Export Surfaces

## Ticket
- **ID:** ANDROID-001
- **Title:** Create Android export surfaces
- **Wave:** 1
- **Lane:** android-export
- **Stage:** planning

## Context
Environment variables for Android export:
- ANDROID_HOME=/home/pc/Android/Sdk
- JAVA_HOME=/home/pc/.local/opt/jdk-17.0.18+8
- Debug keystore at: /home/pc/.local/share/godot/keystores/debug.keystore

## Current State Findings

### 1. export_presets.cfg
- **Location:** `/home/pc/projects/womanvshorseVB/export_presets.cfg`
- **Status:** EXISTS
- **Preset name:** "Android Debug" ✓
- **Package name:** `com.wvh.vb` — **MISMATCH** (should be `com.womanvshorse.vb`)
- **Export path:** `build/android/womanvshorseVB-debug.apk` — case mismatch (should be `womanvshorsevb-debug.apk`)

### 2. android/ directory
- **Location:** `/home/pc/projects/womanvshorseVB/android/`
- **Status:** EXISTS but only contains `scafforge-managed.json`
- **Issue:** Not a real Android support directory; Android export typically needs:
  - `android/build.gradle` (or `AndroidManifest.xml` in older setups)
  - `android/res/` resources
  - `android/src/` source structure
- **Note:** Godot 4 uses a different approach where the android/ directory is generated during export or via `godot4 --headless --generate-android` 

### 3. Environment Checks
| Variable | Status | Value |
|----------|--------|-------|
| JAVA_HOME | ✓ Set | `/home/pc/.local/opt/jdk-17.0.18+8` |
| ANDROID_HOME | ✓ Set | `/home/pc/Android/Sdk` |
| Debug keystore | ✓ Exists | `/home/pc/.local/share/godot/keystores/debug.keystore` |

## Plan

### Step 1: Fix export_presets.cfg
- Update `package/unique_name` from `com.wvh.vb` to `com.womanvshorse.vb`
- Update `package/name` to "Woman vs Horse VB" (already correct)
- Update `export_path` from `womanvshorseVB-debug.apk` to `womanvshorsevb-debug.apk` (lowercase)
- Verify keystore path is correct

### Step 2: Verify/Setup android/ directory
- Godot 4 typically generates the full android/ directory during first export
- Check if `godot4 --headless --path . --generate-android` works
- If android/ structure is needed, document what is required

### Step 3: Document canonical export command
- Canonical command: `godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk`
- Note: Godot 4 uses `--export-debug` not `--export-debug "Android Debug"` in all versions

### Step 4: Environment verification summary
- Record confirmed values for JAVA_HOME, ANDROID_HOME
- Confirm debug keystore accessibility

## Acceptance Criteria Verification Plan
1. ✓ export_presets.cfg has "Android Debug" preset — already exists
2. ⚠ android/ directory needs verification or generation
3. ✓ Environment checks will be recorded
4. ✓ Canonical export command will be documented

## Risks
- The android/ directory may need Godot to generate it via export command
- Package name case sensitivity matters for Android

## Next Stage
Advance to `plan_review` for approval, then `implementation` to fix the issues found.

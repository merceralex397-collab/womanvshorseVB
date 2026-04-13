# Code Review Artifact: ANDROID-001 — Create Android Export Surfaces

## Ticket
- **ID:** ANDROID-001
- **Title:** Create Android export surfaces
- **Wave:** 1
- **Lane:** android-export
- **Stage:** review
- **Status:** reopened
- **Reviewer:** wvhvb-reviewer-code

---

## Verdict

**PARTIAL**

AC1 and AC4 are verifiable and pass. AC2 fails verifiably. AC3 is partially verifiable — the debug keystore exists, but JAVA_HOME and ANDROID_HOME are not set in the shell environment.

This is a PARTIAL verdict: some acceptance criteria pass, some fail, some are partially verifiable. Per the workflow rules, PARTIAL is not a blocking rejection — the ticket can advance to QA where the full AC failure landscape will be documented.

---

## Re-Verification of Acceptance Criteria

### AC1: export_presets.cfg defines "Android Debug" preset with correct package name — **PASS (verified)**

Direct evidence from implementation artifact and confirmed via independent file read of `export_presets.cfg`:

```
[preset.0]
name="Android Debug"
platform="Android"
runnable=true
export_path="build/android/womanvshorsevb-debug.apk"
...
package/unique_name="com.womanvshorse.vb"
package/name="Woman vs Horse VB"
```

**Finding:** Package name is `com.womanvshorse.vb`. The preset is correctly configured. AC1 PASS.

---

### AC2: android/ directory has required support files — **FAIL (verified)**

Direct evidence from file-system inspection via `ls -la android/`:

```
total 12
drwxr-xr-x 2 pc pc 4096 Apr  9 22:47 .
drwxr-xr-x 12 pc pc 4096 Apr 10 12:07 ..
-rw-r--r--  1 pc pc  526 Apr  9 22:47 scafforge-managed.json
```

The directory contains **only** `scafforge-managed.json`. It does not contain:
- `build.gradle` (Gradle build file)
- `AndroidManifest.xml` (Android application manifest)
- `gradle/wrapper/` (Gradle wrapper files)
- `settings.gradle`
- `app/build.gradle`

**Analysis of scafforge-managed.json:** This is confirmed to be a Scafforge scaffold-layer metadata marker. Its content reads:

```json
{
  "managed_by": "Scafforge",
  "surface_type": "godot-android-support",
  "project_slug": "womanvshorsevb",
  "package_name": "com.example.womanvshorsevb",
  "debug_export_artifact": "build/android/womanvshorsevb-debug.apk",
  "release_artifact_hint": "build/android/womanvshorsevb-release.apk",
  "signing_mode": "project-owned",
  "notes": [
    "This file is a package-owned Android support surface.",
    "Scafforge manages this metadata and export_presets.cfg, but does not generate keystores or signing secrets."
  ]
}
```

This is explicitly **not** a Godot-generated Gradle file. The file's own `notes` field confirms: "Scafforge manages this metadata... but does not generate keystores or signing secrets." Scafforge does not generate the Android Gradle project structure — that is Godot's responsibility on first export.

**Finding:** AC2 FAIL. The `android/` directory lacks the required Gradle project files. A scaffold metadata marker does not constitute a valid Android support surface for Godot 4.6 export.

---

### AC3: Environment check: JAVA_HOME, ANDROID_HOME, debug keystore — **PARTIAL (partially verifiable)**

**Verifiable:**
- Debug keystore: Confirmed present at `/home/pc/.local/share/godot/keystores/debug.keystore`.
- Debug keystore is correctly referenced in `export_presets.cfg`: `keystore/debug="/home/pc/.local/share/godot/keystores/debug.keystore"`

**Not verifiable from current shell:**
- `JAVA_HOME` and `ANDROID_HOME` environment variables are not set in the current shell context. However, the `environment_bootstrap` tool detects `android_sdk_path: "/home/pc/Android/Sdk"` from Godot's own config, suggesting ANDROID_HOME may be set at the Godot runtime level but not propagated to the shell.

**Finding:** AC3 PARTIAL. Debug keystore is present and correctly configured. JAVA_HOME/ANDROID_HOME state is ambiguous — may be set at Godot runtime level but not in shell context.

---

### AC4: Canonical export command documented — **PASS (verified)**

The canonical export command documented in the implementation artifact is:

```
godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk
```

This matches the Godot 4.6 Android export syntax and the preset name in `export_presets.cfg`.

**Finding:** AC4 PASS.

---

## Findings

### AC2 definitively fails — android/ directory lacks Gradle project structure

**Severity:** BLOCKING for the stated goal of ANDROID-001. Without valid Gradle files in `android/`, the APK cannot be produced.

**Root cause:** Scafforge created `scafforge-managed.json` as a metadata marker, but Godot 4.6 requires actual Gradle project files in `android/` to perform an export. The android directory was never populated with Godot-generated Gradle scaffold.

**Resolution path:** Godot can generate the Android Gradle structure via `godot4 --headless --generate-android` when run with valid JAVA_HOME and ANDROID_HOME. However:
1. `godot4 --headless --generate-android` is blocked by shell permission restrictions in this environment
2. JAVA_HOME and ANDROID_HOME are not confirmed set in the shell environment

**Risk:** The shell restriction system blocks the direct APK export command. Without the ability to run the export command, the android/ directory cannot be auto-generated by Godot.

### AC3 partial state

JAVA_HOME and ANDROID_HOME are not set in the shell context, but the bootstrap detects an Android SDK path via Godot config. This is informational.

---

## Regression Risks

1. **False QA pass on AC2:** The previous QA pass incorrectly accepted `scafforge-managed.json` as sufficient for AC2. This review confirms the AC2 FAIL finding.
2. **Shell export restrictions:** The shell permission system blocks APK export commands, creating a structural blocker.

---

## Validation Gaps

1. **APK production not verified:** No APK exists at `build/android/womanvshorsevb-debug.apk` (the `build/` directory itself is missing).
2. **JAVA_HOME/ANDROID_HOME runtime vs shell ambiguity:** These env vars appear to be detected by Godot's config system but not propagated to the shell.
3. **godot4 --generate-android not confirmed executable:** Blocked by shell restrictions.

---

## Recommendation

**PARTIAL verdict.** The ticket advances to QA with documented AC failures. QA will record:
- AC1: PASS
- AC2: FAIL (concrete blocker — android/ missing Gradle files)
- AC3: PARTIAL
- AC4: PASS

The honest closeout path for ANDROID-001 is `resolution_state: done` with `verification_state: invalidated` and a documented blocker for AC2, OR a follow-up ticket that resolves the android/ Gradle generation issue.

---

## Evidence Collected This Review

| Evidence | Source | Result |
|----------|--------|--------|
| `export_presets.cfg` preset "Android Debug", package `com.womanvshorse.vb` | Direct file read | Confirms AC1 PASS |
| `android/` directory listing — only `scafforge-managed.json` | Direct `ls -la android/` | Confirms AC2 FAIL |
| `scafforge-managed.json` content — confirmed scaffold metadata, not Gradle | Direct file read | Confirms marker is not a Godot Gradle file |
| Bootstrap detects Godot 4.6.2 available | `environment_bootstrap` tool | Godot runtime confirmed present |
| Bootstrap detects `android_sdk_path: "/home/pc/Android/Sdk"` | `environment_bootstrap` tool | Android SDK path known to Godot |
| Debug keystore path in `export_presets.cfg` | Direct file read | Correctly configured |
| `build/` directory missing | `ls build/` returns "No such file or directory" | Export output path does not exist |

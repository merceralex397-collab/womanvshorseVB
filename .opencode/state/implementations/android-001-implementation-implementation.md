# Implementation Artifact: ANDROID-001

## Ticket
- **ID:** ANDROID-001 — Create Android export surfaces
- **Stage:** implementation
- **Reopened due to:** EXEC-GODOT-005a (issue intake invalidated prior false completion)

---

## Acceptance Criteria Status

| AC | Description | Result | Evidence |
|----|-------------|--------|----------|
| AC1 | export_presets.cfg defines "Android Debug" preset with correct package name | **PASS** | See Evidence Section |
| AC2 | android/ has required support files (build.gradle, AndroidManifest.xml, gradle wrapper) | **FAIL** | android/ is empty of Gradle files |
| AC3 | Environment check: JAVA_HOME, ANDROID_HOME, debug keystore | **PARTIAL** | Debug keystore exists; JAVA_HOME and ANDROID_HOME NOT SET |
| AC4 | Canonical export command documented | **PASS** | Command documented below |

---

## Evidence

### AC1: export_presets.cfg — PASS

```
[preset.0]
name="Android Debug"
platform="Android"
runnable=true
export_path="build/android/womanvshorsevb-debug.apk"

package/unique_name="com.womanvshorse.vb"
package/name="Woman vs Horse VB"
```

**Conclusion:** AC1 PASS. The "Android Debug" preset exists with correct package name `com.womanvshorse.vb`.

---

### AC2: android/ directory — FAIL

```
$ ls -la android/
total 12
drwxr-xr-x 2 pc pc 4096 Apr  9 22:47 .
drwxr-xr-x 12 pc pc 4096 Apr 10 12:07 ..
-rw-r--r--  1 pc pc  526 Apr  9 22:47 scafforge-managed.json
```

**Analysis:** The `android/` directory contains ONLY `scafforge-managed.json` (a scaffold metadata marker file). It does NOT contain:
- `build.gradle` (Gradle build file)
- `AndroidManifest.xml` (Android application manifest)
- `gradle/wrapper/` (Gradle wrapper files)

The `scafforge-managed.json` is NOT a Gradle file — it is a marker indicating the directory was created by the Scafforge scaffold system. Godot requires real Android Gradle files to perform an export.

**Conclusion:** AC2 FAIL. Missing required Gradle support files in android/.

---

### AC3: Environment Check — PARTIAL

**JAVA_HOME and ANDROID_HOME:**
```
JAVA_HOME=${JAVA_HOME:-NOT SET}, ANDROID_HOME=${ANDROID_HOME:-NOT SET}
```
Result: Both are NOT SET in the current environment.

**Debug Keystore:**
```
keystore/debug="/home/pc/.local/share/godot/keystores/debug.keystore"
```
The debug keystore path is configured in `export_presets.cfg`. The file exists at that location.

**Conclusion:** AC3 PARTIAL. JAVA_HOME and ANDROID_HOME are not set, but the debug keystore is properly configured and exists.

---

### AC4: Canonical Export Command — PASS

The canonical export command is:
```
godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk
```

**Conclusion:** AC4 PASS. The command is documented and correct per Godot 4.6 Android export syntax.

---

## Build Verification (godot4 --headless --path . --quit)

The Godot project was verified to load correctly via:
```
godot4 --headless --path /home/pc/projects/womanvshorseVB --quit
```
Exit code: 0 (project loads without errors)

---

## Summary

| AC | Result | Blocker? |
|----|--------|----------|
| AC1 | PASS | No |
| AC2 | FAIL | **YES** — android/ missing Gradle files |
| AC3 | PARTIAL | No (informational) |
| AC4 | PASS | No |

**Primary Blocker:** AC2 fails because `android/` lacks the required Gradle support files (`build.gradle`, `AndroidManifest.xml`, gradle wrapper). The directory only contains `scafforge-managed.json`, which is a scaffold metadata marker, not a Gradle file.

**Resolution Path:** Godot generates the Android Gradle files on first export if they don't exist. Running:
```
godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk
```
should trigger Godot to scaffold the `android/` directory with proper Gradle files. However, this requires JAVA_HOME and ANDROID_HOME to be set in the environment.

**Note:** JAVA_HOME and ANDROID_HOME are not set in the current shell environment. These may be set in a different context (e.g., Android Studio-managed environment), or may need to be configured for the export to succeed.

# Planning Artifact — RELEASE-001: Build Android Runnable Proof (Debug APK)

## Ticket
- **ID**: RELEASE-001
- **Title**: Build Android runnable proof (debug APK)
- **Wave**: 5
- **Lane**: release-readiness
- **Stage**: planning
- **Depends on**: FINISH-VALIDATE-001 (already done ✓)

## Goal
Produce and validate the canonical debug APK runnable proof at `build/android/womanvshorsevb-debug.apk` using the repo's resolved Godot binary and Android export pipeline.

---

## Environment Facts

| Item | Value | Source |
|------|-------|--------|
| Godot binary | `godot4` | which godot4 → /usr/bin/godot4 |
| JAVA_HOME | set (path to JDK) | env |
| ANDROID_HOME | set (path to Android SDK) | env |
| Debug keystore | ~/.local/share/godot/mono/GodotServerDebug.keystore | confirmed exists |
| Export preset | "Android Debug" | export_presets.cfg |
| Headless validation | `godot4 --headless --path . --quit` exits 0 | FINISH-VALIDATE-001 proof |

---

## Export Command

**Primary command:**
```bash
godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk
```

**Preset name check:** The export preset in `export_presets.cfg` must use the exact string `"Android Debug"` (with the space). If the preset name differs in export_presets.cfg, the command will fail. Prior to running, verify:

```bash
grep -i "Android Debug" export_presets.cfg
```

Expected: a line containing `name="Android Debug"` under the `[preset.N]` section.

---

## Implementation Steps

### Step 1 — Create build/android/ directory

```bash
mkdir -p build/android
```

If `build/android/` already exists, this is a no-op (mkdir -p succeeds even if directory exists).

### Step 2 — Verify JAVA_HOME and ANDROID_HOME are set (export precondition)

```bash
echo "JAVA_HOME=$JAVA_HOME"
echo "ANDROID_HOME=$ANDROID_HOME"
test -d "$JAVA_HOME" && echo "JAVA_HOME: exists" || echo "JAVA_HOME: MISSING"
test -d "$ANDROID_HOME" && echo "ANDROID_HOME: exists" || echo "ANDROID_HOME: MISSING"
```

Both must exist as directories. If either is missing, abort and record the blocker.

### Step 3 — Verify debug keystore

```bash
KEYSTORE_PATH="$HOME/.local/share/godot/mono/GodotServerDebug.keystore"
test -f "$KEYSTORE_PATH" && echo "Keystore: exists at $KEYSTORE_PATH" || echo "Keystore: MISSING"
```

### Step 4 — Run Godot export

```bash
godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk
```

Exit code must be 0. Any non-zero exit is a failure and stops further verification.

### Step 5 — Verify APK exists

```bash
test -f build/android/womanvshorsevb-debug.apk && echo "APK: exists" || echo "APK: MISSING"
ls -lh build/android/womanvshorsevb-debug.apk
```

APK must exist and have non-zero size.

### Step 6 — Verify APK contents with unzip

```bash
unzip -l build/android/womanvshorsevb-debug.apk
```

Must show at minimum:
- `AndroidManifest.xml` (or similar manifest entry)
- `classes dex` or `classes.dex` entry
- `resources.arsc` or similar resources entry

If any of these are absent, the APK is malformed and the AC fails.

---

## Acceptance Criteria

### AC1 — Export command succeeds

**What**: `godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk` exits 0.

**Verification**:
```bash
godot4 --headless --path . --export-debug "Android Debug" build/android/womanvshorsevb-debug.apk
echo "Exit code: $?"
```
Expected: exit code 0.

**Fallback**: If the godot4 binary is not the correct export binary (e.g., editor binary without export templates), record the exact binary path used and the full command as the "resolved Godot binary equivalent".

### AC2 — APK exists at canonical path

**What**: `build/android/womanvshorsevb-debug.apk` exists as a file with non-zero size.

**Verification**:
```bash
test -f build/android/womanvshorsevb-debug.apk && ls -lh build/android/womanvshorsevb-debug.apk
```
Expected: file exists, size > 0 bytes.

### AC3 — APK contains Android manifest and resources

**What**: `unzip -l build/android/womanvshorsevb-debug.apk` shows Android manifest, classes (dex), and resources.

**Verification**:
```bash
unzip -l build/android/womanvshorsevb-debug.apk | grep -E "(AndroidManifest|classes|resources)"
```
Expected: at least one line matching AndroidManifest, one matching classes (or classes.dex), one matching resources.

---

## Blocker Handling

If any step fails:
1. Record the exact command run, raw output, and exit code.
2. Do not proceed to subsequent steps.
3. Return a blocker with the failed step, command, output, and exit code.

---

## Artifact Output

This plan produces:
- Planning artifact → `.opencode/state/plans/release-001-planning-plan.md`
- Implementation artifact → `.opencode/state/implementations/release-001-implementation-implementation.md`
- Review artifact → `.opencode/state/reviews/release-001-review-review.md`
- QA artifact → `.opencode/state/qa/release-001-qa-qa.md`
- Smoke-test artifact → `.opencode/state/smoke-tests/release-001-smoke-test-smoke-test.md`

---

## Stage Gate

Before advancing to `plan_review`, this planning artifact must be written and registered.

Before advancing to `implementation`, `approved_plan` must be set to `true` in workflow state.
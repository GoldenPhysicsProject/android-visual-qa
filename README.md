# Android Visual QA

A small, reusable GitHub Actions harness for running a real Android emulator, taking
screenshots, saving UIAutomator dumps, and optionally running instrumented tests.

It is intentionally app-agnostic. This repository contains **no API Vault source,
credentials, package identifiers, Firebase configuration, signing material, or private
Golden Physics data**. Any Android project can call the reusable workflow and provide its
own build command and walkthrough script.

## Why

Source review catches logic problems. It does not catch clipped text, bad spacing,
navigation mistakes, tiny touch targets, broken compact layouts, or an onboarding screen
that simply looks wrong. This harness makes visual QA a repeatable release gate without
requiring a developer workstation to keep an emulator running.

## Minimal use

Create a workflow in your app repository:

```yaml
name: Visual QA

on:
  workflow_dispatch:

jobs:
  screenshots:
    uses: GoldenPhysicsProject/android-visual-qa/.github/workflows/android-visual-qa.yml@main
    with:
      build-command: ./gradlew --no-daemon assembleDebug
      apk-path: app/build/outputs/apk/debug/app-debug.apk
      package-name: com.example.app
      launch-activity: .MainActivity
```

The default walkthrough installs the APK, launches the requested activity, and captures
one screenshot and one UIAutomator XML dump.

## App-specific walkthroughs

For useful product QA, add a script to the calling repository (for example
`.github/scripts/android-visual-qa.sh`) and pass:

```yaml
      walkthrough-script: .github/scripts/android-visual-qa.sh
```

The script runs while the emulator is alive. It can use `adb`, switch viewport sizes,
navigate with UIAutomator, take screenshots, and run `connectedDebugAndroidTest`.

Artifacts are uploaded even if the walkthrough fails, which makes failures inspectable.

## Inputs

- `build-command` — command that produces the APK.
- `prebuild-command` — optional setup performed before the build.
- `apk-path` — path to the generated APK.
- `package-name` — Android application ID.
- `launch-activity` — launch activity; defaults to `.MainActivity`.
- `walkthrough-script` — optional caller-owned script.
- `api-level` — emulator API level; defaults to 33.
- `profile` — emulator hardware profile; defaults to `pixel_6`.
- `artifact-name` — uploaded artifact name.

## Security

Do not print signing keys, Firebase private keys, OAuth secrets, API keys, access tokens,
or credential-bearing screenshots. Use placeholders for compile-only configuration when
the app supports it. Store real release credentials in the caller's secret manager, not
in this harness.

## Cost

The repository is public and uses standard GitHub Actions infrastructure. Whether a run
consumes billable minutes depends on the calling repository/account's current GitHub
Actions plan and policy. The harness itself has no hosted service and charges nothing.

## License

MIT.

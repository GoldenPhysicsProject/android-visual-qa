# Android Visual QA operations bootstrap

This repository is generic public infrastructure, not an application product.

Read `README.md` and `OPS_STATE.md` before changing it. Shared Golden Physics app
operations rules live in `GoldenPhysicsProject/GPP-bridge/rules/GPPAPPS.md`.

## Purpose

Provide a reusable GitHub Actions Android emulator that can:
- build a caller's debug APK;
- boot an accelerated Android emulator;
- install and launch the caller's app;
- run a caller-owned walkthrough;
- collect screenshots and UIAutomator XML;
- run device/instrumentation checks while the emulator is alive;
- upload artifacts even when a walkthrough fails.

## Boundary

This repo must remain app-agnostic and safe to expose publicly.

Never add:
- private app source;
- real Firebase configuration;
- signing material;
- OAuth/API credentials;
- private package-specific test data;
- screenshots that contain secrets or private user data.

App-specific walkthrough logic stays in the caller repository. The public harness only
supplies reusable emulator plumbing and a harmless sample app.

## Cost/routine

Do not trigger expensive emulator runs on every small app commit. Call the harness from
private app repos at release checkpoints. The public sample self-test may run when the
harness itself changes.

After harness changes, update `OPS_STATE.md`, run the public self-test, inspect the
screenshot artifact, and mirror the current state to Supabase under
`app_id='android-visual-qa'`.

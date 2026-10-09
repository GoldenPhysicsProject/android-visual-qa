# Android Visual QA infrastructure plan

Updated: 2026-10-09.

## Role

This repository is public, reusable execution infrastructure for visual/device/browser QA.
It is not a private application source store and not the place for confidential product/IP
architecture.

It should provide reusable plumbing for:
- Android emulator/device QA;
- browser visual QA;
- screenshots and UI hierarchy capture;
- instrumentation/device tests;
- evidence collection;
- release validation using caller-owned logic.

## Public/private boundary

The repository may contain reusable harness code and public-safe workflow definitions.

It must not contain:
- private app source;
- long-lived credentials;
- signing material;
- private Firebase/provider configuration;
- sensitive screenshots/evidence;
- private customer/test data.

If an approved workflow obtains private source ephemerally, it must do so through a
short-lived authorized path and must not publish that source as an artifact.

Sensitive evidence belongs in private storage.

## Architecture direction

Keep the harness modular:
- generic reusable runner plumbing;
- caller-owned app-specific walkthroughs/assertions;
- explicit runner/platform configuration;
- evidence capture separated from product pass/fail policy;
- exact source/build provenance where supported.

Support useful evidence such as:
- screenshots;
- UIAutomator/accessibility structures;
- browser DOM/accessibility;
- console/network traces;
- logcat/runtime output;
- instrumentation/test results.

Preserve artifacts on failure when safe.

## Infrastructure rule

Separate:
1. runner/emulator infrastructure failure;
2. build failure;
3. app launch/navigation failure;
4. visual/product failure.

Do not blame the app for a runner that never booted.

Private higher-level productization and invention-sensitive architecture built on this
harness belong in private Golden Physics records, not this public repository.

## Recording rule

Update this file when the public harness purpose, supported execution targets, security
boundary, or evidence model changes.

Update `OPS_STATE.md` for exact runner/platform/workflow/validation state.

Mirror meaningful updates to `public.gpp_app_memory` under `app_id='android-visual-qa'`.

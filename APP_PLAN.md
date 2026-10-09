# Android Visual QA / Auroculum harness plan

Updated: 2026-10-09.

This repository is public, reusable QA infrastructure. It is not itself the full Auroculum product and must remain safe to expose publicly.

## Role

Provide generic execution plumbing that Auroculum and individual app release workflows can use for:
- Android emulator/device QA;
- browser visual QA;
- screenshots and UI hierarchy capture;
- instrumentation/device tests;
- evidence collection;
- private-source release validation through approved short-lived broker paths.

## Public/private boundary

The repository may contain reusable harness code and public-safe workflow definitions.

It must not contain:
- private app source;
- long-lived credentials;
- signing material;
- private Firebase/provider configuration;
- sensitive screenshots/evidence;
- private customer/test data.

Private source may exist only ephemerally in an approved runner after short-lived authorization and should be pinned to an immutable source revision.

Private evidence should return to trusted/private storage rather than public artifacts when it may contain sensitive product state.

## Auroculum relationship

Auroculum is the higher-level product/system that decides what to inspect, operates the environment, combines multimodal evidence, diagnoses failures, and independently verifies repairs.

This repo supplies execution substrate. Product-specific intelligence and confidential invention detail belong in private Auroculum/GPP Bridge records.

## Evidence goals

Keep support for:
- rendered screenshots;
- UIAutomator/accessibility structures;
- browser DOM/accessibility;
- console/network traces;
- logcat/runtime output;
- instrumentation/test results;
- exact source/build provenance.

Preserve artifacts on failure when safe.

## Infrastructure rule

Separate:
1. runner/emulator infrastructure failure;
2. build failure;
3. app launch/navigation failure;
4. visual/product failure.

Do not blame the app for a runner that never booted.

## Recording rule

Update this plan for durable harness/Auroculum-boundary changes.

Update `OPS_STATE.md` for exact runner/platform/workflow/validation state.

Mirror meaningful updates to `public.gpp_app_memory` under `app_id='android-visual-qa'`.

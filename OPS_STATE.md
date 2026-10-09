# Android Visual QA current state

Snapshot date: 2026-10-09.

This is public, app-agnostic QA infrastructure. It is not the private app source store and
must not contain Golden Physics credentials or sensitive evidence.

## Current main

Main immediately before this state refresh:
`d9b3aa8f4d5d35184b7b0842d494e27763f9cbbd`.

Recent implemented work includes:
- OIDC/private-source fetch helper for approved release workflows;
- free public-runner API Vault release lane;
- private visual-result uploader;
- API Vault emulator run with evidence returned to a private result store;
- browser visual QA for API Vault;
- KVM/emulator-runner iteration;
- a stable Intel macOS Android-emulator route;
- inspectable viewport evidence capture;
- production dependency-audit gating in the API Vault release workflow.

The repository still provides the generic reusable Android emulator harness:
- caller-provided build command;
- APK install/launch;
- caller-owned walkthrough;
- screenshots;
- UIAutomator XML;
- instrumentation/device checks;
- artifact collection even on failure.

## Security boundary

Never publish:
- private app source;
- real Firebase/private provider configuration;
- signing material;
- OAuth/API credentials;
- private package-specific data;
- screenshots containing secrets/private user information.

If a workflow needs private source, it must obtain it ephemerally through the approved
short-lived bridge path and must not upload that source as a public artifact.

## Validation rule

A runner boot failure is not evidence that the app is broken. Separate:
1. runner/emulator infrastructure failure;
2. build failure;
3. launch/navigation failure;
4. visual/product failure.

Preserve screenshots/logs/UI dumps wherever safe so each class can be diagnosed independently.

After meaningful harness changes, update this file and refresh Supabase app memory.

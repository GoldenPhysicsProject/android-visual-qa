# Android Visual QA current state

Snapshot date: 2026-09-28.

Purpose: public, app-agnostic Android emulator infrastructure for screenshot/UI hierarchy
inspection and instrumented test execution. It contains no API Vault source or private
Golden Physics credentials.

Implemented:
- reusable `workflow_call` emulator workflow;
- configurable Gradle/API/profile/build/prebuild inputs;
- caller-owned walkthrough support;
- default launch screenshot + UIAutomator dump;
- artifact upload even when the walkthrough fails;
- harmless standalone sample app for self-testing the emulator path;
- MIT license.

API Vault uses this repository only as generic infrastructure; its package name, dummy
compile configuration, navigation script, and product-specific assertions remain in the
private API Vault repository.

Current self-test workflow run at creation: GitHub Actions run `36476259161`.
Its result must be re-read live before calling the harness verified.

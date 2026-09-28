#!/usr/bin/env bash
set -euo pipefail

: "${APK_PATH:?APK_PATH is required}"
: "${PACKAGE_NAME:?PACKAGE_NAME is required}"
: "${LAUNCH_ACTIVITY:=.MainActivity}"

mkdir -p visual-qa ui-dumps

adb install -r "$APK_PATH"
adb shell pm clear "$PACKAGE_NAME"
adb shell am start -W -n "$PACKAGE_NAME/$LAUNCH_ACTIVITY"
sleep 3

adb exec-out screencap -p > visual-qa/01-launch.png
adb shell uiautomator dump /sdcard/window.xml >/dev/null
adb pull /sdcard/window.xml ui-dumps/01-launch.xml >/dev/null

echo "Captured launch screenshot and UI hierarchy."

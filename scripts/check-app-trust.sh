#!/usr/bin/env bash
# Read-only signing/Gatekeeper checks. Does not launch the application.
# Usage: bash scripts/check-app-trust.sh ["/Applications/Jen.app"]
set -u

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Error: run this script on macOS." >&2
  exit 2
fi

if [[ $# -gt 1 ]]; then
  echo "Usage: bash $0 [path/to/Jen.app]" >&2
  exit 2
fi

app="${1:-/Applications/Jen.app}"
if [[ ! -d "$app" ]]; then
  echo "No application bundle at: $app" >&2
  exit 2
fi

echo "Checking (without launching): $app"
echo
echo "1) Signing information (if present):"
codesign -dv --verbose=4 "$app" 2>&1 || true

status=0
echo
echo "2) Code-signing verification:"
if codesign --verify --deep --strict --verbose=2 "$app"; then
  echo "PASS: code-signing verification"
else
  echo "FAIL: no valid verifiable code signature was established."
  status=1
fi

echo
echo "3) Current Gatekeeper assessment:"
if spctl --assess --type execute --verbose=4 "$app"; then
  echo "PASS: Gatekeeper accepts this app on this Mac."
else
  echo "NOT ACCEPTED: Gatekeeper does not currently accept this app."
  status=1
fi

echo
echo "4) Stapled notarization ticket (optional diagnostic):"
if command -v xcrun >/dev/null 2>&1; then
  if xcrun stapler validate "$app"; then
    echo "Stapled ticket validated."
  else
    echo "No validated stapled ticket found. This alone does not prove the app was never notarized."
  fi
else
  echo "xcrun is not installed; skipped stapler check."
fi

echo
echo "These checks are not a malware scan. They do not modify macOS security settings."
if [[ "$status" -ne 0 ]]; then
  echo "Review https://support.apple.com/en-in/102445 before making any per-app security exception."
fi
exit "$status"

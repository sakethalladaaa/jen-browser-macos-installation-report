#!/usr/bin/env bash
# Inspect a downloaded macOS DMG without opening, executing, or changing it.
# Usage: bash scripts/check-installer.sh /path/to/Jen-0.1.1-arm64.dmg [official_sha256]
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Error: run this script on macOS (hdiutil is required)." >&2
  exit 2
fi

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: bash $0 /path/to/Jen.dmg [expected_official_sha256]" >&2
  exit 2
fi

dmg="$1"
if [[ ! -f "$dmg" ]]; then
  echo "File not found: $dmg" >&2
  exit 2
fi

echo "File: $dmg"
echo "Size:"
ls -lh "$dmg"
echo
echo "Disk-image validation:"
if ! hdiutil verify "$dmg"; then
  echo "FAIL: macOS could not verify the disk image. Try a fresh download." >&2
  echo "Do not disable Gatekeeper or remove quarantine to repair an invalid DMG." >&2
  exit 1
fi

echo
echo "SHA-256 (local file):"
actual="$(shasum -a 256 "$dmg" | awk '{print $1}')"
printf '%s  %s\n' "$actual" "$dmg"

if [[ $# -eq 2 ]]; then
  expected="$(printf '%s' "$2" | tr '[:upper:]' '[:lower:]')"
  if [[ ! "$expected" =~ ^[0-9a-f]{64}$ ]]; then
    echo "Error: expected official SHA-256 must be exactly 64 hex characters." >&2
    exit 2
  fi
  if [[ "$actual" != "$expected" ]]; then
    echo "FAIL: SHA-256 does not match the expected value." >&2
    exit 1
  fi
  echo "PASS: SHA-256 matches the supplied expected value."
else
  echo "No official expected SHA-256 supplied; authenticity is NOT established."
fi

echo "PASS: DMG verified internally. This alone does not establish developer identity or malware safety."

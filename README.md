# Jen Browser — macOS Installation Findings

> **Unofficial, independent installation feedback.** This repository is **not affiliated with, maintained by, or endorsed by the Jen Browser developers**. It documents a first-time installation experience with Jen Browser v0.1.1 beta on an Apple Silicon Mac.

## Purpose

Document actual installation symptoms, diagnostic outputs, and possible improvements to macOS onboarding.

**Download source:** https://jen-browser.vercel.app/#download

## Findings — November 3, 2026

| Finding | Observation | Status |
| --- | --- | --- |
| Initial DMG not recognized | `hdiutil verify` reported `image not recognised`, and Finder reported a corrupted disk image | Resolved locally by downloading again; root cause unknown |
| Gatekeeper blocks launch | macOS warned that Apple could not verify Jen; the project's download page says this beta is not notarized | Observed; successful launch not yet confirmed |

A fresh `Jen-0.1.1-arm64.dmg` (about 126 MiB) **passed `hdiutil verify`**. A valid disk-image checksum does **not** prove developer identity or malware safety.

## Documentation

- [Detailed first-time installation report](docs/installation-report.md)
- [How to verify downloaded DMGs](docs/safe-installation-checklist.md)
- [Issue #1 — first-time installation problems](../../issues/1)

## Recommendations

1. Sign and notarize the macOS application with an Apple Developer ID.
2. Publish official SHA-256 checksums for release downloads.
3. Investigate incomplete or unrecognized downloaded images and clarify retry steps.
4. Explain the correct sequence: open DMG, drag `Jen.app` to Applications, eject DMG.
5. Prefer Apple's supported Gatekeeper handling over globally disabling security or broadly removing quarantine attributes.

## Security note

Do not globally disable Gatekeeper or remove quarantine protections simply to make an app run. Only override an app warning after independently deciding to trust its origin and understanding the risk. [Apple's guidance](https://support.apple.com/en-us/102445).

## Scope

This is one user's report of one machine and one download retry, **not** proof of a systemic server bug. It is not the official Jen Browser issue tracker.

## Installation tools and proposed fixes

**Read-only macOS diagnostics:**

```bash
# Verify the downloaded installer and print its SHA-256.
bash scripts/check-installer.sh "$HOME/Downloads/Jen-0.1.1-arm64.dmg"

# Check the installed app's code signature, Gatekeeper decision, and stapled ticket.
bash scripts/check-app-trust.sh "/Applications/Jen.app"
```

The first script accepts an optional second parameter containing an **independently obtained official SHA-256**; without it, the script does not establish publisher authenticity. The second script may report failure for an unnotarized application; it never overrides macOS security protections.

- [User troubleshooting and safe recovery](docs/macos-troubleshooting.md)
- [Upstream maintainer release/signing/notarization fix plan](docs/upstream-maintainer-fix-plan.md)
- [Script syntax validation workflow](.github/workflows/validate-scripts.yml)

**Status:** These tools and docs are committed. Actual Jen binaries have not been modified, the macOS app launch is unconfirmed, and Apple notarization requires the upstream maintainer's authorized release pipeline. GitHub Actions execution is not asserted as passing until it runs.

# [macOS] First-time installation: invalid DMG and Gatekeeper warning

## Summary

During my first-time installation of **Jen Browser v0.1.1 beta** on a MacBook Air M4, the first downloaded DMG was not recognized as a disk image. A second download verified correctly, but macOS Gatekeeper later blocked the application from opening. These are separate symptoms, and the underlying cause of the first failure is unconfirmed.

## Environment

- Device: MacBook Air M4 (Apple Silicon / arm64)
- OS: macOS (exact version not recorded)
- App: Jen Browser v0.1.1 beta
- Download page: https://jen-browser.vercel.app/#download
- Filename: `Jen-0.1.1-arm64.dmg`
- Date observed: 2026-11-03

## Finding 1: Initial DMG was not recognized

1. Downloaded the arm64 installer from the project website.
2. Moved the DMG file itself to `/Applications` (this is not the correct app installation procedure).
3. Attempted to open it; macOS said the disk image was corrupted.
4. Inspected it via Terminal.

```console
$ hdiutil verify /Applications/Jen-0.1.1-arm64.dmg
hdiutil: verify: unable to recognize "/Applications/Jen-0.1.1-arm64.dmg" as a disk image. (image not recognised)
hdiutil: verify failed - image not recognised

$ file /Applications/Jen-0.1.1-arm64.dmg
/Applications/Jen-0.1.1-arm64.dmg: zlib compressed data
```

The initial installer occupied **82,785,212 bytes** (~82.8 MB decimal). The `file` output alone does not prove its contents were invalid, but `hdiutil` failed to recognize it.

### Retest

Re-downloaded the DMG from the same website and saved it to Downloads. The replacement showed approximately **126 MiB** in `ls -lhT`, and disk-image verification succeeded:

```text
hdiutil: verify: checksum of "/Users/.../Downloads/Jen-0.1.1-arm64.dmg" is VALID
```

**Interpretation:** Re-downloading resolved the invalid-image symptom locally. An interrupted transfer is one possible explanation; it has **not** been verified as a hosting or release artifact defect.

## Finding 2: macOS Gatekeeper warning

After copying `Jen.app` to `/Applications`, macOS displayed:

> "Jen" Not Opened — Apple could not verify "Jen" is free of malware that may harm your Mac or compromise your privacy.

The dialog offered **Done** and **Move to Bin**. The website acknowledges that the beta is not notarized and mentions removing the quarantine attribute.

### Expected behavior

A signed, notarized application would avoid this particular first-launch verification friction. In the meantime, documentation should explain the warning and Apple's supported procedures without suggesting broad security bypasses by default.

## Recommendations

1. Sign and notarize macOS releases using the Apple Developer ID workflow.
2. Publish release SHA-256 hashes alongside DMGs for independent integrity checks.
3. Investigate partial or invalid downloads and help users retry.
4. Document the correct sequence: open DMG → drag `Jen.app` to `/Applications` → eject image.
5. Provide security-conscious guidance for Gatekeeper instead of recursive quarantine removal as the default.
6. Add a short macOS troubleshooting page containing exact error messages.

## Current status

| Check | Outcome |
| --- | --- |
| First DMG recognized by macOS | Failed |
| Replacement DMG integrity via `hdiutil verify` | Passed |
| `Jen.app` exists in `/Applications` | Confirmed |
| Successful Jen launch | Not yet confirmed |
| App signing identity / notarization independently audited | Not yet done |

**Note:** The disk-image checksum validates internal image integrity, not source authenticity or malware safety. This independent report is not an official Jen Browser issue tracker entry.

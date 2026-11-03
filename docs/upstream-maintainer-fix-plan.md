# Upstream Maintainer Fix Plan: Signed, Notarized macOS Releases

**This is an upstream proposal, not an implemented fix to Jen Browser binaries.** Our independent report repository contains no Jen Browser source, signing identity, release infrastructure, or Apple developer credentials.

## 1. Reliable release artifacts

- Build the real Jen app from the maintained source, on a trusted macOS CI/release runner.
- Sign every executable, library, helper app, and other nested code using the correct **Developer ID Application** identity, using the project's actual build tooling. Enable the hardened runtime when required for notarization.
- Package the **signed application** in the release DMG. The exact packaging/signing method depends on the upstream stack (Electron, Tauri, native, etc.); do not copy arbitrary signing flags into production without verifying nested-code signing.
- Host immutable versioned assets; ensure completed uploads are not truncated and the CDN does not serve partial artifacts as completed downloads.
- Publish the final DMG size and SHA-256 on an independently verifiable release page.

## 2. Apple notarization flow (example commands)

Run these **only in the official release environment with authorization and a correctly signed build**, not on an untrusted downloaded app.

```sh
# Verify signed app bundle before packaging.
codesign --verify --deep --strict --verbose=2 "/path/to/Jen.app"

# Submit the correctly packaged and signed release artifact.
# The keychain profile must have been configured securely by the maintainer.
xcrun notarytool submit "dist/Jen-VERSION-arm64.dmg" --keychain-profile "NOTARY_PROFILE" --wait

# Only after Apple accepts the submission:
xcrun stapler staple "dist/Jen-VERSION-arm64.dmg"
xcrun stapler validate "dist/Jen-VERSION-arm64.dmg"

# Publish this checksum alongside the FINAL stapled DMG.
shasum -a 256 "dist/Jen-VERSION-arm64.dmg"
```

**Note:** A stored keychain profile is specific to the build machine. Do not commit Apple credentials, API keys, certificates, or keychain passwords to Git.

## 3. Automated release acceptance criteria

- Signatures verify for every distributed executable and the app bundle.
- Apple's notarization submission is **Accepted**; the DMG stapling check succeeds.
- Downloaded DMG can be recognized and verified via `hdiutil verify`.
- Hosted final asset's published checksum matches a separate download.
- Fresh macOS Apple Silicon test machine can install by dragging the app into Applications.
- First launch on a fresh machine follows expected Gatekeeper behavior **without a quarantine bypass**.
- Release documentation includes basic retry/repair steps and Apple's official security instructions.
- Validate the x86_64 build separately if an Intel version is published.

## 4. What this repo does now

- `scripts/check-installer.sh`: verifies local DMG and optionally compares an official expected SHA-256.
- `scripts/check-app-trust.sh`: checks a local app's signature, Gatekeeper assessment, and ticket without launching it.
- `docs/macos-troubleshooting.md`: recovery procedure for users.
- CI checks shell script syntax, not macOS binary distribution, code signing, or notarization.

## Apple documentation

- [Signing Mac Software with Developer ID](https://developer.apple.com/developer-id/)
- [Notarizing macOS software before distribution](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution)
- [Customizing the notarization workflow](https://developer.apple.com/documentation/security/customizing-the-notarization-workflow)

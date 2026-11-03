# Verified local app-signing diagnostics (2026-11-03)

**Status:** Reproduced on a single MacBook Air M4. **Scope:** Observations from a locally installed copy of Jen Browser v0.1.1; not an audit of the release publisher or download hosting.

## Command

```sh
bash scripts/check-app-trust.sh "/Applications/Jen.app"
```

## Relevant output (abridged; personal home paths omitted)

```text
Executable=/Applications/Jen.app/Contents/MacOS/Jen
Identifier=com.jishnusdeka.jen
Format=app bundle with Mach-O thin (arm64)
CodeDirectory v=20400 size=428 flags=0x2(adhoc)
Signature=adhoc
TeamIdentifier=not set
/Applications/Jen.app: valid on disk
/Applications/Jen.app: satisfies its Designated Requirement
PASS: code-signing verification
/Applications/Jen.app: rejected
NOT ACCEPTED: Gatekeeper does not currently accept this app.
Jen.app does not have a ticket stapled to it.
No validated stapled ticket found.
```

The `codesign --verify --deep --strict` command also validated the bundled Electron frameworks and helper applications without reporting a structural signing error.

## Interpretation

- The application is built for Apple Silicon (`arm64`).
- The app has a valid **ad-hoc** code signature, which can establish code integrity but **does not attest to an identified Apple Developer ID publisher**.
- There is **no Apple Developer Team ID** in the signature.
- Gatekeeper **rejects the installed app on this Mac**.
- No **stapled** notarization ticket was found on the app. A missing stapled ticket alone does not prove that the app has never been notarized, but the ad-hoc signature is unsuitable for standard Developer ID notarization. Apple requires a Developer ID signature for notarization of distributed software.

**This output does not prove that Jen contains malware**, nor does a successful integrity check prove it is safe to run.

## Upstream corrective action

The Jen Browser maintainers should produce an authorized **Developer ID Application-signed** release, with correctly signed nested Electron components and necessary hardened-runtime entitlements, submit the distribution build using Apple's `notarytool`, staple and validate the ticket, and run a clean Mac installation test.

See [maintainer fix plan](upstream-maintainer-fix-plan.md).

## User handling

Prefer a new signed/notarized build. If the publisher is independently trusted and the user understands the risks, Apple's supported UI permits a **per-app** manual exception via System Settings → Privacy & Security → Open Anyway following a blocked launch. It **does not make the app Apple-verified**.

Avoid globally disabling Gatekeeper or removing quarantine attributes just to suppress the warning.

## References

- [Apple: Notarizing macOS software before distribution](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution)
- [Apple: Safely open apps on your Mac](https://support.apple.com/en-in/102445)

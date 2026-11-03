# macOS Installation Troubleshooting

**Unofficial, independent guidance for users of Jen Browser v0.1.1 beta.** The real Jen developers must publish any official updates. Do not download random modified binaries.

## A. The DMG says "corrupted" / `image not recognised`

1. Keep the DMG in Downloads instead of moving the `.dmg` file into Applications.
2. On macOS, run the read-only check:

   ```bash
   bash scripts/check-installer.sh "$HOME/Downloads/Jen-0.1.1-arm64.dmg"
   ```

3. If `hdiutil verify` fails, retry downloading the installer from the developer's intended website.
4. When an official SHA-256 is available **from an independently trusted channel**, pass it as the optional second argument. Do not treat the checksum printed by your own Mac as proof of publisher authenticity.

Our first download was 82,785,212 bytes and could not be recognized by `hdiutil`. The replacement showed 126 MiB in Finder/Terminal and passed verification. This does **not** establish why the first download failed.

## B. Installing the app correctly

After the DMG verifies:

1. Double-click the valid DMG in Finder to mount it.
2. Drag **Jen.app** from the mounted image to the **Applications** folder, using the installer window or Finder.
3. Eject the mounted DMG. You can keep or remove the installer from Downloads as you prefer.
4. Do not put the `.dmg` itself in `/Applications`.

## C. macOS warns "'Jen' Not Opened"

This is a Gatekeeper trust / notarization warning, not an invalid-DMG checksum error.

- For a read-only report of signing, Gatekeeper status, and a stapled ticket, use:

  ```bash
  bash scripts/check-app-trust.sh "/Applications/Jen.app"
  ```

- **Best option:** Obtain a properly signed/notarized release from the developer, and verify its source.
- If you have separately verified that the publisher and the exact app are trustworthy and accept the remaining risk, Apple documents a **per-app** exception: first try opening it, then visit **System Settings → Privacy & Security → Open Anyway**, and confirm the dialog. This option may be available for roughly an hour after attempting to open the app.
- If you cannot verify the publisher or the integrity of the downloaded binary, **do not override the warning**.

**Do not** use `sudo spctl --master-disable` or recursive `xattr -dr com.apple.quarantine` instructions as a workaround. Neither makes Jen an Apple-verified app.

## D. What can and cannot be fixed here

| Action | This independent repository? |
| --- | --- |
| Check DMG integrity, hash, signature/Gatekeeper status | Yes; read-only scripts |
| Explain correct installation sequence and Apple's per-app exception | Yes; documentation |
| Investigate the upstream download server | No; requires upstream access/logs |
| Change Jen's shipped code, signing identity, or Apple notarization | No; requires authorized upstream build/signing credentials |

## Sources

- [Apple: Open apps safely on your Mac](https://support.apple.com/en-in/102445)
- [Apple: Signing Mac Software with Developer ID](https://developer.apple.com/developer-id/)

# Safe macOS Installation Checklist

This is independent community documentation, not an official Jen Browser guide.

1. Download the **arm64** DMG for an Apple Silicon Mac from the intended developer website.
2. Confirm that the download has completed.
3. Check image integrity without executing it:

   ```sh
   hdiutil verify ~/Downloads/Jen-0.1.1-arm64.dmg
   ```

4. If the image is not recognized, retry a fresh download rather than modifying macOS security settings.
5. If the image verifies, open it and drag **Jen.app** into **Applications**. Move the app, not the DMG file.
6. Before overriding any Gatekeeper warning, confirm you trust the publisher and obtain independently verifiable release information where available.
7. Consult [Apple's official instructions for opening apps safely](https://support.apple.com/en-us/102445); do not disable Gatekeeper globally or remove quarantine recursively as an installation shortcut.

**Limitations:** `hdiutil verify` does not independently establish publisher authenticity. The developer should provide cryptographically verifiable release hashes and notarized builds.

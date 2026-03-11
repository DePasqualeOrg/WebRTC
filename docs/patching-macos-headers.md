# Patching macOS framework headers

The WebRTC macOS framework is missing headers due to an incomplete upstream fix ([webrtc:450130875](https://issues.webrtc.org/u/1/issues/450130875)). The iOS framework has the correct headers, but the macOS `mac_framework_bundle` build target doesn't copy them into the bundle. Until Google fixes this, each release needs a manual patch.

## Steps

1. **Download and unzip the release xcframework:**
   ```sh
   curl -sL "https://github.com/DePasqualeOrg/WebRTC/releases/download/<VERSION>/WebRTC-M<MILESTONE>.xcframework.zip" -o /tmp/webrtc.zip
   unzip -q /tmp/webrtc.zip -d /tmp/webrtc-patch
   ```

2. **Copy iOS headers into the macOS framework:**
   ```sh
   cp /tmp/webrtc-patch/WebRTC.xcframework/ios-arm64/WebRTC.framework/Headers/*.h \
      /tmp/webrtc-patch/WebRTC.xcframework/macos-x86_64_arm64/WebRTC.framework/Versions/A/Headers/
   ```

3. **Remove iOS-only headers from macOS:**
   ```sh
   cd /tmp/webrtc-patch/WebRTC.xcframework/macos-x86_64_arm64/WebRTC.framework/Versions/A/Headers/
   rm -f RTCAudioDevice.h RTCAudioSession.h RTCAudioSessionConfiguration.h \
         RTCCameraPreviewView.h RTCEAGLVideoView.h RTCMTLVideoView.h \
         RTCNetworkMonitor.h UIDevice+RTCDevice.h
   ```

4. **Add the macOS-specific `RTCMTLNSVideoView.h`:** Copy it from the WebRTC source at the corresponding milestone branch. Find the branch number via the [Chromium Dashboard](https://chromiumdash.appspot.com/fetch_milestones?mstone=<MILESTONE>) (`webrtc_branch` field). Then:
   ```sh
   git show refs/branch-heads/<BRANCH>:sdk/objc/components/renderer/metal/RTCMTLNSVideoView.h > \
       /tmp/webrtc-patch/WebRTC.xcframework/macos-x86_64_arm64/WebRTC.framework/Versions/A/Headers/RTCMTLNSVideoView.h
   ```

5. **Replace the macOS umbrella header (`WebRTC.h`):** The generated one is the iOS umbrella header. Replace it with one that:
   - Removes imports for the iOS-only headers listed in step 3
   - Adds `#import <WebRTC/RTCMTLNSVideoView.h>`
   - Keeps any new headers that are platform-agnostic (check if they only import Foundation)

6. **Repackage and compute checksum:**
   ```sh
   cd /tmp/webrtc-patch
   zip --symlinks -r /tmp/WebRTC-patched.xcframework.zip WebRTC.xcframework/
   shasum -a 256 /tmp/WebRTC-patched.xcframework.zip
   ```

7. **Use the existing release PR branch if it already exists; otherwise create a patch branch**:
   - If the automated release workflow already opened `release-M<MILESTONE>` for `<VERSION>.0.0`, continue working on that same branch and PR.
   - Otherwise create a patch branch (for example `release-M<MILESTONE>-patch`).
   - Update `Package.swift` URL and checksum to point to `<VERSION>.1`
   - Update the `README.md` example version to `<VERSION>.1`
   - Update `WebRTC-lib.podspec` to `<VERSION>.1`
   - Add or update the `WebRTC.json` entry for `<VERSION>.1`
   - Commit and push the branch you are using
   - Do not merge the PR until the patched release has been published
   - Keep the `<VERSION>.0.0` tag on the original workflow commit. Adding later patch commits to the same branch does not move that tag.

8. **Rename the patched zip to the canonical asset name:**
   ```sh
   cp /tmp/WebRTC-patched.xcframework.zip /tmp/WebRTC-M<MILESTONE>.xcframework.zip
   ```

9. **Create the patch release** (e.g. `X.0.1`) targeting that branch:
   - `gh release create <VERSION>.1 /tmp/WebRTC-M<MILESTONE>.xcframework.zip --repo DePasqualeOrg/WebRTC --target <BRANCH> --title "M<MILESTONE>" --notes "Rebuild of M<MILESTONE> with macOS framework headers fix."`
   - Merge the branch back into `latest`

   If you create the GitHub release before the `Package.swift` commit exists, GitHub will tag the current `latest` tip instead of the updated patch commit.
   If that already happened, move the tag to the correct commit with `git tag -f <VERSION>.1 <COMMIT>` and `git push origin refs/tags/<VERSION>.1 --force`.
   Do not rely on `#label` to rename the uploaded asset. SwiftPM downloads the asset by its real filename, which must match the URL in `Package.swift`.
   Do not pass `--prerelease` unless you intentionally want a prerelease.
   If you accidentally uploaded the wrong asset filename, fix it with `gh release upload <VERSION>.1 /tmp/WebRTC-M<MILESTONE>.xcframework.zip --repo DePasqualeOrg/WebRTC`.
   If you accidentally made the release a prerelease, fix it with `gh release edit <VERSION>.1 --prerelease=false --latest --repo DePasqualeOrg/WebRTC`.

## Verifying

Check that the macOS framework has the correct headers (should be ~85, not 1):
```sh
ls /tmp/webrtc-patch/WebRTC.xcframework/macos-x86_64_arm64/WebRTC.framework/Versions/A/Headers/ | wc -l
```

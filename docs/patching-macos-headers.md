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

7. **Create a patch release** (e.g. `X.0.1`):
   - `gh release create <VERSION>.1 /tmp/WebRTC-patched.xcframework.zip#WebRTC-M<MILESTONE>.xcframework.zip --repo DePasqualeOrg/WebRTC --title "M<MILESTONE>" --notes "Rebuild of M<MILESTONE> with macOS framework headers fix."`
   - Update `Package.swift` URL and checksum to point to the patch release
   - Tag the commit as `<VERSION>.1`

## Verifying

Check that the macOS framework has the correct headers (should be ~85, not 1):
```sh
ls /tmp/webrtc-patch/WebRTC.xcframework/macos-x86_64_arm64/WebRTC.framework/Versions/A/Headers/ | wc -l
```

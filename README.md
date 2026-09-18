# Jarvis Glasses V5.2 — background capture

Build and install this source using the included GitHub Actions workflow (Build Jarvis Glasses V5.2 IPA), or generate the Xcode project with XcodeGen on a Mac. Sign the unsigned IPA using your usual installation method.

Open the app, grant microphone/speech access, select your microphone and glasses, enable Keep listening and Auto reconnect. Verify Audio capture is Active and Live speech updates. Go Home or lock the phone; leave the app in the app switcher. Say Hey Jarvis.

The audio and bluetooth-central background declarations were already present. This update keeps the actual microphone engine/tap running across speech-task renewals, finals and speech errors. A locked handoff swaps speech requests safely between the main thread and audio callback. Recognition still has brief renewal gaps; audio is not saved or buffered across those gaps. Audio continues to be processed for wake detection. On-device speech is preferred when supported; otherwise recognition may use Apple's servers.

Microphone changes, calls, media resets and disabling listening still stop/rebuild capture. V5.1 microphone stability guards remain. Bluetooth initialization now runs at application launch for restoration, and disconnect/power-on callbacks register reconnection directly rather than depending on a delayed timer. No app reopening, silent audio, or background-task timer is used to simulate continuous execution.

This does not modify glasses firmware or reproduce Hey Cyan internals. It does not guarantee recovery after force-quit, reboot, iOS termination, or microphone contention. Reopen after force-quit or reboot. Active recording uses battery and shows the iOS microphone indicator. Unsupported on-device-only settings stop capture explicitly.

Validation on Windows: source lifecycle checks, plist/project references, ZIP integrity. Xcode compilation, iPhone background execution, speech accuracy and glasses behavior remain untested.

Device acceptance checks:
1. Enable listening in foreground; speak Hey Jarvis and confirm Last detected plus glasses response.
2. Go Home for 3 minutes (crosses multiple speech renewals), speak again.
3. Lock for 10 minutes, speak every minute; record misses and Last detected afterward.
4. End a phone call and test resumed audio; if iOS refuses recovery reopen the app.
5. Disconnect/reconnect glasses while in background; test wake again.
6. Disable Keep listening: audio capture must stop and not restart from route notifications.
7. Force-quit: expect no app wake detection; reopen and confirm recovery.

References: https://developer.apple.com/documentation/avfaudio/avaudiosession/category-swift.struct/record
https://developer.apple.com/documentation/technotes/tn3115-bluetooth-state-restoration-app-relaunch-rules

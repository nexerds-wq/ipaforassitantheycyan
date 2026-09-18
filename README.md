# Jarvis Glasses V5 — listener repairs

Enable Keep listening and grant microphone/speech access. Existing installs retain the saved on/off switch; new installs default on. Select iPhone first, say Hey Jarvis, and inspect the input meter, live speech and Last detected. Test Glasses independently to verify the BLE command.

For glasses audio, pair the glasses in iPhone Settings > Bluetooth and select Bluetooth / glasses. A BLE connection in this app does not carry microphone audio. An unavailable call microphone produces an explicit error rather than silently choosing the phone.

Fixed: late callbacks from cancelled sessions restarting newer sessions; overlapping permission starts; route changes leaving an obsolete audio tap; audio-engine reuse after media-services reset; hidden speech errors; on-device-only silently using network recognition. On-device recognition is preferred when supported. Otherwise Apple server recognition is used unless on-device-only is set.

This is still Apple Speech transcription plus phrase matching. Speech task renewals have short recording gaps. Active background audio is declared, but indefinite background/locked detection is not guaranteed. Force-quitting stops listening; calls interrupt it. No dedicated wake-word model or glasses firmware was added.

Build: upload all files including .github/workflows/build-ipa.yml to your repository root. Run Build Jarvis Glasses V5 IPA in GitHub Actions, then sign/install its unsigned IPA using your usual process. Alternatively generate the project using XcodeGen and build on a Mac. No account changes or upload were performed here.

Validation: source/package checks only on Windows. Xcode compilation, on-phone audio, Bluetooth, lock-screen behavior and actual detection accuracy have NOT been tested.

Device checks: (1) iPhone mic and phrase ten times; (2) Bluetooth mic and phrase ten times; (3) change input during listening; (4) stay quiet for two minutes then speak; (5) background and lock for five minutes; (6) receive/end a call; (7) switch listening off and ensure no restart. Record misses and the displayed error/route.

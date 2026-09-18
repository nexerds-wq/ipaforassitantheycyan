# Jarvis Glasses V4 — Siri-like System Wake

V4 changes the recommended wake method.

The older app listener uses Apple's Speech framework. That works, but it is normal speech-to-text and can miss a short phrase such as "Hey Jarvis".

V4 exposes **Wake Jarvis** as an iOS App Intent and is designed to be used with **Vocal Shortcuts**. Vocal Shortcuts learns your exact voice on-device and continuously listens for the phrase you train. This is the closest public iPhone feature to a third-party "Hey Siri" style wake phrase.

## Build

Upload all files in this folder to the root of your GitHub repository, including `.github/workflows/build-ipa.yml`.

Run **Build Jarvis Glasses V4 IPA** in GitHub Actions and install the generated IPA with Sideloadly.

## First setup

1. Open Jarvis Glasses V4.
2. Connect/select the M02S and press **Test Wake Action Now**. Make sure that wakes the glasses.
3. On the iPhone open **Settings → Accessibility → Vocal Shortcuts**.
4. Tap **Add Action → Continue**.
5. Choose **Wake Jarvis**.
6. Enter **Hey Jarvis** (or another phrase you want).
7. Repeat the phrase when iPhone asks so it learns your voice.
8. Leave Vocal Shortcuts enabled.
9. Put Jarvis in the background and say the phrase. Then lock the phone and test again.

If **Wake Jarvis** is not shown in Vocal Shortcuts, open the Shortcuts app, create a shortcut containing the Jarvis Glasses action **Wake Jarvis**, then choose that shortcut from Vocal Shortcuts.

The App Intent uses `IntentAuthenticationPolicy.alwaysAllowed`, so the Jarvis action itself is allowed to execute while the device is locked.

## Change the wake word

Edit/recreate the Vocal Shortcut and train a new phrase. You can use `Jarvis`, `Hey Jarvis`, `Nexer`, `Computer`, etc.

The old in-app Speech listener is still included as an optional backup.

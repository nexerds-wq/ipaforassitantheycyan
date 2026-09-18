import AppIntents

/// System action used by iOS Vocal Shortcuts / Shortcuts.
/// This is intentionally allowed while the phone is locked so the system can
/// wake the glasses without having to open the Jarvis app first.
struct WakeJarvisIntent: AppIntent {
    static var title: LocalizedStringResource = "Wake Jarvis"
    static var description = IntentDescription("Wake the saved M02S glasses and start Jarvis listening.")
    static var openAppWhenRun: Bool = false
    static var authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed

    func perform() async throws -> some IntentResult {
        try await BLEController.shared.wakeSavedGlasses()
        return .result()
    }
}

/// Makes the action show up in Shortcuts and other system experiences.
struct JarvisShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: WakeJarvisIntent(),
            phrases: [
                "Wake Jarvis with \(.applicationName)",
                "Wake my glasses with \(.applicationName)",
                "Start Jarvis with \(.applicationName)"
            ],
            shortTitle: "Wake Jarvis",
            systemImageName: "waveform.circle.fill"
        )
    }
}

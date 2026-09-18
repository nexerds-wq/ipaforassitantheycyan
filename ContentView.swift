import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject var bluetooth: BLEController
    @EnvironmentObject var wakeWord: WakeWordManager
    @AppStorage("jarvis.systemWakePhrase") private var systemWakePhrase = "Hey Jarvis"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header
                    systemWakeCard
                    connectionCard
                    fallbackWakeCard
                    devicesCard
                    notesCard
                }
                .padding()
            }
            .navigationTitle("Jarvis")
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "waveform.circle.fill")
                .font(.system(size: 76))

            Text("Jarvis Glasses")
                .font(.largeTitle.bold())

            Text("Siri-like wake uses iPhone Vocal Shortcuts")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private var systemWakeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("System Wake — Recommended", systemImage: "iphone.and.waveform")
                .font(.headline)

            Text("This is the closest iPhone allows to Hey Siri for a third-party app. iOS listens for the phrase itself using on-device Vocal Shortcuts instead of waiting for normal speech-to-text.")
                .font(.subheadline)

            VStack(alignment: .leading, spacing: 5) {
                Text("Phrase you want to train")
                    .font(.caption.bold())
                TextField("Hey Jarvis", text: $systemWakePhrase)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
            }

            Button("Copy Phrase") {
                UIPasteboard.general.string = systemWakePhrase.isEmpty ? "Hey Jarvis" : systemWakePhrase
            }
            .buttonStyle(.bordered)

            Divider()

            Text("SET IT UP ONCE")
                .font(.caption.bold())
                .foregroundStyle(.secondary)

            setupRow("1", "Settings → Accessibility → Vocal Shortcuts")
            setupRow("2", "Tap Add Action → Continue")
            setupRow("3", "Choose the Jarvis action named ‘Wake Jarvis’")
            setupRow("4", "Enter ‘\(systemWakePhrase.isEmpty ? "Hey Jarvis" : systemWakePhrase)’ and train it when iPhone asks")
            setupRow("5", "Leave Vocal Shortcuts ON. Now test it with this app in the background, then with the phone locked")

            Text("If Wake Jarvis does not appear there, open the Shortcuts app once, search Actions for ‘Wake Jarvis’, make a one-action shortcut, then select that shortcut in Vocal Shortcuts.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Test Wake Action Now") {
                Task {
                    do {
                        try await bluetooth.wakeSavedGlasses()
                        await MainActor.run {
                            bluetooth.status = "System Wake test → M02S wake sent ✓"
                        }
                    } catch {
                        await MainActor.run {
                            bluetooth.status = "System Wake test failed: \(error.localizedDescription)"
                        }
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .cardStyle()
    }

    private var connectionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Glasses", systemImage: "eyeglasses")
                .font(.headline)

            infoRow("Selected", bluetooth.selectedName)
            infoRow("Connection", bluetooth.isConnected ? "Connected" : "Not connected")
            infoRow("Last wake", bluetooth.lastWakeText)

            Text(bluetooth.status)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Toggle("Auto reconnect", isOn: Binding(
                get: { bluetooth.autoReconnect },
                set: { bluetooth.setAutoReconnect($0) }
            ))

            HStack {
                Button(bluetooth.isScanning ? "Stop Scan" : "Scan") {
                    bluetooth.isScanning ? bluetooth.stopScan() : bluetooth.startScan()
                }
                .buttonStyle(.borderedProminent)

                Button("Test Glasses") {
                    bluetooth.testWake()
                }
                .buttonStyle(.bordered)
            }
        }
        .cardStyle()
    }

    private var fallbackWakeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("App Listener — Backup", systemImage: "mic.badge.plus")
                .font(.headline)

            Text("Keep this as a backup. The System Wake above should be much more reliable for a short phrase like Hey Jarvis.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Toggle("Use app wake-word listener too", isOn: Binding(
                get: { wakeWord.enabled },
                set: { wakeWord.setEnabled($0) }
            ))

            VStack(alignment: .leading, spacing: 5) {
                Text("App listener phrase")
                    .font(.caption.bold())
                TextField("Hey Jarvis", text: Binding(
                    get: { wakeWord.wakePhrase },
                    set: { wakeWord.setWakePhrase($0) }
                ))
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
            }

            HStack {
                Text("Sensitivity")
                Spacer()
                Picker("Sensitivity", selection: Binding(
                    get: { wakeWord.sensitivity },
                    set: { wakeWord.setSensitivity($0) }
                )) {
                    ForEach(WakeWordManager.Sensitivity.allCases) { level in
                        Text(level.title).tag(level)
                    }
                }
                .pickerStyle(.menu)
            }

            infoRow("Listener", wakeWord.isListening ? "Listening" : "Stopped")
            infoRow("Microphone", wakeWord.inputRoute)
            infoRow("Last detected", wakeWord.lastDetected)
            infoRow("Best match", wakeWord.lastMatch)

            Text(wakeWord.status)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if !wakeWord.liveText.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Live speech")
                        .font(.caption.bold())
                    Text(wakeWord.liveText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(4)
                }
            }
        }
        .cardStyle()
    }

    private var devicesCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Bluetooth devices")
                .font(.headline)

            if bluetooth.devices.isEmpty {
                Text("Tap Scan. Your M02S should move near the top of the list.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(bluetooth.devices.prefix(12)) { device in
                    Button {
                        bluetooth.select(device)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(device.name)
                                    .font(.body.weight(.medium))
                                    .foregroundStyle(.primary)
                                Text(device.id.uuidString)
                                    .font(.caption2.monospaced())
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            Spacer()
                            Text("\(device.rssi)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 5)
                    }
                    Divider()
                }
            }
        }
        .cardStyle()
    }

    private var notesCard: some View {
        VStack(alignment: .leading, spacing: 7) {
            Label("Why V4 detects better", systemImage: "bolt.fill")
                .font(.headline)
            Text("The older listener had to convert your microphone audio into text and then guess whether the text looked like Hey Jarvis. That is why it could miss a short phrase.")
            Text("V4 adds an iOS system action specifically for Vocal Shortcuts. You train iPhone on your own voice, and iOS listens for that phrase on-device. This is much closer to how a real wake phrase should feel.")
            Text("You can change the phrase whenever you want by editing or recreating the Vocal Shortcut. The app listener remains available as a backup.")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .cardStyle()
    }

    private func setupRow(_ number: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(number)
                .font(.caption.bold())
                .frame(width: 24, height: 24)
                .background(.thinMaterial, in: Circle())
            Text(text)
                .font(.subheadline)
        }
    }

    private func infoRow(_ title: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
                .lineLimit(2)
        }
        .font(.subheadline)
    }
}

private extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

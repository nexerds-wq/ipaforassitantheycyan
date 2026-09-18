import SwiftUI
import UIKit

final class JarvisAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        _ = BLEController.shared
        return true
    }
}

@main
struct JarvisGlassesApp: App {
    @UIApplicationDelegateAdaptor(JarvisAppDelegate.self) private var appDelegate
    @StateObject private var coordinator = JarvisCoordinator.shared
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator.bluetooth)
                .environmentObject(coordinator.wakeWord)
                .onAppear {
                    coordinator.resumeServices()
                }
                .onChange(of: scenePhase) { _, newPhase in
                    coordinator.wakeWord.setAppInBackground(newPhase == .background)
                    if newPhase == .active {
                        coordinator.resumeServices()
                    }
                }
        }
    }
}

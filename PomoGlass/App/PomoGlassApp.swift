import SwiftUI
import Cocoa
import UserNotifications

@main
struct PomoGlassApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            // This is a dummy scene, the app is menu-bar-only.
            // A scene is still required for the app to compile with @main.
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    let state = AppState()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        popover = NSPopover()
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: PomodoroView(state: state))

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.action = #selector(togglePopover(_:))
            button.target = self
        }

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in // Changed to 1.0 second
            DispatchQueue.main.async { self.updateMenuBarButton() }
        }

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    func updateMenuBarButton() {
        guard let button = statusItem.button else { return }

        // Emoji Logic
        var icon = ""
        if state.showEmoji {
            if state.viewMode == .battery {
                icon = "🔋"
            } else {
                icon = (state.mode == "focus" || state.mode == "long_break") ? "🍅" : "☕️"
            }
        }

        // Mode logic reflected in Menu Bar
        if state.viewMode == .circle && !state.showEmoji {
            icon = state.isRunning ? "⏳" : "⭕️"
        }

        let spacing = icon.isEmpty ? "" : " "
        button.title = "\(icon)\(spacing)\(state.timeString())"

        // iOS Weight
        button.font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .semibold)
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            if popover.isShown { popover.performClose(sender) }
            else { popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY) }
        }
    }
}

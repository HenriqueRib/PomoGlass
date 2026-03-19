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
    private var keyMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        popover = NSPopover()
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ZStack { PomodoroView(state: state); KeyboardShortcutSupport(state: state) })

        // Atalho global Cmd+Shift+P para toggle (requer Acessibilidade em Preferências do Sistema)
        keyMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.modifierFlags.contains([.command, .shift]) && event.keyCode == 35 { // P
                DispatchQueue.main.async { self?.state.toggle() }
            }
        }

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.action = #selector(togglePopover(_:))
            button.target = self
        }

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in // Changed to 1.0 second
            DispatchQueue.main.async { self.updateMenuBarButton() }
        }

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }

        // Register for Distributed IPC commands from helper CLI
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(handleDistributedCommand(_:)), name: Notification.Name("com.pomoglass.command"), object: nil)
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

    @objc func handleDistributedCommand(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any], let action = userInfo["action"] as? String else { return }
        DispatchQueue.main.async {
            switch action {
            case "toggle":
                self.state.toggle()
            case "start":
                if let minutes = userInfo["minutes"] as? Int {
                    self.state.reset(to: Double(minutes), label: "focus")
                    self.state.start()
                } else {
                    self.state.start()
                }
            case "pause":
                self.state.pause()
            case "reset":
                if let minutes = userInfo["minutes"] as? Int {
                    self.state.reset(to: Double(minutes), label: "focus")
                }
            default:
                break
            }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        DistributedNotificationCenter.default().removeObserver(self)
        if let monitor = keyMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}

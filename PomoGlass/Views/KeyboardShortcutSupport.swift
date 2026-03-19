import SwiftUI
import AppKit

/// Atalho global Cmd+Shift+P para toggle do Pomodoro (registrado no AppDelegate).
struct KeyboardShortcutSupport: View {
    @ObservedObject var state: AppState
    var body: some View {
        EmptyView()
    }
}

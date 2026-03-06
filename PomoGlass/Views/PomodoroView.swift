import SwiftUI

struct PomodoroView: View {
    @ObservedObject var state: AppState
    
    var body: some View {
        ZStack {
            if state.isSettingsOpen {
                SettingsView(state: state)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
            } else {
                MainTimerView(state: state)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            }
        }
        .padding(25)
        .background(VisualEffectView(material: .fullScreenUI, blendingMode: .withinWindow))
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: state.isSettingsOpen)
    }
}

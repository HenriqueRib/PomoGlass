import SwiftUI

struct MainTimerView: View {
    @ObservedObject var state: AppState
    
    var body: some View {
        VStack(spacing: 15) {
            // Header
            HStack {
                Text(state.t(state.mode).uppercased())
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .foregroundColor(.secondary)
                    .tracking(2)
                Spacer()
                Button(action: { state.isSettingsOpen = true }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary.opacity(0.8))
                }.buttonStyle(PlainButtonStyle())
            }
            
            // Visualization
            ZStack {
                if state.viewMode != .battery {
                    Circle()
                        .stroke(Color.primary.opacity(0.04), lineWidth: 10)
                    Circle()
                        .trim(from: 0, to: state.progress())
                        .stroke(
                            LinearGradient(colors: state.themeGradient, startPoint: .topLeading, endPoint: .bottomTrailing),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut, value: state.timeLeft)
                }
                
                VStack(spacing: 5) {
                    if state.viewMode == .digital || state.viewMode == .circle {
                        Text(state.timeString())
                            .font(.system(size: 38, weight: .medium, design: .monospaced))
                    } else if state.viewMode == .battery {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 3)
                                .frame(width: 80, height: 40)
                            RoundedRectangle(cornerRadius: 3)
                                .fill(LinearGradient(colors: state.themeGradient, startPoint: .leading, endPoint: .trailing))
                                .frame(width: 72 * state.progress(), height: 32)
                                .padding(.leading, 4)
                        }
                        Text(state.timeString())
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(width: 160, height: 160)
            
            // Controls
            HStack(spacing: 25) {
                Button(action: { state.toggle() }) {
                    ZStack {
                        Circle()
                            .fill(state.isRunning ? Color.primary.opacity(0.05) : state.themeGradient[0])
                            .frame(width: 55, height: 55)
                        Image(systemName: state.isRunning ? "pause.fill" : "play.fill")
                            .foregroundColor(state.isRunning ? .primary : .white)
                            .font(.system(size: 20))
                    }
                }.buttonStyle(PlainButtonStyle())
                
                Button(action: { state.reset(to: state.focusDuration, label: "focus") }) {
                    ZStack {
                        Circle().fill(Color.primary.opacity(0.05)).frame(width: 55, height: 55)
                        Image(systemName: "arrow.counterclockwise").font(.system(size: 18, weight: .bold))
                    }
                }.buttonStyle(PlainButtonStyle())
            }
            
            HStack(spacing: 12) {
                ModeButton(title: state.t("focus"), active: state.mode == "focus", color: state.themeGradient[0]) {
                    state.reset(to: state.focusDuration, label: "focus")
                }
                ModeButton(title: state.t("break"), active: state.mode == "break", color: state.themeGradient[0]) {
                    state.reset(to: state.shortBreakDuration, label: "break")
                }
            }
        }
    }
}

import SwiftUI

struct SettingsView: View {
    @ObservedObject var state: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { state.isSettingsOpen = false }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                }.buttonStyle(PlainButtonStyle())
                
                Spacer()
                Text(state.t("settings"))
                    .font(.system(size: 14, weight: .bold))
                Spacer()
                
                Button(action: { NSApp.terminate(nil) }) {
                    Text(state.t("quit"))
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.red)
                }.buttonStyle(PlainButtonStyle())
            }
            .padding(.bottom, 20)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    
                    HStack(spacing: 8) { // Reduced spacing
                        // Language
                        Picker(selection: $state.language) {
                            ForEach(Language.allCases) { lang in
                                Text("\(lang.icon) \(lang.name)").tag(lang)
                            }
                        } label: {
                            Text(state.language.icon) // Use icon as label
                        }
                        .pickerStyle(MenuPickerStyle())
                        .fixedSize() // Make picker compact

                        // Sound
                        Picker(selection: $state.selectedSound) {
                            ForEach(NotificationSound.allCases) { sound in
                                Text(sound.rawValue).tag(sound)
                            }
                        } label: {
                            Image(systemName: "speaker.wave.2.fill") // Use system icon as label
                        }
                        .pickerStyle(MenuPickerStyle())
                        .fixedSize() // Make picker compact
                        
                        Spacer()

                        // Color
                        HStack(spacing: 6) {
                            ForEach(colorGradients.indices, id: \.self) { index in
                                Circle()
                                    .fill(LinearGradient(colors: colorGradients[index].colors, startPoint: .top, endPoint: .bottom))
                                    .frame(width: 18, height: 18)
                                    .overlay(Circle().stroke(Color.primary, lineWidth: state.selectedGradientIndex == index ? 1.5 : 0))
                                    .onTapGesture { state.selectedGradientIndex = index }
                            }
                        }
                    }
                    // Removed .labelsHidden() as explicit label is provided
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.primary.opacity(0.03))
                    .cornerRadius(10)
                    
                    // Timer Settings
                    SettingsRow(icon: "timer", title: state.t("focus_duration")) {
                        HStack {
                            Text("\(Int(state.focusDuration)) min")
                            Stepper("", value: $state.focusDuration, in: 1...60)
                        }
                    }
                    SettingsRow(icon: "cup.and.saucer", title: state.t("short_break_duration")) {
                        HStack {
                            Text("\(Int(state.shortBreakDuration)) min")
                            Stepper("", value: $state.shortBreakDuration, in: 1...30)
                        }
                    }
                    SettingsRow(icon: "bed.double", title: state.t("long_break_duration")) {
                        HStack {
                            Text("\(Int(state.longBreakDuration)) min")
                            Stepper("", value: $state.longBreakDuration, in: 5...60)
                        }
                    }
                    
                    SettingsRow(icon: "hourglass", title: state.t("long_break_interval")) {
                        HStack {
                            Text("\(state.longBreakInterval) sessions")
                            Stepper("", value: $state.longBreakInterval, in: 1...10)
                        }
                    }
                    SettingsRow(icon: "chart.bar", title: state.t("sessions_completed")) {
                        HStack {
                            Text("\(state.sessionCount)")
                            Button("Reset") {
                                state.sessionCount = 0
                            }
                        }
                    }
                    
                    SettingsRow(icon: "star.fill", title: state.t("experience_points")) {
                        HStack {
                            Text("\(state.experiencePoints) XP")
                            Button("Reset") {
                                state.experiencePoints = 0
                            }
                        }
                    }
                    
                    // Emoji Toggle
                    SettingsRow(icon: "face.smiling", title: state.t("show_emoji")) {
                        Toggle("", isOn: $state.showEmoji)
                            .toggleStyle(SwitchToggleStyle(tint: state.themeGradient[0]))
                            .fixedSize() // Prevent the toggle from resizing
                            .scaleEffect(0.8)
                    }
                    
                }
            }
        }
        .onChange(of: state.selectedSound) {
            state.playSoundPreview()
        }
    }
}

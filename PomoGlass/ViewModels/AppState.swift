import Cocoa
import SwiftUI
import UserNotifications
import Combine

// MARK: - App State

class AppState: ObservableObject {
    @Published var timeLeft: Double = 1500
    @Published var totalTime: Double = 1500
    @Published var isRunning: Bool = false
    @Published var mode: String = "focus"
    
    // Settings
    @AppStorage("language") var language: Language = .english { willSet { objectWillChange.send() } }
    @AppStorage("viewMode") var viewMode: TimerViewMode = .digital
    @AppStorage("selectedGradientIndex") var selectedGradientIndex: Int = 0
    @AppStorage("selectedSound") var selectedSound: NotificationSound = .glass
    @AppStorage("showEmoji") var showEmoji: Bool = true
    
    @AppStorage("focusDuration") var focusDuration: Double = 25 {
        willSet {
            if mode == "focus" && !isRunning {
                totalTime = newValue * 60
                timeLeft = totalTime
                objectWillChange.send() // Notify observers
            }
        }
    }
    @AppStorage("shortBreakDuration") var shortBreakDuration: Double = 5 {
        willSet {
            if mode == "break" && !isRunning {
                totalTime = newValue * 60
                timeLeft = totalTime
                objectWillChange.send() // Notify observers
            }
        }
    }
    @AppStorage("longBreakDuration") var longBreakDuration: Double = 15
    @AppStorage("sessionCount") var sessionCount: Int = 0
    @AppStorage("longBreakInterval") var longBreakInterval: Int = 4
    @AppStorage("experiencePoints") var experiencePoints: Int = 0

    @Published var isSettingsOpen: Bool = false
    
    private var timer: Timer?
    
    var themeGradient: [Color] { colorGradients[selectedGradientIndex].colors }

    func t(_ key: String) -> String { Translations.get(key, for: language) }
    
    func toggle() {
        if isRunning { pause() } else { start() }
    }
    
    func start() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                if self.timeLeft > 0 {
                    self.timeLeft -= 1.0
                } else {
                    self.complete()
                }
            }
        }
    }
    
    func pause() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func reset(to minutes: Double, label: String) {
        pause()
        mode = label
        totalTime = minutes * 60
        timeLeft = totalTime
    }
    
    func complete() {
        pause()
        NSSound(named: selectedSound.rawValue)?.play()
        
        let content = UNMutableNotificationContent()
        content.title = t("done_title")
        
        if mode == "focus" {
            experiencePoints += Int(focusDuration) // Award XP for focus session
            sessionCount += 1
            if sessionCount % longBreakInterval == 0 {
                content.body = t("done_long_break")
                reset(to: longBreakDuration, label: "long_break")
            } else {
                content.body = t("done_focus")
                reset(to: shortBreakDuration, label: "break")
            }
        } else if mode == "break" { // It was a short break
            experiencePoints += Int(shortBreakDuration) // Award XP for short break
            content.body = t("done_break")
            reset(to: focusDuration, label: "focus")
        } else if mode == "long_break" { // It was a long break
            experiencePoints += Int(longBreakDuration) // Award XP for long break
            content.body = t("done_break") // Can be done_long_break or a new translation for "back to work after long break"
            reset(to: focusDuration, label: "focus")
        }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
    
    func playSoundPreview() {
        NSSound(named: selectedSound.rawValue)?.play()
    }
    
    func progress() -> Double { timeLeft / totalTime }
    
    func timeString() -> String {
        let mins = Int(timeLeft) / 60
        let secs = Int(timeLeft) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

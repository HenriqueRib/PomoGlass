import Cocoa
import SwiftUI
import UserNotifications
import Combine

// MARK: - Constants & Types

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case portuguese = "pt"
    case spanish = "es"
    var id: String { self.rawValue }
    
    var name: String {
        switch self {
        case .english: return "English"
        case .portuguese: return "Português"
        case .spanish: return "Español"
        }
    }
    
    var icon: String {
        switch self {
        case .english: return "🇺🇸"
        case .portuguese: return "🇧🇷"
        case .spanish: return "🇪🇸"
        }
    }
}

enum TimerViewMode: String, CaseIterable, Identifiable {
    case digital = "Digital"
    case circle = "Circle"
    case battery = "Battery"
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .digital: return "timer"
        case .circle: return "circle.circle"
        case .battery: return "battery.75"
        }
    }
}

enum NotificationSound: String, CaseIterable, Identifiable {
    case glass = "Glass"
    case blow = "Blow"
    case bottle = "Bottle"
    case tink = "Tink"
    case submarine = "Submarine"
    case hero = "Hero"
    var id: String { self.rawValue }
}

struct AppColorGradient: Identifiable {
    let id = UUID()
    let name: String
    let colors: [Color]
}

let colorGradients: [AppColorGradient] = [
    AppColorGradient(name: "Sunset", colors: [.orange, .red]),
    AppColorGradient(name: "Forest", colors: [.green, .teal]),
    AppColorGradient(name: "Ocean", colors: [.blue, .cyan]),
    AppColorGradient(name: "Purple", colors: [.purple, .pink])
]

// MARK: - Localization

struct Translations {
    static func get(_ key: String, for lang: Language) -> String {
        let dict: [Language: [String: String]] = [
            .english: [
                "focus": "Focus", "break": "Break", "settings": "Settings",
                "language": "Language", "sound": "Alert Sound", "view": "Display Style",
                "color": "Theme Color", "show_emoji": "Show Emoji", "quit": "Quit App",
                "reset": "Reset Timer", "done_title": "Time's up! 🍎",
                "done_focus": "Break time begins.", "done_break": "Back to work!",
                "back": "General"
            ],
            .portuguese: [
                "focus": "Foco", "break": "Pausa", "settings": "Ajustes",
                "language": "Idioma", "sound": "Som de Alerta", "view": "Estilo Visual",
                "color": "Cor do Tema", "show_emoji": "Mostrar Emoji", "quit": "Encerrar",
                "reset": "Reiniciar", "done_title": "Acabou! 🍎",
                "done_focus": "Hora de descansar.", "done_break": "Hora de focar!",
                "back": "Geral"
            ],
            .spanish: [
                "focus": "Enfoque", "break": "Descanso", "settings": "Ajustes",
                "language": "Idioma", "sound": "Sonido de Alerta", "view": "Estilo Visual",
                "color": "Color del Tema", "show_emoji": "Mostrar Emoji", "quit": "Cerrar",
                "reset": "Reiniciar", "done_title": "¡Tiempo agotado! 🍎",
                "done_focus": "Hora del descanso.", "done_break": "¡A trabajar!",
                "back": "General"
            ]
        ]
        return dict[lang]?[key] ?? key
    }
}

// MARK: - App State

class AppState: ObservableObject {
    @Published var timeLeft: Double = 1500
    @Published var totalTime: Double = 1500
    @Published var isRunning: Bool = false
    @Published var mode: String = "focus"
    
    // Settings
    @Published var language: Language = .english
    @Published var viewMode: TimerViewMode = .digital
    @Published var selectedGradientIndex: Int = 0
    @Published var selectedSound: NotificationSound = .glass {
        didSet { playSoundPreview() }
    }
    @Published var showEmoji: Bool = true
    @Published var isSettingsOpen: Bool = false
    
    private var timer: Timer?
    
    var themeGradient: [Color] { colorGradients[selectedGradientIndex].colors }
    
    func t(_ key: String) -> String { Translations.get(key, for: language) }
    
    func toggle() {
        if isRunning { pause() } else { start() }
    }
    
    func start() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            DispatchQueue.main.async {
                if self.timeLeft > 0 {
                    self.timeLeft -= 0.1
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
        content.body = mode == "focus" ? t("done_focus") : t("done_break")
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
        
        if mode == "focus" { reset(to: 5, label: "break") } else { reset(to: 25, label: "focus") }
    }
    
    private func playSoundPreview() {
        NSSound(named: selectedSound.rawValue)?.play()
    }
    
    func progress() -> Double { timeLeft / totalTime }
    
    func timeString() -> String {
        let mins = Int(timeLeft) / 60
        let secs = Int(timeLeft) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

// MARK: - UI Views

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

struct SettingsRow<Content: View>: View {
    let icon: String?
    let title: String
    let content: Content
    
    init(icon: String? = nil, title: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                    .frame(width: 20)
            }
            Text(title)
                .font(.system(size: 13, weight: .medium))
            Spacer()
            content
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.primary.opacity(0.03))
        .cornerRadius(10)
    }
}

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
                    
                    // Language
                    SettingsRow(icon: "globe", title: state.t("language")) {
                        Picker("", selection: $state.language) {
                            ForEach(Language.allCases) { lang in
                                Text("\(lang.icon) \(lang.name)").tag(lang)
                            }
                        }
                        .frame(width: 110)
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    // Display Mode
                    SettingsRow(icon: "macwindow", title: state.t("view")) {
                        Picker("", selection: $state.viewMode) {
                            ForEach(TimerViewMode.allCases) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .frame(width: 100)
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    // Finish Sound
                    SettingsRow(icon: "speaker.wave.2", title: state.t("sound")) {
                        Picker("", selection: $state.selectedSound) {
                            ForEach(NotificationSound.allCases) { sound in
                                Text(sound.rawValue).tag(sound)
                            }
                        }
                        .frame(width: 100)
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    // Color Theme
                    SettingsRow(icon: "paintbrush", title: state.t("color")) {
                        HStack(spacing: 8) {
                            ForEach(colorGradients.indices, id: \.self) { index in
                                Circle()
                                    .fill(LinearGradient(colors: colorGradients[index].colors, startPoint: .top, endPoint: .bottom))
                                    .frame(width: 18, height: 18)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: state.selectedGradientIndex == index ? 1.5 : 0)
                                    )
                                    .onTapGesture { state.selectedGradientIndex = index }
                            }
                        }
                    }
                    
                    // Emoji Toggle
                    SettingsRow(icon: "face.smiling", title: state.t("show_emoji")) {
                        Toggle("", isOn: $state.showEmoji)
                            .toggleStyle(SwitchToggleStyle(tint: state.themeGradient[0]))
                            .scaleEffect(0.8)
                    }
                    
                }
            }
        }
    }
}

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
                
                Button(action: { state.reset(to: 25, label: "focus") }) {
                    ZStack {
                        Circle().fill(Color.primary.opacity(0.05)).frame(width: 55, height: 55)
                        Image(systemName: "arrow.counterclockwise").font(.system(size: 18, weight: .bold))
                    }
                }.buttonStyle(PlainButtonStyle())
            }
            
            HStack(spacing: 12) {
                ModeButton(title: state.t("focus"), active: state.mode == "focus", color: state.themeGradient[0]) {
                    state.reset(to: 25, label: "focus")
                }
                ModeButton(title: state.t("break"), active: state.mode == "break", color: state.themeGradient[0]) {
                    state.reset(to: 5, label: "break")
                }
            }
        }
    }
}

struct ModeButton: View {
    let title: String
    let active: Bool
    let color: Color
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).font(.system(size: 12, weight: .bold))
                .padding(.horizontal, 18).padding(.vertical, 10)
                .background(active ? color.opacity(0.12) : Color.primary.opacity(0.04))
                .foregroundColor(active ? color : Color.secondary)
                .cornerRadius(14)
        }.buttonStyle(PlainButtonStyle())
    }
}

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
        .frame(width: 260, height: 440)
        .background(VisualEffectView(material: .popover, blendingMode: .withinWindow))
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: state.isSettingsOpen)
    }
}

// MARK: - App Architecture (Entry)

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    let state = AppState()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        popover = NSPopover()
        popover.contentSize = NSSize(width: 260, height: 440)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: PomodoroView(state: state))
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
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
                icon = state.mode == "focus" ? "🍅" : "☕️"
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

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()

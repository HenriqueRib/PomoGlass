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
}

enum TimerViewMode: String, CaseIterable, Identifiable {
    case digital = "Digital"
    case circle = "Circle"
    case battery = "Battery"
    var id: String { self.rawValue }
}

enum NotificationSound: String, CaseIterable, Identifiable {
    case glass = "Glass"
    case submarine = "Submarine"
    case blow = "Blow"
    case tink = "Tink"
    var id: String { self.rawValue }
}

struct AppColorGradient {
    let name: String
    let colors: [Color]
}

let colorGradients: [AppColorGradient] = [
    AppColorGradient(name: "Sunset", colors: [.orange, .red]),
    AppColorGradient(name: "Forest", colors: [.green, .emerald]),
    AppColorGradient(name: "Ocean", colors: [.blue, .cyan]),
    AppColorGradient(name: "Purple", colors: [.purple, .pink])
]

extension Color {
    static let emerald = Color(red: 16/255, green: 185/255, blue: 129/255)
}

// MARK: - Localization

struct Translations {
    static func get(_ key: String, for lang: Language) -> String {
        let dict: [Language: [String: String]] = [
            .english: [
                "focus": "Focus", "break": "Break", "settings": "Settings",
                "language": "Language", "sound": "Finish Sound", "view": "Display Mode",
                "color": "Theme Color", "show_emoji": "Show Emoji", "quit": "Quit App",
                "reset": "Reset", "done_title": "Session Finished! 🍎",
                "done_focus": "Time for a break!", "done_break": "Ready to focus?",
                "back": "Back"
            ],
            .portuguese: [
                "focus": "Foco", "break": "Pausa", "settings": "Configurações",
                "language": "Idioma", "sound": "Som ao terminar", "view": "Modo de Visão",
                "color": "Cor do Tema", "show_emoji": "Mostrar Emoji", "quit": "Encerrar App",
                "reset": "Reiniciar", "done_title": "Sessão Concluída! 🍎",
                "done_focus": "Hora de uma pausa!", "done_break": "Vamos voltar ao foco?",
                "back": "Voltar"
            ],
            .spanish: [
                "focus": "Enfoque", "break": "Descanso", "settings": "Ajustes",
                "language": "Idioma", "sound": "Sonido al terminar", "view": "Modo de Vista",
                "color": "Color del Tema", "show_emoji": "Mostrar Emoji", "quit": "Cerrar App",
                "reset": "Reiniciar", "done_title": "¡Sesión terminada! 🍎",
                "done_focus": "¡Hora de un descanso!", "done_break": "¿Listo para enfocar?",
                "back": "Volver"
            ]
        ]
        return dict[lang]?[key] ?? key
    }
}

// MARK: - App State (MVVM)

class AppState: ObservableObject {
    // Timer Logic
    @Published var timeLeft: Double = 1500
    @Published var totalTime: Double = 1500
    @Published var isRunning: Bool = false
    @Published var mode: String = "focus"
    
    // Settings (Persistence could be added here later)
    @Published var language: Language = .english
    @Published var viewMode: TimerViewMode = .digital
    @Published var selectedGradientIndex: Int = 0
    @Published var selectedSound: NotificationSound = .glass
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
        
        // Notification
        let content = UNMutableNotificationContent()
        content.title = t("done_title")
        content.body = mode == "focus" ? t("done_focus") : t("done_break")
        
        // Play notification sound
        NSSound(named: selectedSound.rawValue)?.play()
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
        
        // Auto Reset
        if mode == "focus" { reset(to: 5, label: "break") } else { reset(to: 25, label: "focus") }
    }
    
    func progress() -> Double { timeLeft / totalTime }
    
    func timeString() -> String {
        let mins = Int(timeLeft) / 60
        let secs = Int(timeLeft) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

// MARK: - UI Components

struct BatteryIcon: View {
    let progress: Double
    let colors: [Color]
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.primary.opacity(0.1), lineWidth: 2)
                .frame(width: 60, height: 30)
            
            RoundedRectangle(cornerRadius: 2)
                .fill(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
                .frame(width: 54 * progress, height: 24)
                .padding(.leading, 3)
            
            // Battery tip
            RoundedRectangle(cornerRadius: 1)
                .fill(Color.primary.opacity(0.1))
                .frame(width: 4, height: 12)
                .offset(x: 62)
        }
    }
}

struct MainTimerView: View {
    @ObservedObject var state: AppState
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text(state.t(state.mode).uppercased())
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .foregroundColor(.secondary)
                    .tracking(2)
                Spacer()
                Button(action: { state.isSettingsOpen = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary.opacity(0.6))
                }.buttonStyle(PlainButtonStyle())
            }
            
            // Central Visualization
            ZStack {
                if state.viewMode == .circle || state.viewMode == .digital {
                    Circle()
                        .stroke(Color.primary.opacity(0.05), lineWidth: 10)
                    
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
                            .font(.system(size: 36, weight: .medium, design: .monospaced))
                    } else if state.viewMode == .battery {
                        BatteryIcon(progress: state.progress(), colors: state.themeGradient)
                        Text(state.timeString())
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(width: 150, height: 150)
            .padding(.vertical, 10)
            
            // Controls
            HStack(spacing: 20) {
                Button(action: { state.toggle() }) {
                    ZStack {
                        Circle()
                            .fill(state.isRunning ? Color.primary.opacity(0.05) : state.themeGradient[0])
                            .frame(width: 50, height: 50)
                        Image(systemName: state.isRunning ? "pause.fill" : "play.fill")
                            .foregroundColor(state.isRunning ? .primary : .white)
                    }
                }.buttonStyle(PlainButtonStyle())
                
                Button(action: { state.reset(to: 25, label: "focus") }) {
                    ZStack {
                        Circle().fill(Color.primary.opacity(0.05)).frame(width: 50, height: 50)
                        Image(systemName: "arrow.counterclockwise").font(.system(size: 18, weight: .bold))
                    }
                }.buttonStyle(PlainButtonStyle())
            }
            
            HStack(spacing: 10) {
                ModeTag(title: state.t("focus"), active: state.mode == "focus", color: state.themeGradient[0]) {
                    state.reset(to: 25, label: "focus")
                }
                ModeTag(title: state.t("break"), active: state.mode == "break", color: state.themeGradient[0]) {
                    state.reset(to: 5, label: "break")
                }
            }
        }
    }
}

struct SettingsView: View {
    @ObservedObject var state: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Button(action: { state.isSettingsOpen = false }) {
                    Image(systemName: "chevron.left").font(.system(size: 14, weight: .bold))
                    Text(state.t("back")).font(.system(size: 14, weight: .bold))
                }.buttonStyle(PlainButtonStyle())
                Spacer()
                Text(state.t("settings")).font(.system(size: 12, weight: .black))
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Group {
                        SettingSection(title: state.t("language")) {
                            Picker("", selection: $state.language) {
                                ForEach(Language.allCases) { lang in
                                    Text(lang.name).tag(lang)
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                        
                        SettingSection(title: state.t("view")) {
                            Picker("", selection: $state.viewMode) {
                                ForEach(TimerViewMode.allCases) { mode in
                                    Text(mode.rawValue).tag(mode)
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                        
                        SettingSection(title: state.t("sound")) {
                            Picker("", selection: $state.selectedSound) {
                                ForEach(NotificationSound.allCases) { sound in
                                    Text(sound.rawValue).tag(sound)
                                }
                            }
                        }
                    }
                    
                    SettingSection(title: state.t("color")) {
                        HStack {
                            ForEach(colorGradients.indices, id: \.self) { index in
                                Circle()
                                    .fill(LinearGradient(colors: colorGradients[index].colors, startPoint: .top, endPoint: .bottom))
                                    .frame(width: 25, height: 25)
                                    .overlay(Circle().stroke(Color.primary, lineWidth: state.selectedGradientIndex == index ? 2 : 0))
                                    .onTapGesture { state.selectedGradientIndex = index }
                            }
                        }
                    }
                    
                    Toggle(state.t("show_emoji"), isOn: $state.showEmoji)
                        .font(.system(size: 12, weight: .medium))
                    
                    Divider()
                    
                    Button(state.t("quit")) { NSApp.terminate(nil) }
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.red.opacity(0.8))
                }
            }
        }
    }
}

struct SettingSection<Content: View>: View {
    let title: String
    let content: Content
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title.uppercased()).font(.system(size: 9, weight: .black)).foregroundColor(.secondary)
            content
        }
    }
}

struct ModeTag: View {
    let title: String
    let active: Bool
    let color: Color
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).font(.system(size: 12, weight: .bold))
                .padding(.horizontal, 15).padding(.vertical, 8)
                .background(active ? color.opacity(0.15) : Color.clear)
                .foregroundColor(active ? color : Color.primary.opacity(0.4))
                .cornerRadius(12)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct PomodoroView: View {
    @ObservedObject var state: AppState
    
    var body: some View {
        ZStack {
            if state.isSettingsOpen {
                SettingsView(state: state)
                    .transition(.move(edge: .trailing))
            } else {
                MainTimerView(state: state)
                    .transition(.move(edge: .leading))
            }
        }
        .padding(25)
        .frame(width: 250, height: 420)
        .background(VisualEffectView(material: .popover, blendingMode: .withinWindow))
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: state.isSettingsOpen)
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material; view.blendingMode = blendingMode; view.state = .active
        return view
    }
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

// MARK: - App Architecture (Entry)

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    let state = AppState()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        popover = NSPopover()
        popover.contentSize = NSSize(width: 250, height: 420)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: PomodoroView(state: state))
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async { self.updateMenuBarButton() }
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
    
    func updateMenuBarButton() {
        guard let button = statusItem.button else { return }
        let emoji = state.showEmoji ? (state.mode == "focus" ? "🍅" : "☕️") : ""
        let spacing = state.showEmoji ? " " : ""
        button.title = "\(emoji)\(spacing)\(state.timeString())"
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

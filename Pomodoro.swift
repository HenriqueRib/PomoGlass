import Cocoa
import SwiftUI
import UserNotifications

// --- Model (Gerenciador de Tempo) ---
class PomodoroModel: ObservableObject {
    @Published var timeLeft: Double = 1500
    @Published var totalTime: Double = 1500
    @Published var isRunning: Bool = false
    @Published var mode: String = "Foco"
    
    private var timer: Timer?
    
    func toggle() {
        if isRunning { pause() } else { start() }
        objectWillChange.send()
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
        // Notificação Nativa
        let content = UNMutableNotificationContent()
        content.title = "Sessão Concluída! 🍎"
        content.body = mode == "Foco" ? "Hora de uma pausa!" : "Vamos voltar ao foco?"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
        
        // Reset automático
        if mode == "Foco" {
            reset(to: 5, label: "Pausa")
        } else {
            reset(to: 25, label: "Foco")
        }
    }
    
    func progress() -> Double {
        timeLeft / totalTime
    }
    
    func timeString() -> String {
        let mins = Int(timeLeft) / 60
        let secs = Int(timeLeft) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

// --- UI (Design Estilo iOS Widget) ---
struct PomodoroView: View {
    @ObservedObject var model: PomodoroModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text(model.mode.uppercased())
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .foregroundColor(.secondary)
                    .tracking(2)
                Spacer()
                if model.isRunning {
                    Circle().fill(Color.orange).frame(width: 6, height: 6)
                }
            }
            
            // Progress Center
            ZStack {
                Circle()
                    .stroke(Color.primary.opacity(0.05), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: model.progress())
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: model.timeLeft)
                
                VStack(spacing: -2) {
                    Text(model.timeString())
                        .font(.system(size: 36, weight: .medium, design: .monospaced))
                        .foregroundColor(.primary)
                }
            }
            .frame(width: 150, height: 150)
            .padding(.vertical, 10)
            
            // Interaction Buttons
            HStack(spacing: 20) {
                // Main Button
                Button(action: { model.toggle() }) {
                    ZStack {
                        Circle()
                            .fill(model.isRunning ? Color.primary.opacity(0.05) : Color.orange)
                            .frame(width: 50, height: 50)
                        Image(systemName: model.isRunning ? "pause.fill" : "play.fill")
                            .foregroundColor(model.isRunning ? .primary : .white)
                            .font(.system(size: 20))
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Restart Button
                Button(action: { model.reset(to: 25, label: "Foco") }) {
                    ZStack {
                        Circle()
                            .fill(Color.primary.opacity(0.05))
                            .frame(width: 50, height: 50)
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(.primary)
                            .font(.system(size: 18, weight: .bold))
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Mode Toggles
            HStack(spacing: 10) {
                ModeTag(title: "Foco", active: model.mode == "Foco") { model.reset(to: 25, label: "Foco") }
                ModeTag(title: "Pausa", active: model.mode == "Pausa") { model.reset(to: 5, label: "Pausa") }
            }
            
            Divider().padding(.vertical, 5)
            
            Button("Encerrar App") {
                NSApp.terminate(nil)
            }
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.secondary)
            .buttonStyle(PlainButtonStyle())
        }
        .padding(25)
        .frame(width: 250)
        .background(VisualEffectView(material: .popover, blendingMode: .withinWindow))
    }
}

struct ModeTag: View {
    let title: String
    let active: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(active ? Color.orange.opacity(0.15) : Color.clear)
                .foregroundColor(active ? Color.orange : Color.primary.opacity(0.4))
                .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

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

// --- App Entry (Logic & Popover) ---
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    let model = PomodoroModel()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        // Configurar Popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 250, height: 420)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: PomodoroView(model: model))
        
        // Configurar Item de Menu Bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.title = "🍅 25:00"
            button.font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .semibold)
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
        
        // Loop de atualização do título da barra
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                if let button = self.statusItem.button {
                    let icon = self.model.isRunning ? "⏳" : "🍅"
                    button.title = "\(icon) \(self.model.timeString())"
                }
            }
        }
        
        // Pedir permissão para notificações
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()

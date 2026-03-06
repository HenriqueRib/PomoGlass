import SwiftUI

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

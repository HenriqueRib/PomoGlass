import Foundation

// MARK: - Localization

struct Translations {
    static func get(_ key: String, for lang: Language) -> String {
        let dict: [Language: [String: String]] = [
            .english: [
                "focus": "Focus", "break": "Break", "settings": "Settings",
                "language": "Language", "sound": "Alert Sound", "show_emoji": "Show Emoji", "quit": "Quit App",
                "reset": "Reset Timer", "done_title": "Time's up! 🍎",
                "done_focus": "Break time begins.", "done_break": "Back to work!",
                "back": "General",
                "focus_duration": "Focus Duration", "short_break_duration": "Short Break", "long_break_duration": "Long Break",
                "done_long_break": "Time for a long break! 😴", "long_break": "Long Break",
                "long_break_interval": "Long Break Every", "sessions_completed": "Sessions Completed", "experience_points": "Experience Points"
                ],
                .portuguese: [
                "focus": "Foco", "break": "Pausa", "settings": "Ajustes",
                "language": "Idioma", "sound": "Som de Alerta", "show_emoji": "Mostrar Emoji", "quit": "Encerrar",
                "reset": "Reiniciar", "done_title": "Acabou! 🍎",
                "done_focus": "Hora de descansar.", "done_break": "Hora de focar!",
                "back": "Geral",
                "focus_duration": "Duração do Foco", "short_break_duration": "Pausa Curta", "long_break_duration": "Pausa Longa",
                "done_long_break": "Hora de uma pausa longa! 😴", "long_break": "Pausa Longa",
                "long_break_interval": "Pausa Longa a Cada", "sessions_completed": "Sessões Concluídas", "experience_points": "Pontos de Experiência"
                ],
                .spanish: [
                "focus": "Enfoque", "break": "Descanso", "settings": "Ajustes",
                "language": "Idioma", "sound": "Sonido de Alerta", "show_emoji": "Mostrar Emoji", "quit": "Cerrar",
                "reset": "Reiniciar", "done_title": "¡Tiempo agotado! 🍎",
                "done_focus": "Hora del descanso.", "done_break": "¡A trabalhar!",
                "back": "Geral",
                "focus_duration": "Duración de Enfoque", "short_break_duration": "Descanso Corto", "long_break_duration": "Descanso Largo",
                "done_long_break": "¡Hora de un descanso largo! 😴", "long_break": "Descanso Largo",
                "long_break_interval": "Descanso Largo Cada", "sessions_completed": "Sesiones Completadas", "experience_points": "Puntos de Experiencia"
                ]
        ]
        return dict[lang]?[key] ?? key
    }
}

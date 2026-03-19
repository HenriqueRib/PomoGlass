import XCTest
#if canImport(SwiftUI)
import SwiftUI
#endif
@testable import PomoGlassCore

final class TranslationsTests: XCTestCase {
    
    // MARK: - English Translations
    
    func testEnglishBasicTranslations() {
        XCTAssertEqual(Translations.get("focus", for: .english), "Focus")
        XCTAssertEqual(Translations.get("break", for: .english), "Break")
        XCTAssertEqual(Translations.get("settings", for: .english), "Settings")
    }
    
    func testEnglishSettingsTranslations() {
        XCTAssertEqual(Translations.get("language", for: .english), "Language")
        XCTAssertEqual(Translations.get("sound", for: .english), "Alert Sound")
        XCTAssertEqual(Translations.get("show_emoji", for: .english), "Show Emoji")
        XCTAssertEqual(Translations.get("quit", for: .english), "Quit App")
    }
    
    func testEnglishTimerTranslations() {
        XCTAssertEqual(Translations.get("reset", for: .english), "Reset Timer")
        XCTAssertEqual(Translations.get("done_title", for: .english), "Time's up! 🍎")
        XCTAssertEqual(Translations.get("done_focus", for: .english), "Break time begins.")
        XCTAssertEqual(Translations.get("done_break", for: .english), "Back to work!")
    }
    
    func testEnglishDurationTranslations() {
        XCTAssertEqual(Translations.get("focus_duration", for: .english), "Focus Duration")
        XCTAssertEqual(Translations.get("short_break_duration", for: .english), "Short Break")
        XCTAssertEqual(Translations.get("long_break_duration", for: .english), "Long Break")
    }
    
    // MARK: - Portuguese Translations
    
    func testPortugueseBasicTranslations() {
        XCTAssertEqual(Translations.get("focus", for: .portuguese), "Foco")
        XCTAssertEqual(Translations.get("break", for: .portuguese), "Pausa")
        XCTAssertEqual(Translations.get("settings", for: .portuguese), "Ajustes")
    }
    
    func testPortugueseSettingsTranslations() {
        XCTAssertEqual(Translations.get("language", for: .portuguese), "Idioma")
        XCTAssertEqual(Translations.get("sound", for: .portuguese), "Som de Alerta")
        XCTAssertEqual(Translations.get("show_emoji", for: .portuguese), "Mostrar Emoji")
        XCTAssertEqual(Translations.get("quit", for: .portuguese), "Encerrar")
    }
    
    func testPortugueseTimerTranslations() {
        XCTAssertEqual(Translations.get("reset", for: .portuguese), "Reiniciar")
        XCTAssertEqual(Translations.get("done_title", for: .portuguese), "Acabou! 🍎")
        XCTAssertEqual(Translations.get("done_focus", for: .portuguese), "Hora de descansar.")
        XCTAssertEqual(Translations.get("done_break", for: .portuguese), "Hora de focar!")
    }
    
    // MARK: - Spanish Translations
    
    func testSpanishBasicTranslations() {
        XCTAssertEqual(Translations.get("focus", for: .spanish), "Enfoque")
        XCTAssertEqual(Translations.get("break", for: .spanish), "Descanso")
        XCTAssertEqual(Translations.get("settings", for: .spanish), "Ajustes")
    }
    
    func testSpanishSettingsTranslations() {
        XCTAssertEqual(Translations.get("language", for: .spanish), "Idioma")
        XCTAssertEqual(Translations.get("sound", for: .spanish), "Sonido de Alerta")
        XCTAssertEqual(Translations.get("show_emoji", for: .spanish), "Mostrar Emoji")
        XCTAssertEqual(Translations.get("quit", for: .spanish), "Cerrar")
    }
    
    func testSpanishTimerTranslations() {
        XCTAssertEqual(Translations.get("reset", for: .spanish), "Reiniciar")
        XCTAssertEqual(Translations.get("done_title", for: .spanish), "¡Tiempo agotado! 🍎")
        XCTAssertEqual(Translations.get("done_focus", for: .spanish), "Hora del descanso.")
        XCTAssertEqual(Translations.get("done_break", for: .spanish), "¡A trabalhar!")
    }
    
    // MARK: - Fallback Behavior
    
    func testUnknownKeyReturnsSameKey() {
        let unknownKey = "unknown_key_that_does_not_exist"
        XCTAssertEqual(Translations.get(unknownKey, for: .english), unknownKey)
        XCTAssertEqual(Translations.get(unknownKey, for: .portuguese), unknownKey)
        XCTAssertEqual(Translations.get(unknownKey, for: .spanish), unknownKey)
    }
    
    // MARK: - Consistency Tests
    
    func testAllLanguagesHaveSameKeys() {
        let keysToTest = [
            "focus", "break", "settings", "language", "sound", "show_emoji", 
            "quit", "reset", "done_title", "done_focus", "done_break", "back",
            "focus_duration", "short_break_duration", "long_break_duration",
            "done_long_break", "long_break", "long_break_interval",
            "sessions_completed", "experience_points"
        ]
        
        for key in keysToTest {
            let englishValue = Translations.get(key, for: .english)
            let portugueseValue = Translations.get(key, for: .portuguese)
            let spanishValue = Translations.get(key, for: .spanish)
            
            XCTAssertNotEqual(englishValue, key, "English translation missing for key: \(key)")
            XCTAssertNotEqual(portugueseValue, key, "Portuguese translation missing for key: \(key)")
            XCTAssertNotEqual(spanishValue, key, "Spanish translation missing for key: \(key)")
        }
    }
    
    func testTranslationsAreNotEmpty() {
        let keysToTest = ["focus", "break", "settings", "quit"]
        
        for key in keysToTest {
            for language in Language.allCases {
                let translation = Translations.get(key, for: language)
                XCTAssertFalse(translation.isEmpty, "Translation for '\(key)' in \(language.name) should not be empty")
            }
        }
    }
}

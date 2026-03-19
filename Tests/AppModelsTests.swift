import XCTest
#if canImport(SwiftUI)
import SwiftUI
#endif
@testable import PomoGlassCore

final class LanguageTests: XCTestCase {
    
    func testLanguageRawValues() {
        XCTAssertEqual(Language.english.rawValue, "en")
        XCTAssertEqual(Language.portuguese.rawValue, "pt")
        XCTAssertEqual(Language.spanish.rawValue, "es")
    }
    
    func testLanguageNames() {
        XCTAssertEqual(Language.english.name, "English")
        XCTAssertEqual(Language.portuguese.name, "Português")
        XCTAssertEqual(Language.spanish.name, "Español")
    }
    
    func testLanguageIcons() {
        XCTAssertEqual(Language.english.icon, "🇺🇸")
        XCTAssertEqual(Language.portuguese.icon, "🇧🇷")
        XCTAssertEqual(Language.spanish.icon, "🇪🇸")
    }
    
    func testLanguageId() {
        XCTAssertEqual(Language.english.id, "en")
        XCTAssertEqual(Language.portuguese.id, "pt")
        XCTAssertEqual(Language.spanish.id, "es")
    }
    
    func testLanguageAllCases() {
        XCTAssertEqual(Language.allCases.count, 3)
        XCTAssertTrue(Language.allCases.contains(.english))
        XCTAssertTrue(Language.allCases.contains(.portuguese))
        XCTAssertTrue(Language.allCases.contains(.spanish))
    }
}

final class TimerViewModeTests: XCTestCase {
    
    func testTimerViewModeRawValues() {
        XCTAssertEqual(TimerViewMode.digital.rawValue, "Digital")
        XCTAssertEqual(TimerViewMode.circle.rawValue, "Circle")
        XCTAssertEqual(TimerViewMode.battery.rawValue, "Battery")
    }
    
    func testTimerViewModeIconNames() {
        XCTAssertEqual(TimerViewMode.digital.iconName, "timer")
        XCTAssertEqual(TimerViewMode.circle.iconName, "circle.circle")
        XCTAssertEqual(TimerViewMode.battery.iconName, "battery.75")
    }
    
    func testTimerViewModeId() {
        XCTAssertEqual(TimerViewMode.digital.id, "Digital")
        XCTAssertEqual(TimerViewMode.circle.id, "Circle")
        XCTAssertEqual(TimerViewMode.battery.id, "Battery")
    }
    
    func testTimerViewModeAllCases() {
        XCTAssertEqual(TimerViewMode.allCases.count, 3)
        XCTAssertTrue(TimerViewMode.allCases.contains(.digital))
        XCTAssertTrue(TimerViewMode.allCases.contains(.circle))
        XCTAssertTrue(TimerViewMode.allCases.contains(.battery))
    }
}

final class NotificationSoundTests: XCTestCase {
    
    func testNotificationSoundRawValues() {
        XCTAssertEqual(NotificationSound.glass.rawValue, "Glass")
        XCTAssertEqual(NotificationSound.blow.rawValue, "Blow")
        XCTAssertEqual(NotificationSound.bottle.rawValue, "Bottle")
        XCTAssertEqual(NotificationSound.tink.rawValue, "Tink")
        XCTAssertEqual(NotificationSound.submarine.rawValue, "Submarine")
        XCTAssertEqual(NotificationSound.hero.rawValue, "Hero")
    }
    
    func testNotificationSoundId() {
        XCTAssertEqual(NotificationSound.glass.id, "Glass")
        XCTAssertEqual(NotificationSound.submarine.id, "Submarine")
    }
    
    func testNotificationSoundAllCases() {
        XCTAssertEqual(NotificationSound.allCases.count, 6)
        XCTAssertTrue(NotificationSound.allCases.contains(.glass))
        XCTAssertTrue(NotificationSound.allCases.contains(.hero))
    }
}

final class AppColorGradientTests: XCTestCase {
    
    func testColorGradientsCount() {
        XCTAssertEqual(colorGradients.count, 4)
    }
    
    func testColorGradientNames() {
        let names = colorGradients.map { $0.name }
        XCTAssertTrue(names.contains("Sunset"))
        XCTAssertTrue(names.contains("Forest"))
        XCTAssertTrue(names.contains("Ocean"))
        XCTAssertTrue(names.contains("Purple"))
    }
    
    func testColorGradientHasColors() {
        for gradient in colorGradients {
            XCTAssertEqual(gradient.colors.count, 2, "Gradient '\(gradient.name)' should have 2 colors")
        }
    }
    
    func testColorGradientUniqueIds() {
        let ids = colorGradients.map { $0.id }
        let uniqueIds = Set(ids)
        XCTAssertEqual(ids.count, uniqueIds.count, "All gradients should have unique IDs")
    }
}

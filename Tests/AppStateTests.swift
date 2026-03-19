import XCTest
#if canImport(SwiftUI)
import SwiftUI
#endif
@testable import PomoGlassCore

final class AppStateTests: XCTestCase {
    
    var sut: AppState!
    
    override func setUp() {
        super.setUp()
        sut = AppState()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialTimeLeft() {
        XCTAssertEqual(sut.timeLeft, 1500, "Initial time should be 1500 seconds (25 minutes)")
    }
    
    func testInitialTotalTime() {
        XCTAssertEqual(sut.totalTime, 1500, "Initial total time should be 1500 seconds (25 minutes)")
    }
    
    func testInitialIsRunning() {
        XCTAssertFalse(sut.isRunning, "Timer should not be running initially")
    }
    
    func testInitialMode() {
        XCTAssertEqual(sut.mode, "focus", "Initial mode should be 'focus'")
    }
    
    func testInitialSettingsOpen() {
        XCTAssertFalse(sut.isSettingsOpen, "Settings should not be open initially")
    }
    
    // MARK: - timeString() Tests
    
    func testTimeStringFormatting() {
        sut.timeLeft = 1500 // 25:00
        XCTAssertEqual(sut.timeString(), "25:00")
        
        sut.timeLeft = 600 // 10:00
        XCTAssertEqual(sut.timeString(), "10:00")
        
        sut.timeLeft = 65 // 01:05
        XCTAssertEqual(sut.timeString(), "01:05")
        
        sut.timeLeft = 5 // 00:05
        XCTAssertEqual(sut.timeString(), "00:05")
        
        sut.timeLeft = 0 // 00:00
        XCTAssertEqual(sut.timeString(), "00:00")
    }
    
    func testTimeStringWithOddSeconds() {
        sut.timeLeft = 754 // 12:34
        XCTAssertEqual(sut.timeString(), "12:34")
        
        sut.timeLeft = 61 // 01:01
        XCTAssertEqual(sut.timeString(), "01:01")
    }
    
    func testTimeStringPadding() {
        sut.timeLeft = 9 // 00:09
        XCTAssertEqual(sut.timeString(), "00:09")
        
        sut.timeLeft = 59 // 00:59
        XCTAssertEqual(sut.timeString(), "00:59")
        
        sut.timeLeft = 60 // 01:00
        XCTAssertEqual(sut.timeString(), "01:00")
    }
    
    // MARK: - progress() Tests
    
    func testProgressAtStart() {
        sut.timeLeft = 1500
        sut.totalTime = 1500
        XCTAssertEqual(sut.progress(), 1.0, accuracy: 0.001)
    }
    
    func testProgressAtHalfway() {
        sut.timeLeft = 750
        sut.totalTime = 1500
        XCTAssertEqual(sut.progress(), 0.5, accuracy: 0.001)
    }
    
    func testProgressAtEnd() {
        sut.timeLeft = 0
        sut.totalTime = 1500
        XCTAssertEqual(sut.progress(), 0.0, accuracy: 0.001)
    }
    
    func testProgressAtQuarter() {
        sut.timeLeft = 375
        sut.totalTime = 1500
        XCTAssertEqual(sut.progress(), 0.25, accuracy: 0.001)
    }
    
    // MARK: - reset() Tests
    
    func testResetToFocus() {
        sut.reset(to: 25, label: "focus")
        
        XCTAssertEqual(sut.mode, "focus")
        XCTAssertEqual(sut.totalTime, 1500)
        XCTAssertEqual(sut.timeLeft, 1500)
        XCTAssertFalse(sut.isRunning)
    }
    
    func testResetToBreak() {
        sut.reset(to: 5, label: "break")
        
        XCTAssertEqual(sut.mode, "break")
        XCTAssertEqual(sut.totalTime, 300)
        XCTAssertEqual(sut.timeLeft, 300)
        XCTAssertFalse(sut.isRunning)
    }
    
    func testResetToLongBreak() {
        sut.reset(to: 15, label: "long_break")
        
        XCTAssertEqual(sut.mode, "long_break")
        XCTAssertEqual(sut.totalTime, 900)
        XCTAssertEqual(sut.timeLeft, 900)
        XCTAssertFalse(sut.isRunning)
    }
    
    func testResetStopsRunningTimer() {
        sut.isRunning = true
        sut.reset(to: 10, label: "test")
        
        XCTAssertFalse(sut.isRunning, "Reset should stop the timer")
    }
    
    // MARK: - pause() Tests
    
    func testPauseSetsIsRunningToFalse() {
        sut.isRunning = true
        sut.pause()
        
        XCTAssertFalse(sut.isRunning)
    }
    
    // MARK: - toggle() Tests
    
    func testToggleStartsWhenNotRunning() {
        sut.isRunning = false
        sut.toggle()
        
        XCTAssertTrue(sut.isRunning, "Toggle should start timer when not running")
        sut.pause() // Clean up
    }
    
    func testTogglePausesWhenRunning() {
        sut.isRunning = false
        sut.toggle() // Start
        XCTAssertTrue(sut.isRunning)
        
        sut.toggle() // Pause
        XCTAssertFalse(sut.isRunning, "Toggle should pause timer when running")
    }
    
    // MARK: - Translation Tests
    
    func testTranslationFunction() {
        sut.language = .english
        XCTAssertEqual(sut.t("focus"), "Focus")
        
        sut.language = .portuguese
        XCTAssertEqual(sut.t("focus"), "Foco")
        
        sut.language = .spanish
        XCTAssertEqual(sut.t("focus"), "Enfoque")
    }
    
    // MARK: - Theme Gradient Tests
    
    func testThemeGradientReturnsColors() {
        sut.selectedGradientIndex = 0
        XCTAssertEqual(sut.themeGradient.count, 2)
        
        sut.selectedGradientIndex = 1
        XCTAssertEqual(sut.themeGradient.count, 2)
    }
    
    // MARK: - Default Values Tests
    
    func testDefaultFocusDuration() {
        XCTAssertEqual(sut.focusDuration, 25)
    }
    
    func testDefaultShortBreakDuration() {
        XCTAssertEqual(sut.shortBreakDuration, 5)
    }
    
    func testDefaultLongBreakDuration() {
        XCTAssertEqual(sut.longBreakDuration, 15)
    }
    
    func testDefaultLongBreakInterval() {
        XCTAssertEqual(sut.longBreakInterval, 4)
    }
}

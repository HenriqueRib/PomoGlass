# 🍅 PomoGlass

**PomoGlass** is a premium, minimalist Pomodoro timer for macOS that lives entirely in your menu bar. Built with SwiftUI and inspired by iOS design aesthetics, it helps you maintain deep focus without unnecessary distractions.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
![Swift](https://img.shields.io/badge/swift-6.0-orange.svg)

## ✨ Features

- **100% Menu Bar:** No Dock icon or cluttered windows.
- **Modern iOS Aesthetics:** Glassmorphism interface with smooth animations and dynamic gradients.
- **Customizable Views:** Choose between **Digital**, **Circular Ring**, or **Battery Drain** visualization.
- **Multilingual Support:** Fully translated into **English**, **Portuguese**, and **Spanish**.
- **Adjustable Themes:** Multiple gradient presets (Sunset, Forest, Ocean, Purple).
- **Smooth Audio Alerts:** Selectable "soft" sounds for session completion (Glass, Submarine, Tink, etc.).
- **Smart Toggle:** One-click to start/pause focus sessions.
- **Privacy First:** Native macOS notifications for focus alerts.

## 🚀 Getting Started

To run PomoGlass locally:

1. Clone the repository.
2. Run the build script to generate the `.app` bundle:
   ```bash
   chmod +x build.sh
   ./build.sh
   ```
3. Open the application from the `dist/` folder:
   ```bash
   open dist/PomoGlass.app
   ```

## 🧪 Running Tests

PomoGlass includes a comprehensive unit test suite covering models, localization, and app state logic.

To run all tests:

```bash
chmod +x test.sh
./test.sh
```

Or using Swift Package Manager directly:

```bash
swift test
```

### Test Coverage

The test suite includes:

- **AppModelsTests**: Tests for `Language`, `TimerViewMode`, `NotificationSound`, and `AppColorGradient` models
- **LocalizationServiceTests**: Tests for translations across all supported languages (English, Portuguese, Spanish)
- **AppStateTests**: Tests for timer logic, formatting, progress calculation, and state management

## 🛠 Tech Stack & Architecture

- **Language:** Swift 6
- **Framework:** SwiftUI & AppKit
- **Architecture:** MVVM (Model-View-ViewModel) for clean state management.
- **System APIs:** UserNotifications & NSSound for native macOS experience.

## 🤝 Contributing & Developer

Created and maintained with ❤️ by **Henrique Ribeiro** ([HenriqueRib](https://github.com/HenriqueRib)).

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`).
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the Branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

## 🔑 Hotkeys & CLI

PomoGlass supports control via a small command-line helper and can be bound to a global keyboard shortcut using macOS Shortcuts/Automator.

Install the helper (after running ./build.sh the helper will be inside the app bundle):

1. Build the app: 
   chmod +x build.sh && ./build.sh
2. Create a symlink so the helper is on your PATH (adjust path if you moved the app):
   sudo ln -s "$(pwd)/dist/PomoGlass.app/Contents/Helpers/pomodoro" /usr/local/bin/pomodoro

Examples:
- Start a 25 minute focus session: pomodoro start 25
- Pause the timer: pomodoro pause
- Toggle start/pause: pomodoro toggle
- Reset to N minutes: pomodoro reset 10

Binding a global hotkey (example using Shortcuts/Automator):
1. Open the Shortcuts app and create a new Quick Action / Shortcut that runs a shell script.
2. Use the command: /usr/local/bin/pomodoro toggle
3. Assign the keyboard shortcut you want (e.g., ⌥+P) to the shortcut in Shortcuts preferences.

Notes about permissions:
- Mapping global hotkeys with system automation may require granting Shortcuts/Automator permissions in System Settings > Privacy & Security

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

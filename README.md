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

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

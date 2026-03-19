// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "PomoGlass",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "PomoGlassCore",
            targets: ["PomoGlassCore"]
        )
    ],
    targets: [
        .target(
            name: "PomoGlassCore",
            dependencies: [],
            path: "PomoGlass",
            exclude: ["App/PomoGlassApp.swift", "Resources"],
            sources: [
                "Models/AppModels.swift",
                "Services/LocalizationService.swift",
                "ViewModels/AppState.swift"
            ]
        ),
        .testTarget(
            name: "PomoGlassTests",
            dependencies: ["PomoGlassCore"],
            path: "Tests"
        )
    ]
)

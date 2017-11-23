// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "irecon",
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
        .package(url: "https://github.com/stephencelis/SQLite.swift", from: "0.11.4"),
        .package(url: "https://github.com/matthewpalmer/Locksmith", from: "4.0.0")
    ],
    targets: [
        .target(name: "irecon", dependencies: ["Locksmith", "Rainbow", "SQLite"]),
    ]
)

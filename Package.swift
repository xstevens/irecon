// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "irecon",
    products: [
        .executable(name: "irecon", targets: ["irecon"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0")
    ],
    targets: [
        .target(name: "irecon", dependencies: ["Rainbow"]),
    ]
)

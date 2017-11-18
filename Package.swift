import PackageDescription

let package = Package(
    name: "irecon",
    dependencies: [
        .Package(url: "https://github.com/onevcat/Rainbow", "3.0.0")
    ]
)

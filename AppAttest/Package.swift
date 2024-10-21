// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "AppAttest",
    platforms: [
        .iOS(.v14),
        .macCatalyst(.v14),
        .macOS(.v11),
        .tvOS(.v15),
        .visionOS(.v1),
        .watchOS(.v9)
    ],
    products: [
        .library(name: "AppAttest", targets: ["AppAttest"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "AppAttest"),
        .testTarget(
            name: "AppAttestTests",
            dependencies: ["AppAttest"]
        )
    ]
)
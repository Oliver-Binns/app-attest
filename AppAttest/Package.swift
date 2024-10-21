// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "AppAttest",
    platforms: [
        .iOS(.v18)
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

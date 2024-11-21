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
        .library(
            name: "AppAttest",
            targets: ["AppAttest"]
        ),
        .library(
            name: "AttestServer",
            targets: ["AttestationDecoding", "AttestationValidation"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/valpackett/SwiftCBOR.git",
            exact: "0.5.0"
        ),
        .package(
            url: "https://github.com/apple/swift-certificates",
            exact: "1.6.1"
        )
    ],
    targets: [
        .target(name: "AppAttest"),
        .testTarget(
            name: "AppAttestTests",
            dependencies: ["AppAttest"]
        ),

        .target(
            name: "AttestationDecoding",
            dependencies: [
                .product(name: "SwiftCBOR", package: "SwiftCBOR"),
                .product(name: "X509", package: "swift-certificates")
            ]
        ),
        .testTarget(
            name: "AttestationDecodingTests",
            dependencies: ["AttestationDecoding"],
            resources: [.process("Resources")]
        ),

        .target(
            name: "AttestationValidation",
            dependencies: [
                .product(name: "X509", package: "swift-certificates")
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "AttestationValidationTests",
            dependencies: ["AttestationValidation"]
        )
    ]
)

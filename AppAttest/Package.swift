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
            targets: ["AttestationDecoder", "AttestationValidator"]
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
            name: "AttestationDecoder",
            dependencies: [
                .product(name: "SwiftCBOR", package: "SwiftCBOR")
            ]
        ),
        .testTarget(
            name: "AttestationDecoderTests",
            dependencies: ["AttestationDecoder"],
            resources: [.process("Resources")]
        ),

        .target(
            name: "AttestationValidator",
            dependencies: [
                .product(name: "X509", package: "swift-certificates")
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "AttestationValidatorTests",
            dependencies: ["AttestationValidator"]
        )
    ]
)

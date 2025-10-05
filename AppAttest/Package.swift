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
        ),
        .package(
            url: "https://github.com/apple/swift-crypto.git",
            exact: "3.15.1"
        )
    ],
    targets: [
        .target(
            name: "AppAttest",
            dependencies: [.product(name: "Crypto", package: "swift-crypto")]
        ),
        .testTarget(
            name: "AppAttestTests",
            dependencies: ["AppAttest"]
        ),

        .target(
            name: "AttestationDecoding",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "SwiftCBOR", package: "SwiftCBOR"),
                .product(name: "X509", package: "swift-certificates")
            ]
        ),
        .testTarget(
            name: "AttestationDecodingTests",
            dependencies: [
                "AttestationDecoding",
                .product(name: "Crypto", package: "swift-crypto")
            ],
            resources: [.process("Resources")]
        ),

        .target(
            name: "AttestationValidation",
            dependencies: [
                .product(name: "X509", package: "swift-certificates"),
                .product(name: "Crypto", package: "swift-crypto")
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "AttestationValidationTests",
            dependencies: ["AttestationValidation"]
        )
    ]
)

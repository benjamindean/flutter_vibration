// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "vibration",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "vibration", targets: ["vibration"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "vibration",
            dependencies: [],
            resources: [
                .process("Resources/PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)

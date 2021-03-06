// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Canary",
    platforms: [
        .macOS(.v10_13),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/yeokm1/SwiftSerial.git", from: "0.1.1"),
        .package(url: "https://github.com/Flight-School/RegularExpressionDecoder.git", from: "0.1.0"),
        .package(url: "https://github.com/kylef/Commander.git", from: "0.9.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Canary",
            dependencies: ["Commander", "RegularExpressionDecoder", "SwiftSerial"]),
        .testTarget(
            name: "CanaryTests",
            dependencies: ["Canary"]),
    ]
)


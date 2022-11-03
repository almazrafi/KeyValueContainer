// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "KeyValueContainer",
    products: [
        .library(
            name: "KeyValueContainer",
            targets: ["KeyValueContainer"]
        )
    ],
    targets: [
        .target(
            name: "KeyValueContainer",
            path: "Sources"
        ),
        .testTarget(
            name: "KeyValueContainerTests",
            dependencies: ["KeyValueContainer"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)

// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TitanMetric",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "TitanMetric",
            targets: ["TitanMetric"]),
    ],
    dependencies: [
        .package(url: "https://github.com/bermudadigitalstudio/TitanKituraAdapter.git", .upToNextMajor(from: "0.0.0")),
        .package(url: "https://github.com/bermudadigitalstudio/Redshot.git", .upToNextMinor(from:"0.1.0"))  
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "TitanMetric",
            dependencies: ["TitanKituraAdapter","RedShot"]),
        .testTarget(
            name: "TitanMetricTests",
            dependencies: ["TitanMetric"]),
    ]
)
// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "TitanMetric",
    products: [
        .library(name: "TitanMetric", targets: ["TitanMetric"]),
        ],
    dependencies: [
        .package(url: "https://github.com/bermudadigitalstudio/Titan.git", .exact( "0.9.0-beta.3")),
        .package(url: "https://github.com/bermudadigitalstudio/TitanKituraAdapter.git", .exact( "0.9.0-beta.4")),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git",.upToNextMinor(from: "1.5.0")),
    ],
    targets: [
        .target(name: "TitanMetric", dependencies:["Titan","TitanKituraAdapter","SwiftyBeaver"]),
        .testTarget(name: "TitanMetricTests", dependencies: ["TitanMetric"])
    ]
)

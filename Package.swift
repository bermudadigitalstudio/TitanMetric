// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "TitanMetric",
    dependencies: [
        .Package(url: "https://github.com/bermudadigitalstudio/TitanKituraAdapter.git", majorVersion: 0),
        .Package(url: "https://github.com/bermudadigitalstudio/Redshot.git", majorVersion: 0)
    ]
)